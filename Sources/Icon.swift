//
//  Icon.swift
//  RefreshView
//
//  Created by bruce on 2020/6/17.
//  Copyright © 2020 ZouLiangming. All rights reserved.
//

import UIKit

struct Icon {
    private static var internalBundle: Bundle?

    public static var bundle: Bundle {
        if nil == Icon.internalBundle {
            Icon.internalBundle = Bundle(for: CustomRefreshView.self)
            let url = Icon.internalBundle!.resourceURL!
            let b = Bundle(url: url.appendingPathComponent("RefreshView.bundle"))
            if let v = b {
                Icon.internalBundle = v
            }
        }
        return Icon.internalBundle!
    }
    
    public static func icon(_ name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)//?.withRenderingMode(.alwaysTemplate)
    }
    
    public static var loadingCircle = Icon.icon("loading_circle")
    public static var loadingLogo = Icon.icon("loading_logo")
}
