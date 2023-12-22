//
//  MissionDetailViewController.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/21.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
enum MissionStatus: Int, CaseIterable{
    case wait, request, approve, refuse
    
    func hex() -> String {
        switch self {
        case .wait:
            return "#636366FF"
        case .request:
            return "#00FF00FF"
        case .approve:
            return "#0000FFFF"
        case .refuse:
            return "#FF00000FF"
        }
    }
    func detailMent() -> String {
        switch self {
        case .wait:
            return "asd"
        case .request:
            return "asda"
        case .approve:
            return "3"
        case .refuse:
            return "4"
        }
    }
    
    func toString() -> String {
        switch self {
        case .wait:
            return "대기중"
        case .request:
            return "완료요청"
        case .approve:
            return "승인됨"
        case .refuse:
            return "거절됨"
        }
    }
}


class MissionDetailViewModel {
    let isChild = UserDefaultManager.isChild
    // 대기중, 아이 -> 완료요청
    // 완료요청, 부모 -> 승인, 반려
    let viewDidLoadRelay = PublishRelay<Void>()
    
    init(missionId: Int) {
//        let detail:
        // TODO - 서버요청
    }
}



class MissionDetailViewController: BaseViewController {
    // MARK: - Properties
    
    
    // MARK: - Binding
    func bind(viewModel: MissionDetailViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.viewDidLoadRelay)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initializer
    init(viewModel: MissionDetailViewModel) {
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

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - UIComponents
    let nickNameLabel: UILabel = {
        $0.text = "예쁜 아이"
        $0.textColor = .init(hex: "#850DFFFF")
        $0.font = .boldSystemFont(ofSize: 36)
        return $0
    }(UILabel())
    
    let nameLabel: UILabel = {
        $0.text = "김금쪽이"
        $0.font = .systemFont(ofSize: 34)
        return $0
    }(UILabel())
    
    let descriptionLabel: UILabel = {
        $0.text = "할 수 있는 미션이에요"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 34)
        return $0
        
    }(UILabel())
    let additionalDescriptionLabel: UILabel = {
        $0.isHidden = true
        $0.text = "승인하면 용돈이\n즉시 송금됩니다."
        $0.font = .systemFont(ofSize: 34)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    let statusView: StatusView = .init(status: .wait)
    
    let missionView: UIView = {
        $0.backgroundColor = .white
        $0.layer.applyShadow(color: .black)
        $0.layer.cornerRadius = 20
        return $0
    }(UIView())
    
    let missionLabel: UILabel = {
        $0.text = "준비중"
        $0.font = .boldSystemFont(ofSize: 30)
        return $0
    }(UILabel())
    
    let priceLabel: UILabel = {
        $0.text = "준비중"
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .init(hex: "#850DFFFF")
        return $0
    }(UILabel())
    
    let approveButtonView: CommonButtonView = .init(text: "승인", backgroundColor: .init(hex: "#0057FFFF"))
    
    let refuseButtonView: CommonButtonView = .init(text: "반려", backgroundColor: .init(hex: "#E6388DFF"))
    
    let requestButtonView: CommonButtonView = .init(text: "완료 요청", backgroundColor: .init(hex: "#850DFFFF"))
}

extension MissionDetailViewController {
    func setUI() {
        [nickNameLabel, nameLabel, descriptionLabel, additionalDescriptionLabel, missionView, statusView, missionLabel, priceLabel].forEach {
            view.addSubview($0)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel)
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(5)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        additionalDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(25)
            $0.leading.equalTo(nickNameLabel)
        }
        missionView.snp.makeConstraints {
            $0.top.equalTo(additionalDescriptionLabel.snp.bottom).offset(40)
            $0.height.equalTo(Constant.height * 160)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        statusView.snp.makeConstraints {
            $0.centerX.equalTo(missionView)
            $0.centerY.equalTo(missionView).offset(-60)
            $0.width.equalTo(Constant.width * 60)
            $0.height.equalTo(Constant.height * 20)
        }
        
        missionLabel.snp.makeConstraints {
            $0.centerX.equalTo(missionView)
            $0.centerY.equalTo(missionView)
        }
        priceLabel.snp.makeConstraints {
            $0.centerX.equalTo(missionView)
            $0.centerY.equalTo(missionView).offset(40)
        }
        
        [approveButtonView, refuseButtonView, requestButtonView].forEach {
            view.addSubview($0)
        }
        
        approveButtonView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalToSuperview().multipliedBy(0.41)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.height.equalTo(Constant.height * 70)
        }
        
        refuseButtonView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalToSuperview().multipliedBy(0.41)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.height.equalTo(Constant.height * 70)
        }
        
        requestButtonView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Constant.height * 70)
        }
        requestButtonView.isHidden = true
    }
}

