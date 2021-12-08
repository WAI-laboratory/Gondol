//
//  ConverterViewModel.swift
//  Gondol
//
//  Created by JYG on 2021/11/10.
//

import Foundation
import Combine

class ConverterViewModel: ObservableObject {
    private var subscription = Set<AnyCancellable>()
    
    @Published var selectedSegment: Converter = .Ascii
    
    @Published var title: String? = ""
    @Published var resultString: String = ""
    
    init () {
        setValues()
    }
    
    private func setValues() {
        Publishers.CombineLatest($selectedSegment, $title)
            .map { [unowned self] _selectedSegment, _title -> String in
                guard let _title = _title else { return "EnterNumber".localized}
                switch _selectedSegment {
                case .Ascii:
                    let a = self.stringToAsciiStrings(_title).joined(separator: "")
                    return a
                case .Hex:
                    guard let number = Int(_title) else { return "EnterNumber".localized}
                    return String(number, radix: 16)
                case .Binary:
                    guard let number = Int(_title) else { return "EnterNumber".localized}
                    return String(number, radix: 2)
                }
            }
            .assign(to: &self.$resultString)
    }
    
    private func stringToAsciiStrings(_ text: String?) -> [String] {
        guard let title = text else { return ["EnterNumber".localized] }
        if title == "" { return ["EnterNumber".localized] }
        var arr: [String] = []
        for i in title.utf8 {
            arr.append(String(i))
            arr.append(" ")
        }
        return arr
    }
}

enum Converter: Int, CaseIterable {
    case Ascii = 0
    case Hex = 1
    case Binary = 2
    
    var description: String {
        switch self {
        case .Ascii: return "Ascii"
        case .Hex: return "Hex"
        case .Binary: return "Binary"
        }
    }
}
