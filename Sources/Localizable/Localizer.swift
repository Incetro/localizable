//
//  Localizer.swift
//  Localizable
//
//  Created by incetro on 7/3/21.
//

import ObserverList

// MARK: - Localizer

/// General localizer class.
/// Use it when you want to dynamically change an app language on the fly.
///
/// Create `Localizable` children:
///
///     // MARK: - Localizable
///
///     extension ViewController: Localizable {
///
///         func localize() {
///             exampleLabel.text = L10n.Example.title
///             changeLanguageButton.setTitle(L10n.Example.changeLanguageButtonTitle, for: .normal)
///         }
///     }
///
///     ...
///
///     // MARK: - Localizable
///
///     extension CustomView: Localizable {
///
///         func localize() {
///             someLabel.text = L10n.Something.title
///         }
///     }
///
///     ...
///
///     // MARK: - Localizable
///
///     extension CustomCell: Localizable {
///
///         func localize() {
///             someButton.setTitle(L10n.Something.buttonTitle, for: .normal)
///         }
///     }
///
/// Change an app language from any place of your code:
///
///     localizer.setCurrrentLanguage(newLanguage)
///
/// Every existing `Localizable` instance will be automatically updated.
///
open class Localizer<Langue: Language & RawRepresentable> where Langue.RawValue == String {

    // MARK: - Aliases

    /// Localization event alias
    public typealias LocalizeBlock = (Localizable) -> Void

    /// Language changing event alias
    public typealias DidChangeLanguage = (Langue) -> Void

    // MARK: - Properties

    /// An auxiliary UserDefaults key for storing current language type
    private let cacheKey = "com.incetro.localizable.language"

    /// UserDefaults instance
    private let defaults: UserDefaults

    /// NotificationCenter instance
    private let notificationCenter: NotificationCenter

    /// Current observers
    private let observers = ObserverList<LocalizeBlock>()

    /// Calls when language has changed
    private let didChangeLanguage: DidChangeLanguage

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - defaults: UserDefaults instance
    ///   - didChangeLanguage: calls when language has changed
    public init(
        defaults: UserDefaults = .standard,
        notificationCenter: NotificationCenter = .default,
        didChangeLanguage: @escaping DidChangeLanguage
    ) {
        self.defaults = defaults
        self.didChangeLanguage = didChangeLanguage
        self.notificationCenter = notificationCenter
    }

    // MARK: - Private

    /// Setup basic settings
    private func setup() {
        notificationCenter.addObserver(
            self,
            selector: #selector(languageChanged),
            name: .chagngeLanguageNotificationName,
            object: nil
        )
    }

    /// Calls when user change their app language
    @objc private func languageChanged() {
        didChangeLanguage(currentLanguage)
        observers.forEach { object, block in
            if let localizable = object as? Localizable {
                block(localizable)
            }
        }
    }
}

// MARK: - LocalizationManipulator

extension Localizer: LocalizationManipulator {

    /// Current app language
    public var currentLanguage: Langue {
        if let string = defaults.string(forKey: cacheKey) {
            if let language = Langue(rawValue: string) {
                return language
            }
        } else if let locale = NSLocale.current.languageCode, let language = Langue(rawValue: locale) {
            return language
        }
        return .default
    }

    /// Set a new app language.
    /// Use it when you get an event from user about language changing.
    /// For example your code may look like this (in a language settings screen cell):
    ///
    ///     override func didSelectCell() {
    ///         localizer.setCurrrentLanguage(viewModel.language)
    ///         viewModel.isSelected = true
    ///         updateCellSelection()
    ///     }
    ///
    /// In the example above you pass the currently selected language to localizer.
    /// It means that immediately after this event `Localizer` will update all currently stored
    /// `Localizable` instances.
    ///
    /// - Parameter language: a new language
    public func refresh(language: Langue) {
        notificationCenter.post(name: .chagngeLanguageNotificationName, object: self)
        defaults.set(language.rawValue, forKey: cacheKey)
        languageChanged()
    }

    /// Add a new localizable instance (observer).
    /// Usually you will use ot like this:
    ///
    ///     // MARK: - SettingsViewController
    ///
    ///     final class SettingsViewController: ViewController {
    ///
    ///         override func viewDidLoad() {
    ///             super.viewDidLoad()
    ///             localizer.add(localizable: self)
    ///         }
    ///     }
    ///
    /// Or like this:
    ///
    ///     // MARK: - SomeCustomView
    ///
    ///     final class CustomView: UIView {
    ///
    ///         // MARK: - Initializers
    ///
    ///         override init(frame: CGRect) {
    ///             super.init(frame: frame)
    ///             localizer.add(localizable: self)
    ///             setup()
    ///         }
    ///
    ///         required init?(coder: NSCoder) {
    ///             fatalError("init(coder:) has not been implemented")
    ///         }
    ///     }
    ///
    /// Or even like this:
    ///
    ///     // MARK: - CustomCell
    ///
    ///     final class CustomCell: UITableViewCell {
    ///
    ///         // MARK: - UITableViewCell
    ///
    ///         override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    ///             super.init(style: style, reuseIdentifier: reuseIdentifier)
    ///             localizer.add(localizable: self)
    ///         }
    ///
    ///         required init?(coder aDecoder: NSCoder) {
    ///             fatalError("init(coder:) has not been implemented")
    ///         }
    ///     }
    ///
    /// - Parameter localizable: some localization observer
    public func add(localizable: Localizable) {
        observers.addObserver(disposable: localizable) { localizable in
            localizable.localize()
        }
        localizable.localize()
    }
}

// MARK: - Notification.Name

extension Notification.Name {

    /// Notification for an event when user change their app language
    static let chagngeLanguageNotificationName = Notification.Name("com.incetro.localizable.change-language")
}
