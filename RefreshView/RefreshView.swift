//
//  RefreshView.swift
//  RefreshView
//
//  Created by horex on 2017/5/18.
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

public func changeTarget(type targetType: CustomTargetType) {

    CustomLogoNameManager.shared.target = targetType
    
}
