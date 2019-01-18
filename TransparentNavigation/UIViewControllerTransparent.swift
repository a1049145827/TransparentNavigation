//
//  UIViewControllerTransparent.swift
//  BLTransparentNavigation
//
//  Created by geekbruce on 2019/1/18.
//  Copyright © 2019 GeekBruce. All rights reserved.
//

import UIKit

extension UIViewController {

    private static var navBarBgAlphaKey = "navBarBgAlphaKey"
    
    @objc public var navBarBgAlpha: NSNumber? {
        set(navBarBgAlpha) {
            objc_setAssociatedObject(self, &UIViewController.navBarBgAlphaKey, navBarBgAlpha, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            // 设置导航栏透明度（利用Category自己添加的方法）
            navigationController?.setNeedsNavigationBackground(navBarBgAlpha?.floatValue ?? Float(0), animationDuration: TimeInterval(UINavigationController.hideShowBarDuration))
        }
        get {
            return objc_getAssociatedObject(self, &UIViewController.navBarBgAlphaKey) as? NSNumber
        }
    }
}
