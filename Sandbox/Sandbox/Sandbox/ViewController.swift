//
//  ViewController.swift
//  Sandbox
//
//  Created by incetro on 7/3/21.
//

import UIKit
import Localizable

var bundle: Bundle?

// MARK: - AppLanguage

enum AppLanguage: String {

    case russian = "ru"
    case english = "en"
}

// MARK: - Language

extension AppLanguage: Language {

    static var `default`: AppLanguage {
        russian
    }

    var localizedPath: String {
        Bundle.main.path(forResource: rawValue, ofType: "lproj").unsafelyUnwrapped
    }

    var localeIdentifier: String {
        switch self {
        case .russian:
            return "ru_RU"
        case .english:
            return "en_US"
        }
    }

    var locale: Locale {
        Locale(identifier: localeIdentifier)
    }
}

// MARK: - ViewController

class ViewController: UIViewController {

    private let localizer = Localizer { (language: AppLanguage) in
        print("Language changed. A new language is \(language.rawValue.uppercased())")
        bundle = Bundle(path: language.localizedPath)
    }

    private let exampleLabel = UILabel()
    private let changeLanguageButton = UIButton()

    override func viewDidLoad() {

        super.viewDidLoad()
        localizer.add(localizable: self)

        view.addSubview(exampleLabel)
        exampleLabel.translatesAutoresizingMaskIntoConstraints = false
        exampleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        exampleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(changeLanguageButton)
        changeLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        changeLanguageButton.topAnchor.constraint(equalTo: exampleLabel.bottomAnchor, constant: 31).isActive = true
        changeLanguageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeLanguageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        changeLanguageButton.widthAnchor.constraint(equalToConstant: 313).isActive = true
        changeLanguageButton.backgroundColor = .orange
        changeLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeLanguageButton.smoothlyRoundCourners(radius: 13)
    }

    @objc private func changeLanguage() {
        switch localizer.currentLanguage {
        case .english:
            localizer.refresh(language: .russian)
        case .russian:
            localizer.refresh(language: .english)
        }
    }
}

extension ViewController: Localizable {

    func localize() {
        exampleLabel.text = "sandbox.example-string".localized
        changeLanguageButton.setTitle("sandbox.change-language-button".localized, for: .normal)
    }
}

extension String {

    var localized: String {
        NSLocalizedString(
            self,
            tableName: "Localization",
            bundle: bundle ?? Bundle(for: BundleToken.self),
            comment: ""
        )
    }
}

private final class BundleToken {
}

// MARK: - UIView

extension UIView {

    func smoothlyRoundCourners(
        _ corners: UIRectCorner = .allCorners,
        radius: CGFloat
    ) {
        let roundPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        layer.mask = maskLayer
    }

    func subview(withId accessibilityIdentifier: String) -> UIView? {
        subviews.first { $0.accessibilityIdentifier == accessibilityIdentifier }
    }
}
