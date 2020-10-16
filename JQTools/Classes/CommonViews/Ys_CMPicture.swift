//
//  Ys_CMPicture.swift
//  DrunkenMeilan
//
//  Created by apple on 2018/12/17.
//  Copyright © 2018 stitch. All rights reserved.
//

#if canImport(TZImagePickerController)

import UIKit
import TZImagePickerController

let CMPictur = Ys_CMPicture()

class Ys_CMPicture: NSObject,TZImagePickerControllerDelegate {
    //MARK: -- 选择图片
    func chooseMorePictur(oldPictures:NSMutableArray,selectedAssets:NSMutableArray ,selectIndex:Int?,maximum:Int,canVideo:Bool,chooseOver:(()->Void)?) {
        //相册
        let imagePic = TZImagePickerController(maxImagesCount: maximum, columnNumber: 3, delegate: self)
        imagePic!.showSelectedIndex = true
        imagePic!.preferredLanguage = "zh-Hans"
        imagePic!.allowPickingVideo = false
        imagePic!.allowPickingImage = true
        imagePic!.modalPresentationStyle = .fullScreen
        if selectedAssets.count > 0 {
            imagePic!.selectedAssets = selectedAssets
        }
        // 设置竖屏下的裁剪尺寸
        let left:CGFloat = 30*JQ_RateW
        let widthHeight:CGFloat = JQ_ScreenW - 2 * left;
        let top:CGFloat = (JQ_ScreenH - widthHeight)/2.0;
        imagePic!.cropRect = CGRect(x: left, y: top, width: widthHeight, height: widthHeight)
        
        imagePic?.didFinishPickingPhotosHandle = { photos, asset, isSelectOriginalPhoto in
            oldPictures.removeAllObjects()
            oldPictures.addObjects(from: photos!)
            selectedAssets.removeAllObjects()
            selectedAssets.addObjects(from: asset!)
            chooseOver?()
        }

        JQ_currentNavigationController().present(imagePic!, animated: true, completion: nil)
    }
    
    //MARK: -- 预览图片
    func previewPictur(oldPictures:NSMutableArray,selectedAssets:NSMutableArray ,selectIndex:Int?,maximum:Int,previewOver:((_ arry:[UIImage])->Void)?) {
        let imagePVc = TZImagePickerController(selectedAssets: selectedAssets, selectedPhotos: oldPictures, index: selectIndex!)
        //imagePVc.navigationBar.barTintColor = NavBackColor;
        //允许选择gif图
        imagePVc!.allowPickingGif = true
        imagePVc!.allowPickingVideo = false
        imagePVc!.preferredLanguage = "zh-Hans"
        imagePVc?.didFinishPickingPhotosHandle = { photos,assets,isSelectOriginalPhoto in
            selectedAssets.removeAllObjects()
            selectedAssets.addObjects(from: assets!)
            previewOver?(photos!)
        }
        imagePVc?.didFinishPickingGifImageHandle = {animatedImage,sourceAssets in
            //选择gif图片
            print("用户选择了一张gif图片")
        }
        imagePVc!.selectedAssets = selectedAssets
        JQ_currentNavigationController().present(imagePVc!, animated: true, completion: nil)
    }
}
#endif
