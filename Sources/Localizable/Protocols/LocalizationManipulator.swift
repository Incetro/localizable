//
//  LocalizationManipulator.swift
//  Localizable
//
//  Created by incetro on 7/3/21.
//

import Foundation

// MARK: - LocalizationManipulator

public protocol LocalizationManipulator {

    /// Language associated type
    associatedtype Langue: Language & RawRepresentable where Langue.RawValue == String

    /// Current app language
    var currentLanguage: Langue { get }

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
    func refresh(language: Langue)

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
    func add(localizable: Localizable)
}
