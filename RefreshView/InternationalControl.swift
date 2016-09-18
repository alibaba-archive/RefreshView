//
//  InternationalControl.swift
//  RefreshView
//
//  Created by bruce on 16/5/12.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import Foundation

public enum CustomRefreshLanguage {
    case english
    case simplifiedChinese
    case traditionalChinese
    case korean
    case japanese

    internal var identifier: String {
        switch self {
        case .english: return "en"
        case .simplifiedChinese: return "zh-Hans"
        case .traditionalChinese: return "zh-Hant"
        case .korean: return "ko"
        case .japanese: return "ja"
        }
    }
}

internal func LocalizedString(key: String, comment: String? = nil) -> String {
    return InternationalControl.sharedControl.localizedString(key: key, comment: comment)
}

internal struct InternationalControl {
    internal static var sharedControl = InternationalControl()
    internal var language: CustomRefreshLanguage = .english

    internal func localizedString(key: String, comment: String? = nil) -> String {
        let path = Bundle(identifier: "Teambition.RefreshView")?.path(forResource: language.identifier, ofType: "lproj") ?? Bundle.main.path(forResource: language.identifier, ofType: "lproj")
        guard let localizationPath = path else {
            return key
        }
        let bundle = Bundle(path: localizationPath)
        return bundle?.localizedString(forKey: key, value: nil, table: "Localizable") ?? key
    }
}
