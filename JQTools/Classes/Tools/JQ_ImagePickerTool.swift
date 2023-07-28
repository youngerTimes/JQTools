//
//  JQ_ImagePickerTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/16.
//

import UIKit
import TZImagePickerController


/// 本地图片选择器
public class JQ_ImagePickerTool: NSObject{
    public typealias JQ_ImagePickerClouse = ((UIImage)->Void)?
    public typealias JQ_ImagePickerMutiClouse = (([UIImage],[Any])->Void)?

    private enum ChooseTypeEnum {
        case album
        case camera
        case none
    }

    private enum ChooseMethodType{
        case profile //头像选择
        case muti //多图选择
        case single //单图选择
        case none
    }

    private var authorizesTool = JQ_AuthorizesTool.default //授权检查
    private var clouse:JQ_ImagePickerClouse!
    private var mutiClouse:JQ_ImagePickerMutiClouse!
    private var chooseMethodType:ChooseMethodType = .none //选择的类型
    private var needClip = true //需要裁剪，裁剪
    private var clipSize = CGSize(width: 0, height: 0) //裁剪大小

    //裁剪框frame
    private var clipFrame:CGRect{
        get{
            if clipSize.width == 0 || clipSize.height == 0 {
                assert(false,"未设置裁剪框大小")
            }

            var clipFrame = CGRect.zero
            clipFrame.size = clipSize
            clipFrame.origin = CGPoint(x: (JQ_ScreenW - clipSize.width)/2.0, y: (JQ_ScreenH - clipSize.width)/2.0)
            return clipFrame
        }
    }

    @available(*,deprecated,message: "废弃")
    public static let `default`:JQ_ImagePickerTool = {
        let center = JQ_ImagePickerTool()
        return center
    }()

    private static var _sharedInstance: JQ_ImagePickerTool?
    public class func getSharedInstance() -> JQ_ImagePickerTool {
           guard let instance = _sharedInstance else {
               _sharedInstance = JQ_ImagePickerTool()
               return _sharedInstance!
           }
           return instance
       }

    public override init() {
        super.init()
    }

        //销毁单例对象
    public class func destroy() {
        _sharedInstance = nil
    }
    private func reset(){
        needClip = true
        clipSize = CGSize(width: 0, height: 0)
    }

    /// 提示选择框
    private func showAlert(title:String, _ clouse: @escaping (ChooseTypeEnum)->Void){
        unowned let weakSelf = self
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let libaryAction = UIAlertAction(title: "相册", style: .default) { (_) in
            weakSelf.authorizesTool.openAlbumServiceWithBlock(true) { (status) in
                if status{clouse(.album)}
            }
        }

        let cameraAction = UIAlertAction(title: "拍照", style: .default) { (_) in
            weakSelf.authorizesTool.openCaptureDeviceServiceWithBlock(true) { (status) in
                if status{clouse(.camera)}
            }
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        alertVC.addAction(cameraAction)
        alertVC.addAction(libaryAction)
        alertVC.addAction(cancelAction)

        JQ_currentViewController().present(alertVC, animated: true, completion: nil)
    }

    /// 上传头像:进行一定的压缩，头像默认启用压缩
    /// - Parameters:
    ///   - clouse: 回调
    ///   - clipSize: 裁剪大小
    public func profile(_ clouse:JQ_ImagePickerClouse, needClip:Bool = true){
        self.clouse = clouse
        self.needClip = needClip
        self.chooseMethodType = .profile

        if needClip {
            self.clipSize = CGSize(width: JQ_ScreenW, height: JQ_ScreenW)
        }

        unowned let weakSelf = self
        showAlert(title: "选择选取头像方式") { (type) in
            if type == .album{
                let p = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self)
                p!.modalPresentationStyle = .fullScreen
                p!.allowTakeVideo = false
                p!.allowTakePicture = false
                p!.sortAscendingByModificationDate = true
                p!.allowPickingVideo = false
                p!.maxImagesCount = 1
                p!.allowCrop = needClip
                p!.cropRect = weakSelf.clipFrame
                JQ_currentViewController().present(p!, animated: true, completion: nil)
            }

            if type == .camera{
                DispatchQueue.main.async {
                    let p = UIImagePickerController()
                    p.delegate = self
                    p.modalPresentationStyle = .fullScreen
                    p.allowsEditing = needClip
                    p.sourceType = .camera
                    p.cameraDevice = .front
                    JQ_currentViewController().present(p, animated: true, completion: nil)
                }
            }
        }
    }

