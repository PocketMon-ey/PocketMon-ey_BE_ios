//
//  MissionAddViewController.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

class MissionAddViewModel {
    let mission: PublishRelay<String> = .init()
    let price: PublishRelay<Int> = .init()
    let addTrigger = PublishRelay<Void>()
    let popDriver: Driver<Void>
//    let alertDriver: Driver<String>
    
    init() {
        popDriver =
        addTrigger
            .withLatestFrom(mission)
            .withLatestFrom(price) { ($0, $1) }
            .flatMap { NetworkMission.rx.addMission(childId: 2, mission: $0.0, reward: $0.1) }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
//        alertDriver =
    }
}

class MissionAddViewController: BaseViewController {
    // MARK: - Propertie
    
    // MARK: - Binding
    func bind(viewModel: MissionAddViewModel) {
        
        missionTextField.rx.text.orEmpty
            .bind(to: viewModel.mission)
            .disposed(by: disposeBag)
        
        viewModel.mission
            .distinctUntilChanged()
            .bind(to: missionTextField.rx.text)
            .disposed(by: disposeBag)
        
        priceTextField.rx.text.orEmpty
            .compactMap { Int($0) }
            .bind(to: viewModel.price)
            .disposed(by: disposeBag)
        
        viewModel.price
            .distinctUntilChanged()
            .map { "\($0)" }
            .bind(to: priceTextField.rx.text)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.updateView(with: keyboardVisibleHeight)
            }.disposed(by: disposeBag)
        
        nextView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .filter { owner, _ in owner.validCheck() }
            .map { _ in () }
            .do { [weak self] _ in self?.nextView.isUserInteractionEnabled = false }
            .bind(to: viewModel.addTrigger)
            .disposed(by: disposeBag)
        
        nextView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .filter { owner, _ in !owner.validCheck() }
            .withUnretained(self)
            .bind { owner, _ in
                let vc = OneButtonAlertViewController(viewModel: .init(content: "입력을 확인해주세요", buttonText: "확인", textColor: .black))
                owner.present(vc, animated: true)
            }.disposed(by: disposeBag)
        
        goMissionBoxLabel.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                let vc = RecentMissionViewController(viewModel: .init(mission: viewModel.mission, price: viewModel.price))
                owner.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.popDriver
            .drive(with: self) { owner, _ in
                UserDefaultManager.addCount += 1
                let vc = OneButtonAlertViewController(viewModel: .init(content: "등록되었습니다.", buttonText: "확인", textColor: .black))
                owner.present(vc, animated: true)
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    func updateView(with height: CGFloat) {
         print(height)
         nextView.snp.updateConstraints {
             $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(
                 height == 0
                 ? Constant.height * 5
                 : height - Constant.height * 20
             )
         }
         UIView.animate(withDuration: 0.2) {
             self.view.layoutIfNeeded()
         }
     }
    
    func validCheck() -> Bool {
        if let mission = missionTextField.text,
           let price = priceTextField.text?.moneyInt()
        {
        return mission != "" && price > 0 && price < 50000000
        }
        return false
    }
    
    // MARK: - Initializer
    init(viewModel: MissionAddViewModel) {
        super.init()
        bind(viewModel: viewModel)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appendNavigationLeftLabel(title: "미션등록")
    }
    
    // MARK: - UIComponents
    let titleLabel: UILabel = {
        $0.text = "미션을 등록해볼까요?"
        $0.font = .boldSystemFont(ofSize: 25)
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())
    
    let descriptionsLabel: UILabel = {
        $0.text = "미션과 함께 금액을 설정해주세요.\n보호자든, 아이든 자유롭게 신청하고 미션을 수행해보세요!"
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .gray
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())
    
    let missionLabel: UILabel = {
        $0.text = "미션"
        $0.font = .boldSystemFont(ofSize: 17)
        return $0
    }(UILabel())
    let missionTextField: UITextField = {
        $0.placeholder = "예) 설거지"
        $0.backgroundColor = .white
        return $0
    }(UITextField())
    
    let tipLabel: UILabel = {
        $0.text = "tip: 스스로 납득이 가능한 미션인지 생각해보세요."
        $0.textColor = .init(hex: "#850DFFFF")
        $0.font = .boldSystemFont(ofSize: 11)
        return $0
    }(UILabel())
    
    let priceLabel: UILabel = {
        $0.text = "금액"
        $0.font = .boldSystemFont(ofSize: 17)
        return $0
    }(UILabel())
    
    let priceTextField: UITextField = {
        $0.placeholder = "예) 9900"
        $0.backgroundColor = .white
        $0.keyboardType = .numberPad
        return $0
    }(UITextField())
    
    let wonLabel: UILabel = {
        $0.text = "원"
        $0.font = .boldSystemFont(ofSize: 17)
        return $0
    }(UILabel())
    
    let nextView: CommonButtonView = {
        return $0
    }(CommonButtonView(text: "다음", backgroundColor: .init(hex: "#850DFFFF")))
    
    let goMissionBoxLabel: UILabel = {
        $0.text = "미션함에서 찾기->"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .init(hex: "#850DFFFF")
        return $0
    }(UILabel())
}

extension MissionAddViewController {
    func setUI() {
        [titleLabel, descriptionsLabel, missionLabel, missionTextField, tipLabel, priceLabel, priceTextField, wonLabel, nextView, goMissionBoxLabel].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.height * 25)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionsLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        missionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionsLabel.snp.bottom).offset(Constant.height * 40)
            $0.leading.equalToSuperview().inset(20)
        }
        missionTextField.snp.makeConstraints {
            $0.top.equalTo(missionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(45)
            $0.height.equalTo(Constant.height * 45)
        }
        
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(missionTextField.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(tipLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(20)
        }
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(Constant.height * 45)
        }
        wonLabel.snp.makeConstraints {
            $0.centerY.equalTo(priceTextField)
            $0.trailing.equalToSuperview().inset(10)
        }
        goMissionBoxLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(40)
            $0.trailing.equalToSuperview().inset(5)
        }
        nextView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constant.height * 10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Constant.height * 50)
        }
    }
}
