//
//  RefreshView.swift
//  RefreshView
//
//  Created by horex on 2017/5/18.
//  Copyright © 2017年 ZouLiangming. All rights reserved.
//

import UIKit

public func updateLogoIcon(logo logoIcon: UIImage, isHideLogo: Bool = true) {
    CustomLogoManager.shared.logoImage = logoIcon
    CustomLogoManager.shared.isHideLogo = isHideLogo
}
