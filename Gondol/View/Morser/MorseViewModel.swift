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
    
    init () {
        $text
            .sink { text in
                guard let text = text else { return }
                var resultText = ""
                for i in text {
                    guard let letter = letterToMorse[String(i)] else { return }
                    resultText = resultText + letter
                }
                print(resultText)
            }
            .store(in: &subscription)
        
        $text
            .map { text in
                guard let text = text else { return " 지원 ㄴㄴ"}
                var resultText = ""
                for i in text {
                    guard let letter = letterToMorse[String(i).lowercased()] else { return "지원하지 않아요"}
                    resultText = resultText + letter + " "
                }
                return resultText
            }
            .assign(to: &self.$resultText)
            
        
    }
}



var letterToMorse: [String: String] = [
  "a": ".-",
  "b": "-...",
  "c": "-.-.",
  "d": "-..",
  "e": ".",
  "f": "..-.",
  "g": "--.",
  "h": "....",
  "i": "..",
  "j": ".---",
  "k": "-.-",
  "l": ".-..",
  "m": "--",
  "n": "-.",
  "o": "---",
  "p": ".--.",
  "q": "--.-",
  "r": ".-.",
  "s": "...",
  "t": "-",
  "u": "..-",
  "v": "...-",
  "w": ".--",
  "x": "-..-",
  "y": "-.--",
  "z": "--..",
  " ": " ",
  "  ": "  ",
]
