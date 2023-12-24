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

class MissionDetailViewController: BaseViewController {
    // MARK: - Properties
    let refuseCompleteRelay = PublishRelay<String>()
    
    // MARK: - Binding
    func bind(viewModel: MissionDetailViewModel) {
        refuseCompleteRelay
            .debug("💡💡💡💡💡")
            .bind(to: viewModel.reasonRelay)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { _ in () }
            .bind(to: viewModel.viewWillAppearRelay)
            .disposed(by: disposeBag)
        
        refuseButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .withUnretained(self)
            .bind { owner, _ in
                let vc = WebViewController(linkString: "http://localhost:3000/parent/mission/reject")
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            }.disposed(by: disposeBag)
        
        approveButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind(to: viewModel.approveTrigger)
            .disposed(by: disposeBag)
        
        requestButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind(to: viewModel.requestTrigger)
            .disposed(by: disposeBag)
        
        viewModel.requestButtonIsHiddenDriver
            .drive(with: self) { owner, isHidden in
                owner.additionalDescriptionLabel.isHidden = isHidden
                owner.requestButtonView.isHidden = isHidden
            }.disposed(by: disposeBag)
        
        viewModel.twoButtonsIsHiddenDriver
            .drive(with: self) { owner, isHidden in
                owner.approveButtonView.isHidden = isHidden
                owner.refuseButtonView.isHidden = isHidden
            }.disposed(by: disposeBag)
        
        viewModel.popDriver
            .drive(with: self) { owner, _ in
                let vc = OneButtonAlertViewController(viewModel: .init(content: "완료되었습니다.", buttonText: "확인", textColor: .black))
                owner.present(vc, animated: true)
                owner.navigationController?.popViewController(animated: true)
                
            }.disposed(by: disposeBag)
        
        viewModel.statusDriver
            .drive(with: self) { owner, status in
                if status == .request {
                    owner.descriptionLabel.text = "해당 미션을 완료했어요!"
                } else if status == .approve {
                    owner.descriptionLabel.text = "해당 미션을 완료한 뒤\n돈을 받았어요!"
                } else if status == .refuse {
                    owner.descriptionLabel.text = "해당 미션을 완료했지만\n거절당했어요.."
                }
                owner.statusView.setStatus(status: status)
            }.disposed(by: disposeBag)
        viewModel.missionDriver
            .drive(missionLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.priceDriver
            .drive(priceLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.refuseDriver
            .drive(refuseLabel.rx.text)
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
        appendNavigationLeftLabel(title: "미션상세")
        // Do any additional setup after loading the view.
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
    
    let approveButtonView: CommonButtonView = {
        $0.isHidden = true
        return $0
    }(CommonButtonView(text: "승인", backgroundColor: .init(hex: "#0057FFFF")))
    
    let refuseButtonView: CommonButtonView = {
        $0.isHidden = true
        return $0
    }(CommonButtonView(text: "반려", backgroundColor: .init(hex: "#E6388DFF")))
    
    let requestButtonView: CommonButtonView = {
        $0.isHidden = true
        return $0
    }(CommonButtonView(text: "완료 요청", backgroundColor: .init(hex: "#850DFFFF")))
    
    let refuseLabel: UILabel = {
        $0.textColor = .init(hex: "#850DFFFF")
        $0.font = .boldSystemFont(ofSize: 36)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
}

extension MissionDetailViewController {
    func setUI() {
        [nickNameLabel, nameLabel, descriptionLabel, additionalDescriptionLabel, missionView, statusView, missionLabel, priceLabel, refuseLabel].forEach {
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
        
        refuseLabel.snp.makeConstraints {
            $0.top.equalTo(missionView.snp.bottom).offset(20)
            $0.leading.equalTo(nickNameLabel)
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
