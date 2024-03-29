//
//  StarEvaluateView.swift
//  JadeWrench
//
//  Created by 黄杰 on 2017/3/10.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

// 星星数回调
public typealias StarEvaluateViewSuccessBlock = (_ index: CGFloat, _ halfIndex: CGFloat, _ percent: CGFloat) -> Void

open class JQ_StarEvaluateView: UIView {

    // 星级数量
    open var starCount: Int = 0
    // 空隙大小
    open var space: CGFloat = 0
    // 正常时显示的图片
    open var normalImg: UIImage?
    // 选中时显示的图片
    open var selectedImg: UIImage?
    // 是否显示半星（默认不现实）
    open var hasShowHalfStar = false
    // 星星数回调
    open var successBlock: StarEvaluateViewSuccessBlock?
    
    /******通过xib设置*******/
    @IBInspectable var starLevel: Int {
        get {
            return self.starCount
        }
        set {
            self.starCount = newValue
        }
    }

    @IBInspectable var starGap: CGFloat {
        get {
            return self.space
        }
        set {
            self.space = newValue
        }
    }
    @IBInspectable var defaultImg: String {
        get {
            return (self.normalImg?.accessibilityIdentifier)!
        }
        set {
            self.normalImg = UIImage(named: newValue)
        }
    }
    @IBInspectable var defaultSelectImg: String {
        get {
            return (self.selectedImg?.accessibilityIdentifier)!
        }
        set {
            self.selectedImg = UIImage(named: newValue)
        }
    }
    @IBInspectable var hasHalfStar: Bool {
        get {
            return self.hasShowHalfStar
        }
        set {
            self.hasShowHalfStar = newValue
        }
    }
    
    /******私有属性*******/
    private var hasLayout = false
    lazy private var norView = UIImageView()
    lazy private var selView = UIImageView()
    lazy private var norImgList = [UIImageView]()
    lazy private var selImgList = [UIImageView]()
    
    /**
     初始化
     
     - parameter sumCount:  星级数量
     - parameter starSpace: 每个星级直接的空隙
     - parameter norImg:    默认图片
     - parameter selImg:    选中图片
     */
    convenience init(sumCount: Int, starSpace: CGFloat, norImg: UIImage?, selImg: UIImage?) {
        self.init()
        
        self.isUserInteractionEnabled = true
        self.hasShowHalfStar = false
        starCount = sumCount
        space = starSpace
        normalImg = norImg
        selectedImg = selImg
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapStarView(tap:)))
        self.addGestureRecognizer(tap)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapStarView(tap:)))
        self.addGestureRecognizer(tap)
    }
    
    private func setupSubView() {
        // 创建普通样式图片
        createNormalStar()
        // 创建选中样式图片
        createSelStar()
    }

    /**
     创建普通样式图片
     */
    private func createNormalStar() {
        if starCount != 0 && norImgList.count == 0 {
            norView.clipsToBounds = true
            self.addSubview(norView)
            let imgW: CGFloat = (self.frame.size.width - space * CGFloat(starCount)) / CGFloat(starCount)
            let imgH: CGFloat = self.frame.size.height
            let margin: CGFloat = space
            let imgY: CGFloat = 0
            for index in 0 ..< starCount {
                let imgX: CGFloat = (imgW + margin) * CGFloat(index)
                let norImgView = UIImageView(image: normalImg)
                norImgView.contentMode = .scaleAspectFill
                norImgView.frame = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
                norView.addSubview(norImgView)
                norImgList.append(norImgView)
                if index == starCount - 1 {
                    norView.frame = CGRect(x: 0, y: 0, width: norImgView.frame.maxX, height: self.frame.size.height)
                }
            }
        }
    }
    
    /**
     创建选中样式图片
     */
    private func createSelStar() {
        if starCount != 0 && selImgList.count == 0 {
            selView.clipsToBounds = true
            self.addSubview(selView)
            let imgW: CGFloat = (self.frame.size.width - space * CGFloat(starCount)) / CGFloat(starCount)
            let imgH: CGFloat = self.frame.size.height
            let margin: CGFloat = space
            let imgY: CGFloat = 0
            for index in 0 ..< starCount {
                let imgX: CGFloat = (imgW + margin) * CGFloat(index)
                let selImgView = UIImageView(image: selectedImg)
                selImgView.contentMode = .scaleAspectFill
                selImgView.frame = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
                selView.addSubview(selImgView)
                selImgList.append(selImgView)
                if index == starCount - 1 {
                    selView.frame = CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height)
                }
            }
        }
    }
    
    /**
     点击了view
     */
    @objc func didTapStarView(tap: UITapGestureRecognizer) {
        let imgW: CGFloat = (self.frame.size.width - space * CGFloat(starCount)) / CGFloat(starCount)
        let position = tap.location(in: self)
        let index = Int(position.x / (imgW + space))
        let leftJudge = imgW * CGFloat(index + 1) + space * CGFloat(index)
        let rightJudge = CGFloat(index + 1) * (imgW + space)
        // 判断是否点击了有效区域
        if leftJudge < position.x && position.x < rightJudge {
            return
        }
        // 获取半星的index
        var fakePosition = position.x
        var halfIndex = fakePosition / imgW
        // 抽象化为去除间隙的view
        if position.x > imgW {
            fakePosition = fakePosition - space * CGFloat(index)
            halfIndex = fakePosition / imgW
        }
        // 判断是点击了左侧还是右侧
        if fakePosition > (imgW * CGFloat(index) + imgW * 0.5) { // 点击了右侧
            // 向上取整
            halfIndex = ceil(halfIndex) - 0.5
        } else {
            // 向下取整
            halfIndex = floor(halfIndex)
        }
        // 处理星星显示
        var offsetPercent = position.x / self.frame.size.width
        offsetPercent = changeStarStatus(percent: offsetPercent, index: CGFloat(index), halfIndex: halfIndex, imgW: imgW)
        selView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width * offsetPercent, height: self.frame.size.height)
    }
    
    /**
     改变星星状态
     */
    private func changeStarStatus(percent: CGFloat, index: CGFloat, halfIndex: CGFloat, imgW: CGFloat) -> CGFloat {
        // 回调
        if let block = successBlock {
            block(index, halfIndex, percent)
        }
        if self.hasShowHalfStar {
            // 半星算法判断
            let indexStr = "\(halfIndex)"
            let indexStrList = indexStr.components(separatedBy: ".")
            let secondItem = indexStrList[1]
            if secondItem == "0" { // 整数
                if (((imgW + space) * halfIndex) / self.frame.size.width) <= percent && percent < (((imgW + space) * floor(halfIndex) + (imgW * 0.5)) / self.frame.size.width) {
                    return ((imgW + space) * floor(halfIndex) + (imgW * 0.5)) / self.frame.size.width
                } else {
                    return 0
                }
            } else { // 小数
                if (((imgW + space) * floor(halfIndex) + (imgW * 0.5)) / self.frame.size.width) <= percent && percent < (((imgW + space) * halfIndex) / self.frame.size.width) {
                    return ((imgW + space) * halfIndex) / self.frame.size.width
                } else {
                    return 0
                }
            }
        } else {
            // 全星算法
            return ((index + 1) * (imgW + space)) / self.frame.size.width
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayout {
            setupSubView()
            hasLayout = true
        }
    }
    
}
