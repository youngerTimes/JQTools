//
//  JQ_ScratchCard.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/11.
//

import UIKit

//#if canImport(SnapKit)
/////刮刮卡代理协议
// @objc public protocol ScratchCardDelegate {
//    @objc optional func scratchBegan(point: CGPoint)
//    @objc optional func scratchMoved(progress: Float)
//    @objc optional func scratchEnded(point: CGPoint)
//}
// 
/////刮刮卡
//public class JQ_ScratchCard: UIView {
//    //涂层
//    public var scratchMask: JQ_ScratchMask!
//    //底层券面图片
//    public var couponImageView: UIImageView!
// 
//    //刮刮卡代理对象
//    public weak var delegate: ScratchCardDelegate?{
//        didSet{
//            scratchMask.delegate = delegate
//        }
//    }
//     
//    public init(couponImage: UIImage, maskImage: UIImage,
//                scratchWidth: CGFloat = 15, scratchType: CGLineCap = .square) {
//        super.init(frame: CGRect.zero)
//         
//        //添加底层券面
//        couponImageView = UIImageView()
//        couponImageView.image = couponImage
//        self.addSubview(couponImageView)
//        couponImageView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//         
//        //添加涂层
//        scratchMask = JQ_ScratchMask(frame: CGRect.zero)
//        scratchMask.image = maskImage
//        scratchMask.lineWidth = scratchWidth
//        scratchMask.lineType = scratchType
//        self.addSubview(scratchMask)
//        scratchMask.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//    }
//     
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//#endif
