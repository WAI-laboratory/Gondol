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
    
    private var segmentArray: [String] = ["Korean", "English"]
    private lazy var segment = UISegmentedControl(items: segmentArray)


    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Morse".localized
//        self.title = "mTitle".localized
//        self.title = "wqcwecw"
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
                make.top.equalToSuperview().offset(32)
                make.leading.trailing.equalToSuperview().inset(32)
                make.height.equalTo(120)
            }
        }
        view.add(segment) {
            $0.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium)], for: .normal)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.label.snp.bottom).offset(16)
                make.trailing.leading.equalTo(self.label)
                make.height.equalTo(32)
            }
            $0.selectedSegmentIndex = 0
        }
        
        view.add(buttonStackView) { [unowned self] in
            $0.distribution = .fillEqually
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.segment.snp.bottom).offset(16)
                make.trailing.leading.equalToSuperview().inset(64)
                make.height.equalTo(32)
            }
            $0.addArranged(self.copyButton) { [unowned self] in
                $0.setTitle("copy".localized, for: .normal)
                $0.setTitleColor(.secondaryLabel, for: .normal)
                $0.addTarget(self, action: #selector(self.copyText(_:)), for: .touchUpInside)
            }
            
            $0.addArranged(self.clearButton) { [unowned self] in
                $0.setTitle("clear".localized, for: .normal)
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
            $0.text = "EnterWords".localized
            $0.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(self.textView).inset(8)
            }
        }
    }
    
    private func bind() {
        textView.textPublisher
            .assign(to: &viewModel.$text)
        
        segment.selectedSegmentIndexPublisher
            .map({ number in
                guard let language = Languages(rawValue: number) else { return .Korean}
                return language
            })
            .assign(to: &viewModel.$selectedSegment)

        
        viewModel.$resultText
            .sink { text in
                self.label.text = text
            }
            .store(in: &subscription)
        viewModel.$text
            .map({ text -> String in
                guard let text = text else { return ""}
                if text.count < 30 {
                    return "\("wordsCount".localized): \(text.count)"
                } else if text.count < 60 {
                    return "\("wordsUnder30".localized): \(text.count )"
                } else {
                    return "wordsMany".localized
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
                return "copied".localized
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
