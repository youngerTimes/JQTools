//
//  JQ_BaseNavigationController.swift
//  JQTools_Test
//
//  Created by 无故事王国 on 2020/11/19.
//  Copyright © 2020 杨锴. All rights reserved.
//

import UIKit


/// 自定义Nav
/**

 隐藏Nav栏,在AppDelegate 中的hiddenVCs 添加VC的id
 ```
 if let nav = self.window?.rootViewController as? JQ_BaseNavigationController{
     nav.hiddenVCs.append(CityPickerVC.jq_identity)
 }
 ```
 */
open class JQ_BaseNavigationController:  UINavigationController, UINavigationControllerDelegate {
    public var lastVc: UIViewController!
    /// 隐藏nav
    public var hiddenNavVCs = [String]()
    private var popDelegate: UIGestureRecognizerDelegate?

    //标题颜色
    public var titleTextAttributes:[NSAttributedString.Key : Any]?{
        didSet{
            self.navigationBar.titleTextAttributes =  titleTextAttributes
        }
    }

    //基础填充颜色
    public var tintColor:UIColor?{
        didSet{
            self.navigationBar.tintColor = tintColor
        }
    }

    public var barTintColor:UIColor?{
        didSet{
            self.navigationBar.barTintColor = barTintColor
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = .white
        self.navigationBar.titleTextAttributes = [.font:UIFont.systemFont(ofSize: 18, weight: .medium), .foregroundColor:UIColor.black]
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.shadowImage = UIImage()
        self.delegate = self
        self.popDelegate = self.interactivePopGestureRecognizer?.delegate
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

      var hidden = false
        for key in hiddenNavVCs {
            if key == viewController.jq_identity {
                hidden = true;break
            }
        }

        self.setNavigationBarHidden(hidden, animated: animated)
        self.lastVc = viewController
    }

    //侧滑
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if  viewController == self.viewControllers[0] {
            self.interactivePopGestureRecognizer!.delegate = self.popDelegate
        }else{
            self.interactivePopGestureRecognizer!.delegate = nil
        }
    }

    public override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }

    public override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
