//
//  MorseViewController.swift
//  Gondol
//
//  Created by JYG on 2021/11/10.
//

import UIKit
import Combine
import CombineCocoa

class MorseViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    private var subscription = Set<AnyCancellable>()

    private var label = UILabel()
    private var subLabel = UILabel()
    private var fakeLabel = UILabel()
    
    private var buttonStackView = UIStackView()
    private var copyButton = UIButton()
    private var clearButton = UIButton()
    private var textView = UITextView()
    private var viewModel = MorseViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clubhouseBackground
        textView.delegate = self
        initView()
        bind()
    }
    
    private func initView() {
        view.add(label) {
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.numberOfLines = 0
            $0.layer.cornerRadius = 32
            $0.lineBreakMode = .byWordWrapping

            $0.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(64)
                make.leading.trailing.equalToSuperview().inset(32)
                make.height.equalTo(256)
            }
        }
        
        view.add(buttonStackView) { [unowned self] in
            $0.distribution = .fillEqually
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.label.snp.bottom).offset(16)
                make.trailing.leading.equalToSuperview().inset(64)
                make.height.equalTo(32)
            }
            $0.addArranged(self.copyButton) { [unowned self] in
                $0.setTitle("복사하기", for: .normal)
                $0.setTitleColor(.secondaryLabel, for: .normal)
                $0.addTarget(self, action: #selector(self.copyText(_:)), for: .touchUpInside)
            }
            
            $0.addArranged(self.clearButton) { [unowned self] in
                $0.setTitle("지우기", for: .normal)
                $0.setTitleColor(.secondaryLabel, for: .normal)
                $0.addTarget(self, action: #selector(self.clearText(_:)), for: .touchUpInside)
            }
        }
    
        view.add(subLabel) { [unowned self] in
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.buttonStackView.snp.bottom).offset(16)
                make.leading.trailing.equalTo(self.label)
                make.height.equalTo(32)
            }
        }
        
        view.add(textView) { [unowned self] in
            $0.font = .systemFont(ofSize: 20, weight: .light)
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .white.withAlphaComponent(0.4)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.subLabel.snp.bottom)
                make.leading.trailing.equalTo(self.label)
                make.height.equalTo(196)
            }
        }
        view.add(fakeLabel) {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .lightGray
            $0.textAlignment = .center
            $0.text = "입력해주세요"
            $0.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(self.textView).inset(8)
            }
        }
    }
    
    private func bind() {
        textView.textPublisher
            .assign(to: &viewModel.$text)

        
        viewModel.$resultText
            .sink { text in
                self.label.text = text
            }
            .store(in: &subscription)
        viewModel.$text
            .map({ text -> String in
                guard let text = text else { return ""}
                if text.count < 30 {
                    return "글자수: \(text.count)"
                } else if text.count < 60 {
                    return "흠..? 글자수: \(text.count )"
                } else {
                    return "넘많아!!!"
                }
            })
            .assign(to: \.text, on: self.subLabel)
            .store(in: &subscription)
        
        viewModel.$text
            .map({ text -> Bool in
                guard let text = text else { return false }
                return text.count == 0 ? false : true
            })
            .assign(to: \.isHidden, on: self.fakeLabel)
            .store(in: &subscription)
            
        
        copyButton.tapPublisher
            .map({ _ -> String in
                return "복사되었습니다."
            })
            .assign(to: \.text, on: self.subLabel)
            .store(in: &subscription)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc
    func clearText(_ sender: UIButton) {
        self.textView.text = ""
        self.label.text = ""
        self.subLabel.text = ""
    }
    
    @objc
    func copyText(_ sender: UIButton) {
        if let text = self.label.text {
            UIPasteboard.general.string = text
        } else {
            UIPasteboard.general.string = ""
        }
    }
}
