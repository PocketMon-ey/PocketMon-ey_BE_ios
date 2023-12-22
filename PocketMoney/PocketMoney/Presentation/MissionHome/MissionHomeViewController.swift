//
//  MissionHomeViewController.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/21.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MissionHomeViewController: BaseViewController {
    // MARK: - Properties
    
    
    // MARK: - Binding
    func bind(viewModel: MissionHomeViewModel) {
        rx.viewDidLoad
            .do { _ in viewModel.status.accept(0) }
            .bind(to: viewModel.viewDidLoadRelay)
            .disposed(by: disposeBag)
        
        listView.collectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelectedRelay)
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .drive(listView.collectionView.rx.items) { cv, row, data in
                guard let cell = cv.dequeueReusableCell(
                    withReuseIdentifier: "mission",
                    for: IndexPath.init(row: row, section: 0)
                ) as? MissionCell else { return UICollectionViewCell() }
                cell.configureCell(with: data)
                return cell
            }.disposed(by: disposeBag)

        viewModel.statusChangeDriver
            .drive(with: self) { owner, status in
                owner.buttons.forEach {
                    $0.disSelect()
                }
                owner.buttons[status].select()
            }.disposed(by: disposeBag)
    
        viewModel.missionCompleteTextDriver
            .drive(missionCompleteLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.creditRatingTextDriver
            .drive(creditRatingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.showDetailViewDriver
            .drive(with: self) { owner, vm in
                let vc = MissionDetailViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
            
        addButtonImageView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                let vc = MissionAddViewController(viewModel: .init())
                owner.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        buttons.forEach { button in
            button.rx.tap
                .map { button.tag }
                .bind(to: viewModel.status)
                .disposed(by: disposeBag)
        }
        
        viewModel.testa
            .drive(with: self ) { owner, c in
                print(c)
                owner.listView.snp.updateConstraints {
                    $0.height.equalTo(c * 100 + 100);
                }

            }.disposed(by: disposeBag)
    }
    
    

    
    // MARK: - Initializer
    init(viewModel: MissionHomeViewModel) {
        super.init()
        bind(viewModel: viewModel)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureStackView()
        setNavigationBackgroundColor(color: .black.withAlphaComponent(0))
        appendNavigationLeftBackButton(color: .white)
        let temp = UIView()
        temp.backgroundColor = .red
        appendNavigationLeftCustomView(temp)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationBackgroundColor(color: .blue)
    }
    
    // MARK: - UIComponents
    let scrollView: UIScrollView = {
        return $0
    }(UIScrollView())
    
    let contentView = UIView()
    
    let titleView: UIView = {
        $0.backgroundColor = .init(hex: "#E6388DFF")
        $0.layer.cornerRadius = 5
        return $0
    }(UIView())
    
    let titleLabel: UILabel = {
           $0.textColor = .white
           $0.adjustsFontSizeToFitWidth = true
           return $0
       }(UILabel(frame: .init(x: 0, y: 0, width: 200, height: 30)))
    
    let missionCompleteLabel: UILabel = {
           $0.textColor = .white
           $0.adjustsFontSizeToFitWidth = true
           return $0
       }(UILabel())
    
    let creditRatingLabel: UILabel = {
        $0.textColor = .white
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())
    
    let HStackView: UIStackView = {
        return $0
    }(UIStackView())
    
    let missionAllButton: TabButton = {
        return $0
    }(TabButton(tag: 0, text: "전체"))
    
    let approveButton: TabButton = {
        return $0
    }(TabButton(tag: 1, text: "완료승인"))
    
    let finishButton: TabButton = {
        return $0
    }(TabButton(tag: 2, text: "종료"))
    
    lazy var listView = MissionListView()
    
    let addButtonImageView: UIImageView = {
        $0.image = UIImage(named: "plus")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    lazy var buttons: [TabButton] = [missionAllButton, approveButton, finishButton]
}

extension MissionHomeViewController {
    
    func configureStackView() {
        HStackView.axis = .horizontal
        HStackView.distribution = .fillEqually
        
        [missionAllButton, approveButton, finishButton].forEach {
            HStackView.addArrangedSubview($0)
        }
        
        HStackView.spacing = Constant.height * 20
    }
    
    func setUI() {
        view.addSubview(scrollView)
        view.addSubview(addButtonImageView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [titleView, missionCompleteLabel, creditRatingLabel, HStackView, listView].forEach {
            contentView.addSubview($0)
        }
        
        titleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Constant.height * 70)
            $0.top.equalToSuperview().inset(Constant.height * 35)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        missionCompleteLabel.snp.makeConstraints {
            $0.top.leading.equalTo(titleView).inset(5)
        }
        
        creditRatingLabel.snp.makeConstraints {
            $0.top.equalTo(missionCompleteLabel.snp.bottom).offset(5)
            $0.leading.equalTo(missionCompleteLabel)
        }
        
        HStackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(10)
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(Constant.height * 25)
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(HStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1000)
        }
        addButtonImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.width.equalTo(Constant.width * 60)
            $0.height.equalTo(Constant.height * 60)
            $0.centerX.equalToSuperview()
        }
    }
}

