//
//  MorseViewModel.swift
//  Gondol
//
//  Created by JYG on 2021/11/11.
//

import Foundation
import Combine

class MorseViewModel: ObservableObject {
    private var subscription = Set<AnyCancellable>()

    @Published var text: String? = ""
    @Published var resultText: String = ""
    @Published var selectedSegment: Languages = .Korean

    init () {
        Publishers.CombineLatest($selectedSegment, $text)
            .map { [unowned self] _selectedSegment, _title -> String in
                guard let _title = _title else { return ""}
                var _resultText = ""
                switch _selectedSegment {
                case .Korean:
                    var jamo = Jamo.getJamo(_title)
                    for i in jamo {
                        guard let letter = koreanToMorse[String(i)] else { continue }
                        _resultText = _resultText + letter + "  "
                    }
                    return _resultText
                case .English:
                    for i in _title {
                        guard let letter = englishToMorse[String(i).lowercased()] else { continue }
                        _resultText = _resultText + letter + "  "
                    }
                    return _resultText
                }
            }
            .assign(to: &self.$resultText)
    }
}


enum Languages: Int, CaseIterable {
    case Korean = 0
    case English = 1
    
    var description: String {
        switch self {
        case .Korean: return "Korean"
        case .English: return "English"
        }
    }
}


