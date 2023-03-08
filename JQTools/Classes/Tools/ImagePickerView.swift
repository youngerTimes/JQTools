//
//  ImagePickerView.swift
//  JQTools
//
//  Created by 无故事王国 on 2022/4/21.
//


import Foundation
import TZImagePickerController
import UIKit
import Photos
import PhotosUI
import AssetsLibrary

class ImagePickerView:NSObject{
    private var clouse:(([UIImage])->Void)?
    private var clipSize:CGSize?
    private var clipRect:CGRect{
        get{
            var clipFrame = CGRect.zero
            guard clipSize != nil else {return clipFrame}
            clipFrame.size = clipSize!
            clipFrame.origin = CGPoint(x: (JQ_ScreenW - clipSize!.width)/2.0, y: (JQ_ScreenH - clipSize!.height)/2.0)
            return clipFrame

        }
    }
    private static var _shareInstance:ImagePickerView?
    private weak var handerVC:UIViewController?

    static func getShareInstance()->ImagePickerView{
        guard let instance = _shareInstance else {
            _shareInstance = ImagePickerView()
            return _shareInstance!
        }
        return instance
    }

    static func destory(){
        _shareInstance = nil
    }


    public func alertSheetPicture(handleVc:UIViewController? = nil,currentCount:Int = 0,maxCount:Int = 1,clipSize:CGSize? = nil,clouse:@escaping ([UIImage])->Void){
        handerVC = handleVc
        CommonAlertSheetView.show(vc: nil, type: .single, titles: ["相册","拍照"], imgs: nil) {[weak self] index, str in
            guard let weakSelf = self else { return  }
            weakSelf.clouse = clouse
            weakSelf.clipSize = clipSize
            switch index {
                case 0:
                    let p = TZImagePickerController(maxImagesCount: maxCount - currentCount, columnNumber: 4, delegate: self)
                    p!.allowTakeVideo = false
                    p!.modalPresentationStyle = .fullScreen
                    p!.allowTakePicture = false
                    p!.sortAscendingByModificationDate = true
                    p!.allowPickingVideo = false
                    p!.allowCrop = clipSize != nil ? true:false

                    if clipSize != nil {
                        p!.cropRect = weakSelf.clipRect
                    }

                    if handleVc != nil{
                        handleVc!.present(p!, animated: true, completion: nil)
                    }else{
                        JQ_currentViewController().present(p!, animated: true, completion: nil)
                    }
                case 1:
                    //iOS15.0未完全授权会崩溃
                    TZImageManager.default().requestAuthorization {
                        let p = UIImagePickerController()
                        p.delegate = self
                        p.modalPresentationStyle = .fullScreen
                        p.allowsEditing = false
                        p.sourceType = .camera
                        if handleVc != nil{
                            handleVc!.present(p, animated: true, completion: nil)
                        }else{
                            JQ_currentViewController().present(p, animated: true, completion: nil)
                        }
                    }
                default:break
            }
        }
    }
}

extension ImagePickerView:TZImagePickerControllerDelegate{

    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        clouse?(photos)
        ImagePickerView.destory()
    }
}

extension ImagePickerView:UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

        if clipSize != nil{
            picker.dismiss(animated: true) {
                var assetId:String = ""
                PHPhotoLibrary.shared().performChanges {
                    assetId = PHAssetCreationRequest.creationRequestForAsset(from: originImage).placeholderForCreatedAsset!.localIdentifier
                } completionHandler: {[weak self] sta, error in
                    guard let weakSelf = self else { return }
                    DispatchQueue.main.async {
                        let ass = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).lastObject
                        let pickerClipVC = TZImagePickerController.init(cropTypeWith:ass, photo: originImage) { img, asset in
                            weakSelf.clouse?([img!])
                            ImagePickerView.destory()
                        }
                        pickerClipVC?.cropRect = weakSelf.clipRect
                        pickerClipVC?.modalPresentationStyle = .fullScreen

                        if weakSelf.handerVC != nil{
                            weakSelf.handerVC!.present(pickerClipVC!, animated: true, completion: nil)
                        }else{
                            JQ_currentViewController().present(pickerClipVC!, animated: true, completion: nil)
                        }
                    }
                }
            }
        }else{
            picker.dismiss(animated: true) { [weak self] in
                self?.clouse?([originImage])
                ImagePickerView.destory()
            }
        }
    }
}
