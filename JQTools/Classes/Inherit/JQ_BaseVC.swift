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
