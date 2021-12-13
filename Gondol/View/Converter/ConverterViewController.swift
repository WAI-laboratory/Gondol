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

class ConverterViewController: UIViewController {
    private var viewModel = ConverterViewModel()
    private var subscription = Set<AnyCancellable>()

    private var segmentArray: [String] = []
    
    private var textField = UITextField()
    private var label = UILabel()
    private lazy var segment = UISegmentedControl(items: segmentArray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .clubhouseBackground
        initView()
        bind()
    }
    
    private func initView() {
        view.add(textField) {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 4
            $0.backgroundColor = .white
            $0.keyboardType = .numbersAndPunctuation
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.trailing.leading.equalToSuperview().inset(64)
                make.height.equalTo(32)
            }
        }
        
        view.add(label) {
            $0.textAlignment = .center
            $0.snp.makeConstraints { [unowned self] make in
                make.top.equalTo(self.textField).offset(32)
                make.trailing.leading.equalTo(self.textField)
                make.height.equalTo(32)
            }
        }
        
        view.add(segment) {
            $0.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium)], for: .normal)
            $0.removeAllSegments()
            Converter.allCases.enumerated().forEach { [unowned self] index, value in
                self.segment.insertSegment(withTitle: value.description, at: index, animated: true)
            }
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.label.snp.bottom).offset(12)
                make.trailing.leading.equalTo(self.textField)
                make.height.equalTo(32)
            }
            $0.selectedSegmentIndex = 0
        }
    }
    
    private func bind() {
        textField.textPublisher
            .assign(to: &viewModel.$title)
        
        segment.selectedSegmentIndexPublisher
            .map({ number in
                guard let converter = Converter(rawValue: number) else { return .Ascii}
                return converter
            })
            .assign(to: &viewModel.$selectedSegment)
        
        viewModel.$resultString
            .sink { text in
                self.label.text = text
            }
            .store(in: &subscription)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
