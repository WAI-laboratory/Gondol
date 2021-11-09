//
//  ConverterViewController.swift
//  Gondol
//
//  Created by 이용준 on 2021/11/09.
//

import Foundation
import UIKit
import SnapKit
import AddThen
import Combine
import CombineCocoa

class ConverterViewController: UIViewController, UITextFieldDelegate {
    var viewModel = ConverterViewModel()
    var subscription = Set<AnyCancellable>()
    
    private var textField = UITextField()
    private var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initView()
        bind()
    }
    
    private func initView() {
        view.add(textField) {
            $0.backgroundColor = .yellow
            $0.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(120)
                make.trailing.leading.equalToSuperview().inset(64)
                make.height.equalTo(32)
            }
        }
        
        view.add(label) {
            $0.snp.makeConstraints { [unowned self] make in
                make.top.equalTo(self.textField).offset(32)
                make.trailing.leading.equalTo(self.textField)
                make.height.equalTo(32)
            }
        }
    }
    
    private func bind() {
        textField.textPublisher
            .assign(to: &viewModel.$title)
        
        viewModel.$title
            .sink { text in
                print(text)
            }
            .store(in: &subscription)
        viewModel.$charToAscii
            .map { texts in
                return texts.joined(separator: "")
            }
            .sink { text in
                self.label.text = text
            }
            .store(in: &subscription)
            
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(1)
        guard let _text = textField.text else { return }
        viewModel.title = _text
    }
}

class ConverterViewModel: ObservableObject {
    private var subscription = Set<AnyCancellable>()

    @Published var title: String? = ""
    @Published var charToAscii: [String] = []

    
    init () {
        $title
            .map { title -> [String] in
                guard let title = title else { return [""] }
                var arr: [String] = []
                for i in title.utf16 {
                    arr.append(String(i))
                    arr.append(" ")
                }
                return arr
            }
            .assign(to: \.charToAscii, on: self)
            .store(in: &subscription)
            
        
    }
    
}

