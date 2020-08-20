//
//  JQ_PhotoTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/17.
//

import UIKit

import Foundation
import UIKit
import Photos

/// 监听相册的变化：新增，修改，删除
public class JQ_PhotoTool:NSObject{
    
    public enum JQPhotoType {
        case add
        case update
        case delete
        case none
    }
    
    public static let `default` = JQ_PhotoTool()
    //取得的资源结果，用来存放的PHAsset
    public var assetsFetchResults:PHFetchResult<PHAsset>!
    //带缓存的图片管理对象
    public var imageManager:PHCachingImageManager!
    //缩略图大小
    private var assetGridThumbnailSize:CGSize!
    private var clouse:((JQPhotoType,UIImage?,[AnyHashable : Any]?)->Void)?
    private var photoType:JQPhotoType = .none
    
    public override init() {
        super.init()
        
        self.imageManager = PHCachingImageManager()
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {return}
            
            //启动后先获取目前所有照片资源
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                                 ascending: false)]
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                     PHAssetMediaType.image.rawValue)
            self.assetsFetchResults = PHAsset.fetchAssets(with: .image,
                                                          options: allPhotosOptions)
            print("--- 资源获取完毕 ---")
            
            //监听资源改变
            PHPhotoLibrary.shared().register(self)
        })
    }
    
    public func requestClouse(thumbnailSize:CGSize,clouse:@escaping (JQPhotoType,UIImage?,[AnyHashable:Any]?)->Void){
        assetGridThumbnailSize = thumbnailSize
        self.clouse = clouse
    }
}

extension JQ_PhotoTool:PHPhotoLibraryChangeObserver{
    //当照片库发生变化的时候会触发
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        //获取assetsFetchResults的所有变化情况，以及assetsFetchResults的成员变化前后的数据
        guard let collectionChanges = changeInstance.changeDetails(for:
            self.assetsFetchResults as! PHFetchResult<PHObject>) else { return }
        
        
        unowned let weakSelf = self
        DispatchQueue.main.async {
            //获取最新的完整数据
            if let allResult = collectionChanges.fetchResultAfterChanges
                as? PHFetchResult<PHAsset>{
                weakSelf.assetsFetchResults = allResult
            }
            
            if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves{
                return
            }else{
                //照片删除情况
                if let removedIndexes = collectionChanges.removedIndexes,
                    removedIndexes.count > 0{
                    weakSelf.photoType = .delete
                    weakSelf.clouse?(weakSelf.photoType,nil,nil)
                }
                //照片修改情况
                if let changedIndexes = collectionChanges.changedIndexes,
                    changedIndexes.count > 0{
                    weakSelf.photoType = .update
                    weakSelf.clouse?(weakSelf.photoType,nil,nil)
                }
                //照片新增情况
                if let insertedIndexes = collectionChanges.insertedIndexes,
                    insertedIndexes.count > 0{
                    weakSelf.photoType = .add
                    //获取最后添加的图片资源
                    let asset = weakSelf.assetsFetchResults[insertedIndexes.first!]
                    
                    //获取缩略图
                    weakSelf.imageManager.requestImage(for: asset,
                                                       targetSize: weakSelf.assetGridThumbnailSize,
                                                       contentMode: .aspectFill, options: nil) {
                                                        (image, info) in
                                                        weakSelf.clouse?(weakSelf.photoType,image!,info)
                    }
                }
            }
        }
    }
}
