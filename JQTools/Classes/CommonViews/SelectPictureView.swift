//
//  SelectPictureView.swift
//  NirvanaCar
//
//  Created by 胡玳源 on 2020/4/26.
//  Copyright © 2020 Mr. Hu. All rights reserved.
//


#if canImport(TZImagePickerController)
import UIKit

class SelectPictureView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {

    var collectionV: UICollectionView!
    var layout:UICollectionViewFlowLayout!
    var Addpicture = "Complaint_AddImage"
    var picture_ratio:CGFloat = 1
    var maximum = 0
    var acrossnum:CGFloat = 3
    var canVideo = false
    var returnHeight:((_ height:CGFloat)->Void)?
    var pictureArr = NSMutableArray()
    var dataArr = NSMutableArray()
    var assetsArr = NSMutableArray()
    var imageSize:CGSize!
    var imgCornerRadius:CGFloat = 0 //图片切角
    
    var returnData:((_ picture: [Any])->Void)?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if pictureArr.contains(Addpicture) {return}
         pictureArr.add(Addpicture)
        
        layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        if imageSize == nil{
            layout.itemSize = CGSize(width: frame.size.width/acrossnum, height: frame.size.width/acrossnum*picture_ratio)
        }else{
            layout.itemSize = imageSize
        }
        layout.scrollDirection = .vertical
        collectionV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionV.register(UINib(nibName: "SelectPictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectPicture")
        collectionV.backgroundColor = .white
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.isScrollEnabled = false
        if !self.subviews.contains(collectionV){
            addSubview(collectionV)
            collectionV.snp.makeConstraints { (make) in
                make.edges.equalTo(0)
            }
        }
        collectionV.layoutIfNeeded()
        returnHeight?(collectionV.contentSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectPicture", for: indexPath) as! SelectPictureCollectionViewCell
        cell.data = pictureArr[indexPath.row]
        cell.imageV.layer.masksToBounds = true
        cell.imageV.layer.cornerRadius = imgCornerRadius
        
        weak var wSelf = self
        cell.removeClick = {data in
            let index = wSelf?.dataArr.index(of: data)
            wSelf?.pictureArr.removeObject(at: index!)
            wSelf?.dataArr.removeObject(at: index!)
            wSelf?.assetsArr.removeObject(at: index!)
            if wSelf!.dataArr.count < wSelf!.maximum && !wSelf!.pictureArr.contains(wSelf!.Addpicture){
                wSelf!.pictureArr.add(wSelf!.Addpicture)
            }
            wSelf!.returnData?(wSelf!.dataArr as! [Any])
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            wSelf!.returnHeight?(collectionView.contentSize.height)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        weak var wSelf = self
        if pictureArr.contains(Addpicture) && indexPath.row == pictureArr.count-1{
            let selectIndex = pictureArr.count > 1 ? indexPath.row-1 : nil
            CMPictur.chooseMorePictur(oldPictures: dataArr, selectedAssets: assetsArr, selectIndex: selectIndex, maximum: maximum,canVideo:canVideo) {
                if wSelf != nil{
                    wSelf!.pictureArr.removeAllObjects()
                    wSelf!.pictureArr.addObjects(from: wSelf!.dataArr as! [Any])
                    if wSelf!.dataArr.count < wSelf!.maximum{
                        if wSelf!.pictureArr.contains(wSelf!.Addpicture){
                            let index = wSelf!.pictureArr.index(of: wSelf!.Addpicture)
                            wSelf!.pictureArr.exchangeObject(at: index, withObjectAt: wSelf!.pictureArr.count-1)
                        }else{
                            wSelf!.pictureArr.add(wSelf!.Addpicture)
                        }
                    }
                    wSelf!.returnData?(wSelf!.dataArr as! [Any])
                    collectionView.reloadData()
                    collectionView.layoutIfNeeded()
                    wSelf!.returnHeight?(collectionView.contentSize.height)
                }
            }
            return
        }else if assetsArr[indexPath.row] != nil{
            CMPictur.previewPictur(oldPictures: dataArr, selectedAssets: assetsArr, selectIndex: indexPath.row, maximum: maximum) { (imageArr) in
                
            }
        }
    }
}
#endif
