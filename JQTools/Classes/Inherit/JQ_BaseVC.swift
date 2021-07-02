//
//  JQ_BaseViewController.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/11/19.
//

import UIKit

public enum JQ_AppearanceStyle:Int{
    case none = 0
    case light = 1
    case dark = 2
}


/// 暗黑模式适配
public protocol JQ_ColorAppearanceProtocol:NSObject{
    @available(iOS 12.0, *)
    /// 所有的颜色变化,需要写到这里
    func colorAppearance(_ style:JQ_AppearanceStyle)
}

/// 基础控件

open class JQ_BaseVC: JQ_ListenVC{

    private(set) public var currentStyle:JQ_AppearanceStyle = .none
    open var hh_popBlock:(() -> Void)?

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //初次进入,判断当前风格
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                currentStyle = .dark
                colorAppearance(.dark)
            }else{
                currentStyle = .light
                colorAppearance(.light)
            }
        } else {
            currentStyle = .light
            colorAppearance(.light)
        }

        setUI()
    }

    // 导航栏返回按钮图片
    open var back_img:UIImage = UIImage(named: "icon_back")!{
        didSet {
            if hh_isHaveBackItem {
                if let btn = navigationItem.leftBarButtonItem?.customView as? UIButton{
                    btn.setImage(back_img, for: .normal)
                }else{
                    navigationItem.leftBarButtonItem = UIBarButtonItem(image: back_img, style: .plain, target: self, action: #selector(backItemEvent))
                }
            } else {
                hh_isHaveBackItem = true
            }
        }
    }
    /// 是否需要返回按钮 默认需要
    open var hh_isHaveBackItem:Bool = true {
        didSet {
            if hh_isHaveBackItem {

                navigationItem.leftBarButtonItem = UIBarButtonItem(image: back_img, style: .plain, target: self, action: #selector(backItemEvent))
                //                navigationItem.leftBarButtonItem?.width = -20
            } else {
                navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            }
        }
    }

    open func setUI(){
        hh_isHaveBackItem = true
    }

    // pop点击事件
    @objc fileprivate func backItemEvent() {

        // 拦截pop事件
        if (hh_popBlock != nil) {
            hh_popBlock?()
            return
        }
        pop()
    }

    // pop
    open func pop(_ animated:Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    open func colorAppearance(_ style: JQ_AppearanceStyle) {

    }

    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                //暗黑模式
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    colorAppearance(.dark)
                    currentStyle = .dark
                }else{
                    colorAppearance(.light)
                    currentStyle = .light
                }
            }
        } else {
            //浅色模式
            if #available(iOS 12.0, *) {
                colorAppearance(.light)
                currentStyle = .light
            }
        }
    }
}
