//
//  Language.swift
//  Localizable
//
//  Created by incetro on 7/3/21.
//

import Foundation

// MARK: - Language

public protocol Language {

    /// Localization resources path
    var localizedPath: String { get }

    /// Language locale identifier
    var localeIdentifier: String { get }

    /// Language Locale instance
    var locale: Locale { get }

    /// Default app language
    static var `default`: Self { get }
}

public extension Language {

    var locale: Locale {
        Locale(identifier: localeIdentifier)
    }
}
