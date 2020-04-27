//
//  CommonCodeBlock.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/4/27.
//

//通用的重复性代码块
class JQ_CommonCodeBlock{
    
//    /// 上传图片至腾讯
//    /// - Parameter imgs: 图片集合
//    /// - Parameter clouse: 返回上传完成的图片路径
//    static func common_updateCoverImg(_ imgs:[UIImage],clouse: @escaping ([String])->(Void)){
//        KYNetWork.request(target: .TencentUpdate).mapObject(type: TXUpdateModel.self).subscribe(onSuccess: { (model) in
//            Defaults[.TXsecretKey] = model.secretKey
//            Defaults[.TXtoken] = model.token
//            Defaults[.TXsecretId] = model.secretId
//            var flishUpdate:[String] = []
//            if imgs.count > 0{
//                for img in imgs{
//                    let data = img.jpegData(compressionQuality: 1.0)
//                    let uuid = "/\(Defaults[.objectId])/\(UUID().uuidString).jpg"
//                    if data == nil {
//                        DispatchQueue.main.sync {
//                            KYTool.ky_showError(errorStr: "包含了无效的图片")
//                        }
//                        return
//                    }
//
//                    QCloudCOSTools.updateImg(data!, isHeaderIcon: false, imgName: uuid, bucket: model.bucketName) { (imgName) -> (Void) in
//                        flishUpdate.append(imgName)
//                        if flishUpdate.count == imgs.count{
//                            clouse(flishUpdate)
//                        }
//                    }
//                }
//            }else{
//                clouse([""])
//            }
//        }) { (error) in
//
//        }.disposed(by: disposeBag)
//    }
//
//    static func common_updatePHAssets(_ assets:[PHAsset],clouse: @escaping ([String])->(Void)){
//        KYNetWork.request(target: .TencentUpdate).mapObject(type: TXUpdateModel.self).subscribe(onSuccess: { (model) in
//            Defaults[.TXsecretKey] = model.secretKey
//            Defaults[.TXtoken] = model.token
//            Defaults[.TXsecretId] = model.secretId
//            var flishUpdate:[String] = []
//            if assets.count > 0{
//                for asset in assets{
//                    //上传图片
//                    if asset.mediaType == .image{
//                        let options = PHImageRequestOptions()
//                        options.resizeMode = .fast
//                        PHImageManager.default().requestImageData(for: asset, options: options) { (data, info, ori, info1) in
//                            let uuid = "/\(Defaults[.objectId])/\(UUID().uuidString).jpg"
//                            if data == nil {
//                                DispatchQueue.main.sync {
//                                    KYTool.ky_showError(errorStr: "包含了无效的图片")
//                                };return
//                            }
//
//                            QCloudCOSTools.updateImg(data!, isHeaderIcon: false, imgName: uuid, bucket: model.bucketName) { (imgName) -> (Void) in
//                                flishUpdate.append(imgName)
//                                if flishUpdate.count == assets.count{
//                                    clouse(flishUpdate)
//                                }
//                            }
//                        }
//                    }
//
//                    //上传视频
//                    if asset.mediaType == .video{
//                        let options = PHVideoRequestOptions()
//                        options.isNetworkAccessAllowed = true
//                        options.deliveryMode = .automatic
//
//                        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (videoAsset, mix, info) in
//                            if videoAsset != nil{
//                                let uuid = "/\(Defaults[.objectId])/\(UUID().uuidString).mov"
//                                let video = videoAsset as! AVURLAsset
//                                QCloudCOSTools.updateVideo(video, videoName: uuid, bucket: model.bucketName) { (urls) -> (Void) in
//                                    flishUpdate.append(urls)
//                                    if flishUpdate.count == assets.count{
//                                        clouse(flishUpdate)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }else{
//                clouse([""])
//            }
//        }) { (error) in
//
//        }.disposed(by: disposeBag)
//    }
}
