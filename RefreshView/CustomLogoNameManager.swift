//
//  CustomLogoManager.swift
//  RefreshView
//
//  Created by Yan on 2017/5/17.
//  Copyright © 2017年 ZouLiangming. All rights reserved.
//

import Foundation

public enum CustomTargetType {
    case teambition
    case people

    var logoName: String {
        switch self {
        case .teambition:
            return "loading_logo"
        case .people:
            return "people_logo"
        }
    }
}

public class CustomLogoNameManager {

    public static let shared = CustomLogoNameManager()

    public var target: CustomTargetType = .teambition

    private init() {}
}
