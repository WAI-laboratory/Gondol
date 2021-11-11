//
//  BrailleViewModel.swift
//  Gondol
//
//  Created by 이용준 on 2021/11/12.
//

import Foundation
import Combine


class BrailleViewModel: ObservableObject {
    private var subscription = Set<AnyCancellable>()

    @Published var text: String? = ""
    @Published var resultText: String = ""
    @Published var selectedSegment: Languages = .Korean

    init () {
        Publishers.CombineLatest($selectedSegment, $text)
            .map { _selectedSegment, _title -> String in
                guard let _title = _title else { return "숫자를 입력해주세요!"}
                var _resultText = ""
                switch _selectedSegment {
                case .Korean:
                    let jamo = Jamo.getJamo(_title)
                    for i in jamo {
                        guard let letter = koreanToBraile[String(i)] else { continue }
                        _resultText = _resultText + letter + " "
                    }
                    return _resultText
                case .English:
                    for i in _title {
                        guard let letter = englishToBraille[String(i).lowercased()] else { continue }
                        _resultText = _resultText + letter + " "
                    }
                    return _resultText
                }
            }
            .assign(to: &self.$resultText)
    }
}
