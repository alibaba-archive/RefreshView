//
//  CustomLogoManager.swift
//  RefreshView
//
//  Created by Yan on 2017/5/17.
//  Copyright © 2017年 ZouLiangming. All rights reserved.
//

import UIKit

class CustomLogoManager {

    static let shared = CustomLogoManager()

    let logoName = "loading_logo"
    var logoImage: UIImage?
    var isHideLogo: Bool = true

    private init() {}
}
