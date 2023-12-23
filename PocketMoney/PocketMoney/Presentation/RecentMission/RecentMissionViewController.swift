//
//  RecentMissionViewController.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

class RecentMissionViewModel {
    var itemSelectedRelay: PublishRelay<Int> = .init()
    
    var dataSource: Driver<[MissionCellItem]>
    var testa: Driver<Int>
    var popDriver: Driver<Void>
    
    init(mission: PublishRelay<String>, price: PublishRelay<Int>) {
        let fetchedItems = NetworkMission.rx.getMissionList(childId: UserDefaultManager.userId, status: nil).map { $0.map { dto in MissionCellItem(missionId: dto.id, status: MissionStatus(rawValue: dto.status) ?? MissionStatus.wait, date: dto.createDate, title: dto.name, price: dto.reward, rejectReason: dto.rejectReason ?? "") }}
            .share()
            
        dataSource = fetchedItems
            .asDriver(onErrorJustReturn: [])
        
        testa = fetchedItems
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        popDriver = itemSelectedRelay
            .withLatestFrom(dataSource) { ($0, $1)}
            .map { $0.1[$0.0] }
            .do { item in
                mission.accept(item.title)
                price.accept(item.price)
            }.map { _ in () }
            .asDriver(onErrorJustReturn: ())
//        let detail:
        // TODO - 서버요청
    }
}

class RecentMissionViewController: BaseViewController {
    
    // MARK: - Binding
    func bind(viewModel: RecentMissionViewModel) {
        
        listView.collectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelectedRelay)
            .disposed(by: disposeBag)
        
        viewModel.popDriver
            .drive(with:self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.dataSource
            .drive(listView.collectionView.rx.items) { cv, row, data in
                guard let cell = cv.dequeueReusableCell(
                    withReuseIdentifier: "mission",
                    for: IndexPath.init(row: row, section: 0)
                ) as? MissionCell else { return UICollectionViewCell() }
                cell.configureCell(with: data)
                return cell
            }.disposed(by: disposeBag)
        
        viewModel.testa
            .drive(with: self ) { owner, c in
                print(c)
                owner.listView.snp.updateConstraints {
                    $0.height.equalTo(c * 100 + 100);
                }

            }.disposed(by: disposeBag)
    }
    // MARK: - Initializer
    init(viewModel: RecentMissionViewModel) {
         super.init()
         setUI()
         bind(viewModel: viewModel)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appendNavigationLeftLabel(title: "최근미션")
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIComponents
    let scrollView: UIScrollView = {
        return $0
    }(UIScrollView())
    
    let contentView = UIView()
    lazy var listView: MissionListView = .init(frame: .zero)
}

extension RecentMissionViewController {
    func setUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(listView)
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constant.width * 20)
            $0.height.equalTo(1000)
            
        }
    }
}

