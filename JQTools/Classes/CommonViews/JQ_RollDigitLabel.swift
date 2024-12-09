//
//  JQRollDigitLabel.swift
//  JQTools_Test
//
//  Created by 无故事王国 on 2020/6/29.
//  Copyright © 2020 杨锴. All rights reserved.
//

import UIKit

//#if canImport(SnapKit)
//
///// 滚动数值
///*
// roll.snp.makeConstraints { (make) in
// make.top.equalTo(100)
// make.left.equalTo(50)
// make.width.equalTo(roll.frame.width)
// make.height.equalTo(roll.frame.height)
// }
// */
//
///// 仿似于Scrollview，进行的数值变动，适用于整数类型
//public class JQ_RollDigitLabel: UIView {
//    
//    private var scrollViews = [UIScrollView]()
//    private var labels = [UILabel]()
//    private(set) var animated:Bool = false
//    private(set) var defaultNumber:NSInteger = 0 //初始值
//    private(set) var length = 0//长度
//    private var digitArray: Array<Int>{get{return [0,1,2,3,4,5,6,7,8,9]}}
//    
//    public var font = UIFont.systemFont(ofSize: 16)
//    public var textColor = UIColor.black
//    
//    //设置数值
//    public var number:NSInteger = 0{
//        didSet{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.setValue(self.number)
//            }
//        }
//    }
//    
//    public override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
//    
//    /// 设置被处理部位的数值
//    private func setValue(_ number:NSInteger){
//        let count = length - String(format: "%ld", number).count
//        if count < 0 {fatalError("超出length最大范围")}
//        var tempText = ""
//        for _ in 0..<count {
//            tempText.append("0") //补位 000123
//        }
//        tempText.append(String(format: "%ld", number))
//        
//        for index in 0..<self.scrollViews.count{
//            let number = NSInteger(tempText[index])!
//            self.scrollViews[index].setContentOffset(CGPoint(x: 0, y: CGFloat(number) * self.font.pointSize), animated: self.animated)
//        }
//    }
//    
//    private func setUI(){
//        for i in 0..<length{
//            let scroll = UIScrollView()
//            scroll.showsHorizontalScrollIndicator = false
//            scroll.showsVerticalScrollIndicator = false
//            scroll.isPagingEnabled = true
//            scroll.contentSize = CGSize(width: font.pointSize * 0.7, height:CGFloat(10) * font.pointSize)
//            addSubview(scroll)
//            scrollViews.append(scroll)
//            
//            scroll.snp.makeConstraints { (make) in
//                make.top.bottom.equalToSuperview()
//                make.width.equalTo(font.pointSize * 0.7)
//                make.left.equalTo(CGFloat(i) * font.pointSize * 0.7)
//            }
//            
//            labels.removeAll()
//            for j in digitArray{
//                let label = UILabel()
//                label.text = "\(j)"
//                label.font = font
//                label.textColor = textColor
//                label.textAlignment = .center
//                scroll.addSubview(label)
//                labels.append(label)
//                
//                if j == 0{
//                    label.snp.makeConstraints { (make) in
//                        make.top.left.equalToSuperview()
//                        make.width.equalTo(font.pointSize * 0.7)
//                        make.height.equalTo(font.pointSize)
//                    }
//                }else{
//                    let pastLabel = labels[j - 1]
//                    label.snp.makeConstraints { (make) in
//                        make.top.equalTo(pastLabel.snp.bottom)
//                        make.width.equalTo(font.pointSize * 0.7)
//                        make.left.equalToSuperview()
//                        make.height.equalTo(font.pointSize)
//                    }
//                }
//            }
//        }
//        bounds = CGRect(x: 0, y: 0, width: font.pointSize * CGFloat(length) * 0.7, height: font.pointSize)
//    }
//    
//    /// 初始化方法
//    /// - Parameters:
//    ///   - defaultNumber: 初始值
//    ///   - length: 位数长度，不得超过此位数
//    ///   - fontSize: 字体大小
//    ///   - weight: 字体
//    ///   - color: 字体颜色
//    ///   - animated: 是否动画
//    ///   - deadline: 设置number时，执行动画延迟秒数
//    
//    convenience init(defaultNumber:NSInteger = 0,length:NSInteger,animated:Bool) {
//        self.init(frame:CGRect.zero)
//        self.defaultNumber = defaultNumber
//        self.length = length
//        self.animated = animated
//    }
//    
//    
//    /// 开始显示
//    public func show(){
//        setUI()
//        setValue(defaultNumber)
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//}
//
//#endif
