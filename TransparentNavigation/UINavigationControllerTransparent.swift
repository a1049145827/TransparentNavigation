//
//  UINavigationControllerTransparent.swift
//  BLTransparentNavigation
//
//  Created by geekbruce on 2019/1/18.
//  Copyright © 2019 GeekBruce. All rights reserved.
//

import UIKit

fileprivate let kDefaultNavAlpha: Float = 1
fileprivate var kIsGesturePop: Bool = false

extension UINavigationController: UINavigationBarDelegate, UINavigationControllerDelegate {
    
    @objc public func setNeedsNavigationBackground(_ alpha: Float, animationDuration duration: TimeInterval) {
        
        if navigationBar.subviews.count == 0 {
            return
        }
        
        var barBackgroundView: UIView?
        var cls: AnyClass? = NSClassFromString("_UINavigationBarBackground") // iOS8, iOS9
        if #available(iOS 11, *) {
            cls = NSClassFromString("_UIBarBackground") // iOS11, iOS12
        } else if #available(iOS 10, *) {
            cls = NSClassFromString("UIBarBackground") // iOS10
        }
        for subview: UIView in navigationBar.subviews {
            if type(of: subview) === cls {
                barBackgroundView = subview
                break
            }
        }
        
        if alpha != 0 {
            navigationBar.clipsToBounds = false
        }
        
        if duration > 0 {
            
            UIView.animate(withDuration: duration, animations: {
                self.change(with: barBackgroundView, alpha: alpha)
            }) { finished in
                if alpha == 0 && !kIsGesturePop {
                    self.navigationBar.clipsToBounds = true
                }
            }
        } else {
            change(with: barBackgroundView, alpha: alpha)
            if alpha == 0 {
                navigationBar.clipsToBounds = true
            }
        }
    }
    
    static let nav = UIViewController()
    
    fileprivate static func awake() {
        
        // 交换方法
        let originalSelector: Selector = NSSelectorFromString("_updateInteractiveTransition:")
        let swizzledSelector: Selector = NSSelectorFromString("et__updateInteractiveTransition:")
        if let originalMethod = class_getInstanceMethod(self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) {
            
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    @objc func et__updateInteractiveTransition(_ percentComplete: CGFloat) {
        et__updateInteractiveTransition(percentComplete)
        
        if let coor = topViewController?.transitionCoordinator {
            kIsGesturePop = true
            // 随着滑动的过程设置导航栏透明度渐变
            let fromAlpha = coor.viewController(forKey: .from)?.navBarBgAlpha?.floatValue ?? kDefaultNavAlpha
            let toAlpha = coor.viewController(forKey: .to)?.navBarBgAlpha?.floatValue ?? kDefaultNavAlpha
            let nowAlpha: Float = fromAlpha + (toAlpha - fromAlpha) * Float(percentComplete)
            
            setNeedsNavigationBackground(nowAlpha, animationDuration: 0)
        }
    }
    
    private func change(with barBackgroundView: UIView?, alpha: Float) {
        
        guard let barBackgroundView = barBackgroundView else {
            return
        }
        // 导航栏背景透明度设置
        if navigationBar.isTranslucent {
             // UIImageView
            if let backgroundImageView = barBackgroundView.subviews.first as? UIImageView, backgroundImageView.image != nil {
                
                barBackgroundView.alpha = CGFloat(alpha)
                
            } else if barBackgroundView.subviews.count > 1 {
                // UIVisualEffectView
                let backgroundEffectView: UIView? = barBackgroundView.subviews[1]
                if backgroundEffectView != nil {
                    backgroundEffectView?.alpha = CGFloat(alpha)
                }
            }
        } else {
            barBackgroundView.alpha = CGFloat(alpha)
        }
    }
    
    // MARK: - UINavigationController Delegate
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if let coor = topViewController?.transitionCoordinator {
            
            if #available(iOS 10, *) {
                coor.notifyWhenInteractionChanges({ context in
                    self.dealInteractionChanges(context)
                })
            } else {
                coor.notifyWhenInteractionEnds({ context in
                    self.dealInteractionChanges(context)
                })
            }
        }
    }
    
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext?) {
        
        guard let context = context else {
            return
        }
        
        var duration: TimeInterval = 0
        var nowAlpha: Float = 0
        
        if context.isCancelled {
            // 自动取消了返回手势
            duration = TimeInterval(CGFloat(context.transitionDuration) * context.percentComplete)
            nowAlpha = context.viewController(forKey: .from)?.navBarBgAlpha?.floatValue ?? kDefaultNavAlpha
        } else {
            // 自动完成了返回手势
            duration = TimeInterval(CGFloat(context.transitionDuration) * (1 - context.percentComplete))
            nowAlpha = context.viewController(forKey: .to)?.navBarBgAlpha?.floatValue ?? kDefaultNavAlpha
        }
        
        setNeedsNavigationBackground(nowAlpha, animationDuration: duration)
    }
    
    // MARK: - UINavigationBar Delegate
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        // 点击返回按钮
        if viewControllers.count >= (navigationBar.items?.count ?? 0) {
            let popToVC = viewControllers[viewControllers.count - 1]
            setNeedsNavigationBackground(popToVC.navBarBgAlpha?.floatValue ?? kDefaultNavAlpha, animationDuration: TimeInterval(UINavigationController.hideShowBarDuration))
        }
        kIsGesturePop = false
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        // push到一个新界面
        setNeedsNavigationBackground(topViewController?.navBarBgAlpha?.floatValue ?? kDefaultNavAlpha, animationDuration: viewControllers.count > 1 ? TimeInterval(UINavigationController.hideShowBarDuration) : 0)
    }
}

extension UIApplication {
    
    private static let runOnce: Void = {
        UINavigationController.awake()
    }()
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
