//
//  PeriodicTable.swift
//  Gondol
//
//  Created by 이용준 on 2021/12/13.
//

import Foundation
import UIKit

struct PeriodicTableModel: Codable {
    let atomicNumber: Int
    let symbol: String
    let name: String
    let atomicMass: String
    let electronicConfiguration: String
    let electronegativity: Float?
    let atomicRadius: Int?
    let ionRadius: String?
    let vanDerWaalsRadius: Int?
    let ionizationEnergy: Int?
    let electronAffinity: Int?
    let oxidationStates: String?
    let standardState: String?
    let bondingType: String?
    let meltingPoint: Int?
    let boilingPoint: Int?
    let density: Float?
    let groupBlock: String?
    let yearDiscovered: Int?
    let block: String?
    let cpkHexColor: String
    let period: Int
    let group: Int
    
    private enum CodingKeys: String, CodingKey {
        case atomicNumber
        case symbol
        case name
        case atomicMass
        case electronicConfiguration
        case electronegativity
        case atomicRadius
        case ionRadius
        case vanDerWaalsRadius
        case ionizationEnergy
        case electronAffinity
        case oxidationStates
        case standardState
        case bondingType
        case meltingPoint
        case boilingPoint
        case density
        case groupBlock
        case yearDiscovered
        case block
        case cpkHexColor
        case period
        case group
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        atomicNumber = try values.decode(Int.self, forKey: .atomicNumber)
        symbol = try values.decode(String.self, forKey: .symbol)
        name = try values.decode(String.self, forKey: .name)
        atomicMass = try values.decode(String.self, forKey: .atomicMass)
        electronicConfiguration = try values.decode(String.self, forKey: .electronicConfiguration)
        electronegativity = try? values.decode(Float.self, forKey: .electronegativity)
        atomicRadius = try? values.decode(Int.self, forKey: .atomicRadius)
        ionRadius = try? values.decode(String.self, forKey: .ionRadius)
        vanDerWaalsRadius = try? values.decode(Int.self, forKey: .vanDerWaalsRadius)
        ionizationEnergy = try? values.decode(Int.self, forKey: .ionizationEnergy)
        electronAffinity = try? values.decode(Int.self, forKey: .electronAffinity)
        oxidationStates = try? values.decode(String.self, forKey: .oxidationStates)
        standardState = try? values.decode(String.self, forKey: .standardState)
        bondingType = try? values.decode(String.self, forKey: .bondingType)
        meltingPoint = try? values.decode(Int.self, forKey: .meltingPoint)
        boilingPoint = try? values.decode(Int.self, forKey: .boilingPoint)
        density = try? values.decode(Float.self, forKey: .density)
        groupBlock = try? values.decode(String.self, forKey: .groupBlock)
        yearDiscovered = try? values.decode(Int.self, forKey: .yearDiscovered)
        block = try? values.decode(String.self, forKey: .block)
        cpkHexColor = try values.decode(String.self, forKey: .cpkHexColor)
        period = try values.decode(Int.self, forKey: .period)
        group = try values.decode(Int.self, forKey: .group)
    }
}
