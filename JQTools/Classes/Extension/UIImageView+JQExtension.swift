//
//  UIImageView+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//
import QuartzCore
import SDWebImage

public extension UIImageView{
    /**
     Loads an image from a URL. If cached, the cached image is returned. Otherwise, a place holder is used until the image from web is returned by the closure.

     - Parameter url: The image URL.
     - Parameter placeholder: The placeholder image.
     - Parameter fadeIn: Weather the mage should fade in.
     - Parameter closure: Returns the image from the web the first time is fetched.

     - Returns A new image
     */
    func jq_imageFromURL(_ url: String?, placeholder: UIImage, fadeIn: Bool = true, shouldCacheImage: Bool = true, closure: ((_ image: UIImage?) -> ())? = nil)
    {
        if url == nil{
            self.image = placeholder
//            closure?(placeholder)
            return
        }

        self.image = UIImage.image(fromURL: url!, placeholder: placeholder, shouldCacheImage: shouldCacheImage) {
            (image: UIImage?) in
            if image == nil {
                return
            }
            self.image = image
            if fadeIn {
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.type = CATransitionType.fade
                self.layer.add(transition, forKey: nil)
            }
            closure?(image)
        }
    }

    func jq_sdimage(url:String?,placeholderImage:UIImage? = nil,options:SDWebImageOptions = .queryDiskDataSync){
        self.sd_setImage(with: URL(string: url ?? ""), placeholderImage: placeholderImage, options: options, completed: nil)
    }

    /// 加载JQTools中 Assets.xcassets中数据
    /// - Parameter name: 图片名称
    func jq_Bundle(_ name:String){
        let a = Bundle(for: JQTool.self)
        let image = UIImage(named: name, in: a, compatibleWith: .none)
        self.image = image
    }


    /// 加载GIF动态图
    func jq_showGIFWith(name:String,duration:Int){
        self.stopAnimating()
        let gifImageUrl = Bundle.main.url(forResource: name, withExtension: nil)

        let gifSource = CGImageSourceCreateWithURL( gifImageUrl! as CFURL, nil)
        let gifcount = CGImageSourceGetCount(gifSource!)
        var images = [UIImage]()
        for i in 0..<gifcount{
            let imageRef = CGImageSourceCreateImageAtIndex(gifSource!, i, nil)
            let image = UIImage(cgImage: imageRef!)
            images.append(image)
        }
        self.animationImages = images
        self.animationDuration = TimeInterval(duration)
        self.animationRepeatCount = 0
        self.contentMode = .scaleAspectFit
        self.startAnimating()
    }
}
