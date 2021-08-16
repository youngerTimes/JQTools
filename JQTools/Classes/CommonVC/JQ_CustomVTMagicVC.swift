//
//  CustomVTMagicVC.swift
//  NoyaDeliver
//
//  Created by 无故事王国 on 2021/6/29.
//

import UIKit
import VTMagic

open class JQ_CustomVTMagicVC: JQ_BaseVC {
    public var titleArray:Array<String> = []{
        didSet{
            vtmagic.magicView.reloadData()
        }
    }

    public var vtmagic:VTMagicController!

    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    open override func setUI() {
        super.setUI()

        vtmagic = VTMagicController()
        vtmagic.magicView.navigationColor = UIColor.clear
        vtmagic.magicView.needPreloading = false
        vtmagic.magicView.isScrollEnabled = true
        vtmagic.magicView.layoutStyle = .center
        vtmagic.magicView.separatorColor = .clear
        vtmagic.magicView.sliderColor = UIColor.gray.withAlphaComponent(0.5)
        vtmagic.magicView.sliderWidth = 21
        vtmagic.magicView.sliderHeight = 4
        vtmagic.magicView.isAgainstStatusBar = false
        vtmagic.magicView.sliderExtension = 0
        vtmagic.magicView.dataSource = self
        vtmagic.magicView.bubbleRadius = 2
        addChild(vtmagic)
        view.addSubview(vtmagic.magicView)
        vtmagic.magicView.frame = CGRect(x: 0, y: JQ_NavBarHeight, width:JQ_ScreenW, height: JQ_ScreenH-JQ_NavBarHeight)
        vtmagic.magicView.reloadData()
        vtmagic.switch(toPage: 0, animated: false)
    }


    @discardableResult
    public func setSlider(radius:CGFloat = 0,grandientColor:[CGColor]? = nil)->(UIView,CAGradientLayer?){
        //自定义滑块
        let layerView = UIView()
        layerView.frame = CGRect(x: 43.5, y: 137.5, width: 17, height: 2)
        layerView.jq_masksToBounds = true
        layerView.jq_cornerRadius = radius
        // fillCode

        var bgLayer:CAGradientLayer?
        if grandientColor != nil{
            bgLayer = CAGradientLayer()
            bgLayer!.colors = grandientColor
            bgLayer!.locations = [0, 1]
            bgLayer!.frame = layerView.bounds
            bgLayer!.startPoint = CGPoint(x: 0.14, y: 0.22)
            bgLayer!.endPoint = CGPoint(x: 0.77, y: 0.77)
            layerView.layer.addSublayer(bgLayer!)
        }
        vtmagic.magicView.setSlider(layerView)
        vtmagic.magicView.sliderOffset = -2
        return (layerView,bgLayer)
    }
}

extension JQ_CustomVTMagicVC: VTMagicViewDataSource {

    open func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        let bt = UIButton()
        bt.setAttributedTitle(NSAttributedString.init(string: titleArray[Int(itemIndex)], attributes: [NSAttributedString.Key.foregroundColor:UIColor(hexStr: "#363C51"),.font: UIFont.systemFont(ofSize: 18, weight: .medium)]), for: .selected)
        bt.setAttributedTitle(NSAttributedString.init(string: titleArray[Int(itemIndex)], attributes: [.foregroundColor:UIColor(hexStr: "#9C9EA9"),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)]), for: .normal)
        bt.layer.masksToBounds = true
        return bt
    }
    open func menuTitles(for magicView: VTMagicView) -> [String] {
        return titleArray
    }

    open func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let vc = UIViewController()
        return vc
    }
}
