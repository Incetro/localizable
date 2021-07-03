//
//  Localizable.swift
//  Localizable
//
//  Created by incetro on 7/3/21.
//

import Foundation

// MARK: - Localizable

/// A protocol for all localizable items
public protocol Localizable: AnyObject {

    /// Localize an object.
    /// Custom `UIView` and `UIViewController` classes can be localizable.
    /// The metod will be called each time app language changed.
    ///
    /// You can use it like this:
    ///
    ///     // MARK: - Localizable
    ///
    ///     extension SettingsViewController: Localizable {
    ///
    ///         func localize() {
    ///             navigationItem.title = L10n.Settings.title
    ///         }
    ///     }
    ///
    func localize()
}
