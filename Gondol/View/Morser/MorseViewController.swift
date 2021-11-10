//
//  MorseViewController.swift
//  Gondol
//
//  Created by JYG on 2021/11/10.
//

import UIKit
import Combine
import CombineCocoa

class MorseViewController: UIViewController {
    private var subscription = Set<AnyCancellable>()

    private var label = UILabel()
    private var textField = UITextField()
    
    private var viewModel = MorseViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clubhouseBackground
        initView()
        bind()

        // Do any additional setup after loading the view.
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
        
        view.add(textField) {
            $0.backgroundColor = .red
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.label.snp.bottom).offset(32)
                make.leading.trailing.equalTo(self.label)
                make.height.equalTo(32)
            }
        }
    }
    
    private func bind() {
        textField.textPublisher
            .assign(to: &viewModel.$text)
        
        viewModel.$resultText
            .sink { text in
                self.label.text = text
            }
            .store(in: &subscription)
    }

}
