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

public extension UIImage{
    
    // MARK: -- Class func
    ///生成群聊图标
    class func jq_groupIcon(wh:CGFloat, images:[UIImage], bgColor:UIColor?) -> UIImage {
        let finalSize = CGSize(width:wh, height:wh)
        var rect: CGRect = CGRect.zero
        rect.size = finalSize
        
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可
        UIGraphicsBeginImageContextWithOptions(finalSize, false, 0)
        
        //绘制背景
        if (bgColor != nil) {
            let context: CGContext = UIGraphicsGetCurrentContext()!
            //添加矩形背景区域
            context.addRect(rect)
            //设置填充颜色
            context.setFillColor(bgColor!.cgColor)
            context.drawPath(using: .fill)
        }
        
        //绘制图片
        if images.count >= 1 {
            //获取群聊图标中每个小图片的位置尺寸
            let rects = self.getRectsInGroupIcon(wh:wh, count:images.count)
            var count = 0
            //将每张图片绘制到对应的区域上
            for image in images {
                if count > rects.count-1 {
                    break
                }
                
                let rect = rects[count]
                image.draw(in: rect)
                count = count + 1
            }
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //获取群聊图标中每个小图片的位置尺寸
    private class func getRectsInGroupIcon(wh:CGFloat, count:Int) -> [CGRect] {
        //如果只有1张图片就直接占全部位置
        if count == 1 {
            return [CGRect(x:0, y:0, width:wh, height:wh)]
        }
        
        //下面是图片数量大于1张的情况
        var array = [CGRect]()
        //图片间距
        var padding: CGFloat = 10
        //小图片尺寸
        var cellWH: CGFloat
        //用于后面计算的单元格数量（小于等于4张图片算4格单元格，大于4张算9格单元格）
        var cellCount:Int
        
        if count <= 4 {
            cellWH = (wh-padding*3)/2
            cellCount = 4
        } else {
            padding = padding/2
            cellWH = (wh-padding*4)/3
            cellCount = 9
        }
        
        //总行数
        let rowCount = Int(sqrt(Double(cellCount)))
        //根据单元格长宽，间距，数量返回所有单元格初步对应的位置尺寸
        for i in 0..<cellCount {
            //当前行
            let row = i/rowCount
            //当前列
            let column = i%rowCount
            let rect = CGRect(x:padding*CGFloat(column+1)+cellWH*CGFloat(column),
                              y:padding*CGFloat(row+1)+cellWH*CGFloat(row),
                              width:cellWH, height:cellWH)
            array.append(rect)
        }
        
        //根据实际图片的数量再调整单元格的数量和位置
        if count == 2 {
            array.removeSubrange(0...1)
            for i in 0..<array.count {
                array[i].origin.y = array[i].origin.y - (padding+cellWH)/2
            }
        }else if count == 3 {
            array.remove(at: 0)
            array[0].origin.x = (wh-cellWH)/2
        }else if count == 5 {
            array.removeSubrange(0...3)
            for i in 0..<array.count {
                if i<2 {
                    array[i].origin.x = array[i].origin.x - (padding+cellWH)/2
                }
                array[i].origin.y = array[i].origin.y - (padding+cellWH)/2
            }
        }else if count == 6 {
            array.removeSubrange(0...2)
            for i in 0..<array.count {
                array[i].origin.y = array[i].origin.y - (padding+cellWH)/2
            }
        }else if count == 7 {
            array.removeSubrange(0...1)
            array[0].origin.x = (wh-cellWH)/2
        }
        else if count == 8 {
            array.remove(at: 0)
            for i in 0..<2 {
                array[i].origin.x = array[i].origin.x - (padding+cellWH)/2
            }
        }
        return array
    }
    
    // MARK: -- Instance
    
    /// 生成一张高斯模糊图
    func jq_blur(_ value:CGFloat)->UIImage{
        let context = CIContext(options: nil)
        let inputImage =  CIImage(image: self)
        //使用高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        //设置模糊半径值（越大越模糊）
        filter.setValue(value, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        let cgImage = context.createCGImage(outputCIImage, from: rect)
        //显示生成的模糊图片
        return UIImage(cgImage: cgImage!)
    }

    ///返回一个将白色背景变透明的UIImage
    func jq_imageByRemoveWhiteBg() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return transparentColor(colorMasking: colorMasking)
    }

    ///返回一个将黑色背景变透明的UIImage
    func jq_imageByRemoveBlackBg() -> UIImage? {
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return transparentColor(colorMasking: colorMasking)
    }

    private func transparentColor(colorMasking:[CGFloat]) -> UIImage? {
        if let rawImageRef = self.cgImage {
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                let context: CGContext = UIGraphicsGetCurrentContext()!
                context.translateBy(x: 0.0, y: self.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.draw(maskedImageRef, in: CGRect(x:0, y:0, width:self.size.width,
                                                        height:self.size.height))
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }
    
    
    ///生成圆形图片
    func jq_toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
    
    /// 添加水印方法:添加文字
    func jq_waterMarkeText(waterMarkText:String, corner:WaterMarkCorner = .BottomLeft,
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
    func jq_waterMarkeImg(waterMarkImage:UIImage, corner:WaterMarkCorner = .BottomRight,
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
    static func jq_createClarityImg(rect:CGRect,alpha:CGFloat = 0)->UIImage{
        let color = UIColor.clear
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.withAlphaComponent(alpha).cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image ?? UIImage()
    }
    
    /// 创建带有颜色的图片
    static func jq_createColorImg(rect:CGRect,color:UIColor,alpha:CGFloat = 0)->UIImage{
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
    func jq_imageWithTintColor(color : UIColor) -> UIImage{
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
    func jq_imageWithTintColor(color: UIColor, blendMode: CGBlendMode) -> UIImage?{
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
    func jq_imageWithNewSize(size: CGSize) -> UIImage? {
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
    
    /**
     根据坐标获取图片中的像素颜色值
     */
    subscript (x: Int, y: Int) -> UIColor? {
        
        if x < 0 || x > Int(size.width) || y < 0 || y > Int(size.height) {
            return nil
        }
        
        let provider = self.cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)
        
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * y) + x) * numberOfComponents
        
        let r = CGFloat(data![pixelData]) / 255.0
        let g = CGFloat(data![pixelData + 1]) / 255.0
        let b = CGFloat(data![pixelData + 2]) / 255.0
        let a = CGFloat(data![pixelData + 3]) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
