//
//  MorseViewController.swift
//  Gondol
//
//  Created by JYG on 2021/11/10.
//

import UIKit
import Combine
import CombineCocoa
import GoogleMobileAds

class MorseViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, GADBannerViewDelegate {
    private var subscription = Set<AnyCancellable>()

    private var label = UILabel()
    private var subLabel = UILabel()
    private var fakeLabel = UILabel()
    
    private var buttonStackView = UIStackView()
    private var copyButton = UIButton()
    private var clearButton = UIButton()
    private var textView = UITextView()
    private var viewModel = MorseViewModel()
    private var bannerView = GADBannerView()
    private let fullAdUnit = "ca-app-pub-4294379690418901/9830139399"
    
    private var interstitial: GADInterstitialAd?
    
    private var segmentArray: [String] = ["Korean", "English"]
    private lazy var segment = UISegmentedControl(items: segmentArray)


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Morse".localized
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .search, primaryAction: UIAction(handler: {[weak self] action in
            guard let self = self else { return }
            self.navigationController?.pushViewController(MorseTableViewController(), animated: true)
        }))
        bannerView.adUnitID = "ca-app-pub-4294379690418901/5357758608"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self


        view.backgroundColor = .clubhouseBackground
        textView.delegate = self
        initView()
        bind()
        
    }
    
    private func initView() {
        view.add(textView) { [unowned self] in
            $0.font = .systemFont(ofSize: 20, weight: .light)
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .white
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.leading.trailing.equalToSuperview().inset(32)
                make.height.equalToSuperview().multipliedBy(0.18)
            }
        }
        
        view.add(buttonStackView) { [unowned self] in
            $0.distribution = .fillEqually
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.textView.snp.bottom).offset(12)
                make.trailing.leading.equalToSuperview().inset(64)
                make.height.equalTo(24)
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
                make.top.equalTo(self.buttonStackView.snp.bottom).offset(12)
                make.leading.trailing.equalTo(self.textView)
                make.height.equalTo(24)
            }
        }
        
        view.add(label) {
            $0.backgroundColor = .white.withAlphaComponent(0.4)
            $0.clipsToBounds = true
            $0.numberOfLines = 0
            $0.layer.cornerRadius = 32
            $0.lineBreakMode = .byWordWrapping

            $0.snp.makeConstraints { make in
                make.top.equalTo(self.subLabel.snp.bottom)
                make.leading.trailing.equalTo(self.textView)
                make.height.equalToSuperview().multipliedBy(0.18)
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
        
        view.add(segment) {
            $0.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium)], for: .normal)
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.label.snp.bottom).offset(12)
                make.trailing.leading.equalTo(self.textView)
                make.height.equalTo(32)
            }
            $0.selectedSegmentIndex = 0
        }
        
        view.add(bannerView) {
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.segment.snp.bottom).offset(24)
                make.leading.trailing.equalTo(self.textView)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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
                if text.count < 12 {
                    return "\("wordsCount".localized): \(text.count)"
                } else if text.count < 30 {
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
    private func setFullAd() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: fullAdUnit,
            request: request,
            completionHandler: { [weak self] ad, error in
                if let error {
                    print("❤️‍🔥 \(error)")
                }
                self?.interstitial = ad
                self?.showFullAd()
            })
    }
    
    private func showFullAd() {
        if let interstitial = self.interstitial {
            print("❤️‍🔥aa")
            interstitial.present(fromRootViewController: self)
        }
    }
}