    /// 选择单图
    /// - Parameters:
    ///   - clouse: 回调
    ///   - clipSize: 如果需要裁剪，设置
    public func singleImage(_ clouse:JQ_ImagePickerClouse, clipSize:CGSize? = nil){
        self.clouse = clouse
        self.chooseMethodType = .single
        self.needClip = (clipSize != nil)
        self.clipSize = clipSize ?? CGSize.zero

        unowned let weakSelf = self
        showAlert(title: "选择选取图片方式") { (type) in
            if type == .album{
                let p = TZImagePickerController(maxImagesCount: 1, columnNumber: 5, delegate: self)
                p!.modalPresentationStyle = .fullScreen
                p!.allowTakeVideo = false
                p!.allowTakePicture = false
                p!.sortAscendingByModificationDate = true
                p!.allowPickingVideo = false
                p!.maxImagesCount = 1
                p!.allowCrop = weakSelf.needClip

                if weakSelf.needClip {
                    p!.cropRect = weakSelf.clipFrame
                }
                JQ_currentViewController().present(p!, animated: true, completion: nil)
            }

            if type == .camera{
                DispatchQueue.main.async {
                    let p = UIImagePickerController()
                    p.delegate = self
                    p.modalPresentationStyle = .fullScreen
                    p.allowsEditing = false
                    p.sourceType = .camera
                    p.cameraDevice = .rear
                    JQ_currentViewController().present(p, animated: true, completion: nil)
                }
            }
        }
    }


    /// 多图选择
    /// - Parameters:
    ///   - clouse: 回调
    ///   - max: 最大的选择数量
    public func multiImage(_ clouse:JQ_ImagePickerMutiClouse,max:NSInteger,selectAsstes:NSMutableArray? = nil){
        self.chooseMethodType = .muti
        self.mutiClouse = clouse
        let p = TZImagePickerController(maxImagesCount: max, columnNumber: 4, delegate: self)
        p!.modalPresentationStyle = .fullScreen
        p!.allowTakeVideo = false
        p!.allowTakePicture = false
        p!.sortAscendingByModificationDate = true
        p!.allowPickingVideo = false
        p!.allowCrop = false

        if selectAsstes != nil {
            p!.selectedAssets = selectAsstes
        }

        JQ_currentViewController().present(p!, animated: true, completion: nil)
    }
}

extension JQ_ImagePickerTool:TZImagePickerControllerDelegate{
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {

        picker.selectedAssets = NSMutableArray(array: assets)

        if chooseMethodType == .muti {
            mutiClouse!(photos,assets)
        }

        if chooseMethodType == .profile || chooseMethodType == .single {
            clouse!(photos.first!)
        }
        reset()
    }
}

extension JQ_ImagePickerTool:UIImagePickerControllerDelegate{

    //取消
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        unowned let weakSelf = self
        picker.dismiss(animated: true) {
            weakSelf.reset()
        }
    }

    //成功选取
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var image:UIImage

        if chooseMethodType == .profile {
            //需要被裁剪
            if needClip{
                image  = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            }else{
                image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            }
            clouse!(image)
        }


        if self.chooseMethodType == .single {
            image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

            if needClip {
                let corpperVC = VPImageCropperViewController(image: image, cropFrame: clipFrame, limitScaleRatio: Int(image.scale))
                corpperVC.modalPresentationStyle = .fullScreen
                DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                    JQ_currentViewController().present(corpperVC, animated: true, completion: nil)
                }

                unowned let weakSelf = self
                corpperVC.imageCropperHandler { (vc, image) in
                    if weakSelf.clouse != nil {
                        weakSelf.clouse!(image)
                        corpperVC.dismiss(animated: true) {
                            weakSelf.reset()
                        }
                    }
                } cancelClouse: {
                    corpperVC.dismiss(animated: true) {
                        weakSelf.reset()
                    }
                }
            }else{
                clouse!(image)
            }
        }

        unowned let weakSelf = self
        picker.dismiss(animated: true) {
            weakSelf.reset()
        }
    }
}

//extension JQ_ImagePickerTool:ImageCropperDelegate{
//    public func imageCropper(_ cropperViewController: VPImageCropperViewController, didFinished editedImage: UIImage) {
//        if clouse != nil {
//            clouse!(editedImage)
//
//            unowned let weakSelf = self
//            cropperViewController.dismiss(animated: true) {
//                weakSelf.reset()
//            }
//        }
//    }
//
//    public func imageCropperDidCancel(_ cropperViewController: VPImageCropperViewController) {
//        unowned let weakSelf = self
//        cropperViewController.dismiss(animated: true) {
//            weakSelf.reset()
//        }
//    }
//}

extension JQ_ImagePickerTool:UINavigationControllerDelegate{}
