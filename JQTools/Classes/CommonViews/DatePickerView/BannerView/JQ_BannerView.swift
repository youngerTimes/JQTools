//
//  BannerView.swift
//  YKTools
//
//  Created by 杨锴 on 2019/6/14.
//  Copyright © 2019 younger_times. All rights reserved.
//

import UIKit

public class JQ_BannerView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    var offset:CGFloat?
    var timer:Timer?
    
    var avgOffset:CGFloat?
    
    var itemWidth:CGFloat = 0
    var itemHeight:CGFloat = 0
    var currentPage:Int = 0
    var timeInterval:TimeInterval = 5.0
    var pageControl:JQ_BannerPageControl?
    
    
    lazy var collectionView:UICollectionView = {
        var layout = JQ_FlowLayout()
        layout.scrollDirection = .horizontal
        
        self.itemWidth = self.jq_width  * 0.75
        self.itemHeight = self.jq_height * 0.9
        
        layout.itemSize = CGSize(width: self.itemWidth, height: self.itemHeight)
        let collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: JQ_ScreenW, height: self.jq_height), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: "BannerView")
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
    public var items:Array<JQ_BannerModel>?{
        didSet{
            guard self.items == nil else {
                if self.items!.count > 2{
                    
                    let count = self.items!.count
                    var fontArray = Array<JQ_BannerModel>()
                    fontArray.append(self.items![count - 2])
                    fontArray.append(self.items!.last!)
                    
                    var backArray = Array<JQ_BannerModel>()
                    backArray.append(self.items![0])
                    backArray.append(self.items![1])
                    
                    self.items!.insert(contentsOf: fontArray, at: 0)
                    self.items!.append(contentsOf: backArray)
                }
                self.collectionView.reloadData()
                let flow = self.collectionView.collectionViewLayout as! JQ_FlowLayout
                avgOffset = flow.itemSize.width + flow.minimumInteritemSpacing
                self.collectionView.setContentOffset(CGPoint(x: avgOffset! * 2, y: 0), animated: true)
                
                return
            }
        }
    }
    
    public init(autoScroll:Bool = false) {
        let rect = CGRect(x: 0, y: 0, width: JQ_ScreenW, height: 120 * JQ_RateW)
        super.init(frame:rect)
        collectionView.backgroundColor = self.backgroundColor
        addSubview(collectionView)
        if autoScroll{
            timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)

            unowned let weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: .now()+timeInterval) {
                weakSelf.timer!.fireDate = NSDate.distantPast
                RunLoop.current.add(weakSelf.timer!, forMode: .common)
            }
        }
        
        pageControl = JQ_BannerPageControl()
        pageControl?.numberOfPages = 5
//        pageControl?.currentPage = 0
        addSubview(pageControl!)
        pageControl!.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self).offset(-10 * JQ_RateH)
            make.height.equalTo(15)
            make.width.equalTo(JQ_ScreenW/2)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func timerAction(_ timer:Timer){
       let offset =  self.collectionView.contentOffset.x + avgOffset!
        currentPage = Int(offset/itemWidth)
        self.collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        if currentPage > items!.count - 2{
            collectionView.setContentOffset(CGPoint(x: avgOffset!*2, y: 0), animated: false)
            timer.fire()
        }
    }
    
    //MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerView", for: indexPath) as! BannerCell
         let model = items![indexPath.row] as JQ_BannerModel
        cell.label.text = model.id
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollView.setContentOffset(CGPoint(x: targetContentOffset.pointee.x, y: 0), animated: true)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offset =  self.collectionView.contentOffset.x + avgOffset!
        currentPage = Int(offset/itemWidth)
        print("page:\(currentPage)")
    }
}
