//
//  CustomLogoManager.swift
//  RefreshView
//
//  Created by Yan on 2017/5/17.
//  Copyright © 2017年 ZouLiangming. All rights reserved.
//

import UIKit

class CustomLogoNameManager {

    public static let shared = CustomLogoNameManager()

    
    public var target: CustomTargetType = .teambition
    
    public var logoImage: UIImage?

    private init() {}
}
