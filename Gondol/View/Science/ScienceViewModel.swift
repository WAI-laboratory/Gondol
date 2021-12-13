//
//  ScienceViewModel.swift
//  Gondol
//
//  Created by 이용준 on 2021/12/13.
//

import Foundation
import Combine

class ScienceViewModel: ObservableObject {
    private var subscription = Set<AnyCancellable>()
    
    @Published var text: String? = ""
    @Published var resultString: String = ""
    @Published var models: [PeriodicTableModel] = []
    @Published var resultModel: PeriodicTableModel?
    
    init () {
        something()
        setValues()
    }
    
    private func setValues() {
        
        Publishers.CombineLatest($text, $models)
            .map { [weak self] text, models -> PeriodicTableModel? in
                guard let text = text, text != "" else { return nil }
                guard let self = self else { return nil }
                var model: PeriodicTableModel?
                for mode in models {
                    if mode.symbol.lowercased() == text.lowercased() {
                        model = mode
                    } else if String(mode.atomicNumber) == text {
                        model = mode
                    }
                }
                return model
            }
            .assign(to: &self.$resultModel)

    }
    

    
    private func something(){
        guard let path = Bundle.main.path(forResource: "PeriodicTable", ofType: "json") else { return }
        guard let jsonString = try? String(contentsOfFile: path) else { return }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        do {
            let model = try decoder.decode([PeriodicTableModel].self, from: data!)
            self.models = model
        } catch {
            print(error)
        }
    }
}
