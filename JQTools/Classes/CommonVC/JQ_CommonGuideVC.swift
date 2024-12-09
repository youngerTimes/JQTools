//
//  JQ_CommonGuideVC.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/9.
//

import UIKit
import SDWebImage

//public protocol JQ_CommonGuideDelegate:NSObject{
//    func currtentPage(page:Int,imgView:UIImageView) //当前页
//    func guideImagesView(imgView:[UIImageView]) //画廊每一个图片
//    func browseComplete() //浏览完成
//}
//
///**
// ## 启动时的向导页 ##
// 如果需要改进，可以继承并改动
// */
//public class JQ_CommonGuideVC: UIViewController,UIScrollViewDelegate {
//
//    //向导页的图片
//    public private(set) var guideImages = [UIImage]()
//				public private(set) var guideImagesUrl = [String]()
//    public var imgsView = [UIImageView]()
//				private var type = 0	//0:图片 1:url
//    public weak var delegate:JQ_CommonGuideDelegate?
//
//    public convenience init(_ images:[UIImage],delegate:JQ_CommonGuideDelegate? = nil){
//        self.init()
//								type = 0
//								self.delegate = delegate
//        guideImages = images
//    }
//
//				public convenience init(_ images:[String],delegate:JQ_CommonGuideDelegate? = nil){
//								self.init()
//								type = 1
//								self.delegate = delegate
//								guideImagesUrl = images
//				}
//
//
//    public override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIApplication.shared.setStatusBarHidden(true, with: .fade)
//    }
//
//    public override var prefersStatusBarHidden: Bool{
//        return true
//    }
//
//    public override func viewDidLoad(){
//        let frame = JQ_KeyWindow.frame
//        //scrollView的初始化
//        let scrollView = UIScrollView()
//        scrollView.frame = self.view.bounds
//        scrollView.delegate = self
//
//								var count = 0
//								if type == 0{
//												count = guideImages.count
//								}else{
//												count = guideImagesUrl.count
//								}
//
//        //为了能让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
//        scrollView.contentSize = CGSize(width:frame.size.width * CGFloat(count),
//                                        height:frame.size.height)
//        scrollView.isPagingEnabled = true
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.scrollsToTop = false
//        scrollView.bounces = false
//
//
//								if type == 0{
//												for (index,img) in guideImages.enumerated() {
//																let imgView = UIImageView(image: img)
//																imgView.contentMode = .scaleAspectFit
//																imgView.frame = CGRect(x:frame.size.width*CGFloat(index), y:CGFloat(0),
//																																							width:frame.size.width, height:frame.size.height)
//																scrollView.addSubview(imgView)
//																imgsView.append(imgView)
//												}
//								}
//
//								if type == 1{
//												for (index,img) in guideImagesUrl.enumerated() {
//																let imgView = UIImageView()
//																imgView.contentMode = .scaleAspectFit
//																imgView.frame = CGRect(x:frame.size.width*CGFloat(index), y:CGFloat(0),
//																																							width:frame.size.width, height:frame.size.height)
//																imgView.sd_setImage(with: URL(string: img))
//																imgView.contentMode =  .scaleAspectFit
//																scrollView.addSubview(imgView)
//																imgsView.append(imgView)
//												}
//								}
//
//
//
//        scrollView.contentOffset = CGPoint.zero
//        self.view.addSubview(scrollView)
//        delegate?.guideImagesView(imgView: imgsView)
//
//								if imgsView.count == 1{
//												delegate?.browseComplete()
//								}
//
//								let closeBtn = UIButton(type: .roundedRect)
//								closeBtn.backgroundColor = UIColor(hexStr: "#b3b5b6")
//								closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
//								closeBtn.setTitleColor(.white, for: .normal)
//								closeBtn.setTitle("跳过", for: .normal)
//								closeBtn.jq_cornerRadius = 12.5
//								self.view.addSubview(closeBtn)
//								closeBtn.snp.makeConstraints { make in
//												if #available(iOS 11.0, *) {
//																make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
//												} else {
//																make.top.equalToSuperview()
//												}
//												make.right.equalTo(-20)
//												make.width.equalTo(60)
//												make.height.equalTo(25)
//								}
//
//    }
//
//
//    /// `convenience init`完成后，进行加载
//    public func loadAtWindow(){
//        if let window = UIApplication.shared.keyWindow{
//            window.addSubview(self.view)
//            self.view.frame = window.frame
//        }
//    }
//
//    /// 渐隐消失
//    /// - Parameter withDuration: 消失时间
//    public func hiddenGuide(_ withDuration:TimeInterval = 2.0){
////        UIView.animate(withDuration: withDuration) {
////            self.view.alpha = 0
////        } completion: { (complete) in
////            self.removeFromParent()
////												self.dismiss(animated: false)
////        }
//								self.dismiss(animated: true)
//    }
//
//				@objc func closeAction(){
//								hiddenGuide()
//				}
//
//    //scrollview滚动的时候就会调用
//    public func scrollViewDidScroll(_ scrollView: UIScrollView){
//        let page = Int(scrollView.contentOffset.x/self.view.bounds.size.width)
//        delegate?.currtentPage(page: page, imgView: imgsView[page])
//        let twidth = CGFloat(guideImages.count-1) * self.view.bounds.size.width
//        //如果在最后一个页面继续滑动的话就会跳转到主页面
//        if(scrollView.contentOffset.x >= twidth)
//        {
//            self.delegate?.browseComplete()
//        }
//    }
//}
