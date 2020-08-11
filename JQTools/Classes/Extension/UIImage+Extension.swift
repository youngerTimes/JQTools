//
//  UIImage+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

//水印位置枚举
public enum WaterMarkCorner{
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
}

extension UIImage{
    
    /// 添加水印方法:添加文字
    public func jq_waterMarkeText(waterMarkText:String, corner:WaterMarkCorner = .BottomLeft,
                                  margin:CGPoint = CGPoint(x: 20, y: 20),
                                  waterMarkTextColor:UIColor = UIColor.white,
                                  waterMarkTextFont:UIFont = UIFont.systemFont(ofSize: 20),
                                  backgroundColor:UIColor = UIColor.clear) -> UIImage?{
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:waterMarkTextColor,
                              NSAttributedString.Key.font:waterMarkTextFont,
                              NSAttributedString.Key.backgroundColor:backgroundColor]
        let textSize = NSString(string: waterMarkText).size(withAttributes: textAttributes)
        var textFrame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        let imageSize = self.size
        switch corner{
            case .TopLeft:
                textFrame.origin = margin
            case .TopRight:
                textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
            case .BottomLeft:
                textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
            case .BottomRight:
                textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                                           y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        NSString(string: waterMarkText).draw(in:textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return waterMarkedImage
    }
    
    //添加图片水印方法：添加图片
    public func jq_waterMarkeImg(waterMarkImage:UIImage, corner:WaterMarkCorner = .BottomRight,
                                 margin:CGPoint = CGPoint(x: 20, y: 20), alpha:CGFloat = 1) -> UIImage{
        
        var markFrame = CGRect(x:0, y: 0, width:waterMarkImage.size.width,
                               height: waterMarkImage.size.height)
        let imageSize = self.size
        
        switch corner{
            case .TopLeft:
                markFrame.origin = margin
            case .TopRight:
                markFrame.origin = CGPoint(x: imageSize.width - waterMarkImage.size.width - margin.x,
                                           y: margin.y)
            case .BottomLeft:
                markFrame.origin = CGPoint(x: margin.x,
                                           y: imageSize.height - waterMarkImage.size.height - margin.y)
            case .BottomRight:
                markFrame.origin = CGPoint(x: imageSize.width - waterMarkImage.size.width - margin.x,
                                           y: imageSize.height - waterMarkImage.size.height - margin.y)
        }
        
        // 开始给图片添加图片
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y:0, width: imageSize.width, height: imageSize.height))
        waterMarkImage.draw(in: markFrame, blendMode: .normal, alpha: alpha)
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return waterMarkedImage!
    }
    
    
    /// 创建一个透明的图片，可用于nav:        navigationController?.navigationBar.isTranslucent = true
    /// - Parameter rect: 尺寸
    public static func jq_createClarityImg(rect:CGRect,alpha:CGFloat = 0)->UIImage{
        let color = UIColor.clear
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.withAlphaComponent(alpha).cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image ?? UIImage()
    }
    
    /// 创建带有颜色的图片
    public static func jq_createColorImg(rect:CGRect,color:UIColor,alpha:CGFloat = 0)->UIImage{
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.withAlphaComponent(alpha).cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image ?? UIImage()
    }
    
    /*
     滤镜
     https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346
     
     【查看】CICategoryColorEffect
     
     */
    func jq_filter(name:String) -> UIImage?
    {
        let imageData = self.pngData()
        let inputImage = CoreImage.CIImage(data: imageData!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:name)
        filter!.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(0.8, forKey: "inputIntensity")
        if let outputImage = filter!.outputImage {
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)
            return UIImage(cgImage: outImage!)
        }
        return nil
    }
    
    
    /// 更改图片颜色
    public func jq_imageWithTintColor(color : UIColor) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)//kCGBlendModeNormal
        context?.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!);
        color.setFill()
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    /// 更改图片颜色，根据mode
    /// - Parameters:
    ///   - color: 颜色
    ///   - blendMode: 模型
    /// - Returns: 颜色
    public func jq_imageWithTintColor(color: UIColor, blendMode: CGBlendMode) -> UIImage?{
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
    //重设颜色
    public func jq_imageWithNewSize(size: CGSize) -> UIImage? {
        if self.size.height > size.height {
            let width = size.height / self.size.height * self.size.width
            let newImgSize = CGSize(width: width, height: size.height)
            UIGraphicsBeginImageContext(newImgSize)
            self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let newImg = theImage else { return  nil}
            return newImg
        } else {
            let newImgSize = CGSize(width: size.width, height: size.height)
            UIGraphicsBeginImageContext(newImgSize)
            self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let newImg = theImage else { return  nil}
            return newImg
        }
    }
    
    ///将图片裁剪成指定比例（多余部分自动删除）
    func jq_crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
     
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
         
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return scaledImage!
    }
    
    ///将图片缩放成指定尺寸（多余部分自动删除）
    func jq_scaled(to newSize: CGSize) -> UIImage {
        //计算比例
        let aspectWidth  = newSize.width/size.width
        let aspectHeight = newSize.height/size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
         
        //图片绘制区域
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
         
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return scaledImage!
    }
}
