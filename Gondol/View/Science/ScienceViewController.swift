//
//  ScienceViewController.swift
//  Gondol
//
//  Created by 이용준 on 2021/12/13.
//

import Foundation
import UIKit
import SnapKit
import AddThen
import Combine
import CombineCocoa
import GoogleMobileAds

class ScienceViewController: UIViewController {
    private var viewModel = ScienceViewModel()
    private var subscription = Set<AnyCancellable>()

    private var segmentArray: [String] = []
    private var textField = UITextField()
    private var label = UILabel()
    private var views: [UILabel] = []
    
    private let atomicNumberLabel = UILabel()
    private let symbolLabel = UILabel()
    private let nameLabel = UILabel()
    private let atomicMassLabel = UILabel()
    private let electronicConfigurationLabel = UILabel()
    private let electronegativityLabel = UILabel()
    private let atomicRadiusLabel = UILabel()
    private let ionRadiusLabel = UILabel()
    private let vanDerWaalsRadiusLabel = UILabel()
    private let ionizationEnergyLabel = UILabel()
    private let electronAffinityLabel = UILabel()
    private let oxidationStatesLabel = UILabel()
    private let standardStateLabel = UILabel()
    private let bondingTypeLabel = UILabel()
    private let meltingPointLabel = UILabel()
    private let boilingPointLabel = UILabel()
    private let densityLabel = UILabel()
    private let groupBlockLabel = UILabel()
    private let yearDiscoveredLabel = UILabel()
    private let blockLabel = UILabel()
    private let cpkHexColorLabel = UILabel()
    private let periodLabel = UILabel()
    private let groupLabel = UILabel()
    private let fullAdUnit = "ca-app-pub-4294379690418901/9830139399"
    
    private var interstitial: GADInterstitialAd?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .clubhouseBackground
        initView()
        bind()
    }
    
    private func initView() {
        views = [
            atomicNumberLabel,
            symbolLabel,
            nameLabel,
            atomicMassLabel,
            electronicConfigurationLabel,
            electronegativityLabel,
            atomicRadiusLabel,
            ionRadiusLabel,
            vanDerWaalsRadiusLabel,
            ionizationEnergyLabel,
            electronAffinityLabel,
            oxidationStatesLabel,
            standardStateLabel,
            bondingTypeLabel,
            meltingPointLabel,
            boilingPointLabel,
            densityLabel,
            groupBlockLabel,
            yearDiscoveredLabel,
            blockLabel,
            cpkHexColorLabel,
            periodLabel,
            groupLabel
        ]
        view.add(textField) {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 4
            $0.backgroundColor = .white
            $0.keyboardType = .numbersAndPunctuation
            $0.placeholder = "EnterChem".localized
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.trailing.leading.equalToSuperview().inset(32)
                make.height.equalTo(32)
            }
        }
        view.add(UIStackView()) {
            $0.axis = .vertical
            $0.snp.makeConstraints { make in
                make.top.equalTo(self.textField).offset(32)
                make.trailing.leading.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(32)
            }
            $0.addArranged(self.views, spacing: 6) {
                $0.map { label in
                    label.font = .systemFont(ofSize: 14, weight: .regular)
                }
            }
        }
        
    }
    
    private func bind() {
        textField.textPublisher
            .assign(to: &viewModel.$text)
        viewModel.$resultModel
            .sink { [weak self] model in
                guard let self = self else { return }
                self.views.map { label in
                    label.text = ""
                }
                guard let model = model else {

                    return
                }
                
                self.atomicNumberLabel.text = "atomicNumber".localized + " " + "\(model.atomicNumber)"
                self.symbolLabel.text = "symbol".localized + " " + model.symbol
                self.nameLabel.text = "name".localized + " " + model.name
                self.atomicMassLabel.text = "atomicMass".localized + " " + model.atomicMass
                self.electronicConfigurationLabel.text = "electronicConfiguration".localized + " " + model.electronicConfiguration

                if let electroNegativity = model.electronegativity {
                    self.electronegativityLabel.text = "electronegativity".localized + " " + "\(electroNegativity)"
                }
                if let atomicRadius = model.atomicRadius {
                    self.atomicRadiusLabel.text = "atomicRadius".localized + " " + "\(atomicRadius)"
                }
                if let ionicRadius = model.ionRadius {
                    self.ionRadiusLabel.text = "ionRadius".localized + " " + "\(ionicRadius)"
                }
                if let vander = model.vanDerWaalsRadius {
                    self.vanDerWaalsRadiusLabel.text = "vanDerWaalsRadius".localized + " " + "\(vander)"
                }
                if let ionizationEnergy = model.ionizationEnergy {
                    self.ionizationEnergyLabel.text = "ionizationEnergy".localized + " " + "\(ionizationEnergy)"
                }
                if let electronAffinity = model.electronAffinity {
                    self.electronAffinityLabel.text = "electronAffinity".localized + " " + "\(electronAffinity)"
                }
                if let oxidationStates = model.oxidationStates {
                    self.oxidationStatesLabel.text = "oxidationStates".localized + " " + "\(oxidationStates)"
                }
                if let standardState = model.standardState {
                    self.standardStateLabel.text = "standardState".localized + " " + "\(standardState)"
                }
                if let bondingType = model.bondingType {
                    self.bondingTypeLabel.text = "bondingType".localized + " " + "\(bondingType)"
                }
                if let meltingPoint = model.meltingPoint {
                    self.meltingPointLabel.text = "meltingPoint".localized + " " + "\(meltingPoint)"
                }
                if let boilingPoint = model.boilingPoint {
                    self.boilingPointLabel.text = "boilingPoint".localized + " " + "\(boilingPoint)"
                }
                if let density = model.density {
                    self.densityLabel.text = "density".localized + " " + "\(density)"
                }
                if let groupBlock = model.groupBlock {
                    self.groupBlockLabel.text = "groupBlock".localized + " " + "\(groupBlock)"
                }
                if let yearDiscovered = model.yearDiscovered {
                    self.yearDiscoveredLabel.text = "yearDiscovered".localized + " " + "\(yearDiscovered)"
                }
                if let block = model.block {
                    self.blockLabel.text = "block".localized + " " + "\(block)"
                }
                self.cpkHexColorLabel.text = "cpkHexColor".localized + " " + model.cpkHexColor
                self.cpkHexColorLabel.backgroundColor = UIColor(hexString: model.cpkHexColor)
                self.periodLabel.text = "period".localized + " " + "\(model.period)"
                self.groupLabel.text = "group".localized + " " + "\(model.group)"
            }
            .store(in: &subscription)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setFullAd() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: fullAdUnit,
            request: request,
            completionHandler: { [weak self] ad, error in
                self?.interstitial = ad
                self?.showFullAd()
            })
    }
    
    private func showFullAd() {
        if let interstitial = self.interstitial {
            interstitial.present(fromRootViewController: self)
        }
    }
}

extension UIColor {
    
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    var hexString: String {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        
        return String(format: "#%06x", rgb)
    }
}
