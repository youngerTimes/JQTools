//
//  UIImage+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//



import Foundation
import UIKit
import QuartzCore
import CoreGraphics
import Accelerate
import Photos

/// 水印位置枚举
public enum WaterMarkCorner{
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
}

public enum CodeDescriptor: String {
    case qrCpde = "CIQRCodeGenerator"
    //只能识别 ascii characters
    case code128Barcod = "CICode128BarcodeGenerator"
    //显示中文会乱码
    case pdf417 = "CIPDF417BarcodeGenerator"
    //显示中文会乱码
    case aztec = "CIAztecCodeGenerator"
}

enum CodeKey:String{
    ///设置内容
    case inputMessage = "inputMessage"
    ///设置容错级别
    case inputCorrectionLevel = "inputCorrectionLevel"
}

///  容错级别

/*

 qrCpde 和 pdf417

 inputCorrectionLevel 是一个单字母（@"L", @"M", @"Q", @"H" 中的一个），表示不同级别的容错率，默认为 @"M"

 QR码有容错能力，QR码图形如果有破损，仍然可以被机器读取内容，最高可以到7%~30%面积破损仍可被读取

 相对而言，容错率愈高，QR码图形面积愈大。所以一般折衷使用15%容错能力。错误修正容量 L水平 7%的字码可被修正

 M水平 15%的字码可被修正

 Q水平 25%的字码可被修正

 H水平 30%的字码可被修正

 code128Barcod 不能设置inputCorrectionLevel属性

 aztec inputCorrectionLevel 5 - 95

 */

public enum CorrectionLevel{
    case L
    case M
    case Q
    case H
    case aztecLevel(_ value:Int)
    var  levelValue:String{
        switch self {
            case .L:
                return "L"
            case .M:
                return "M"
            case .Q:
                return "Q"
            case .H:
                return "H"
            default:return  "" }
    }
}


/// 渐变方向
public enum GradientDirection {
    case horizontal // 水平从左到右
    case vertical // 垂直从上到下
    case leftOblique // 左上到右下
    case rightOblique // 右上到左下
    case other(CGPoint, CGPoint)

    public func point(size: CGSize) -> (CGPoint, CGPoint) {
        switch self {
            case .horizontal:
                return (CGPoint.init(x: 0, y: 0), CGPoint.init(x: size.width, y: 0))
            case .vertical:
                return (CGPoint.init(x: 0, y: 0), CGPoint.init(x: 0, y: size.height))
            case .leftOblique:
                return (CGPoint.init(x: 0, y: 0), CGPoint.init(x: size.width, y: size.height))
            case .rightOblique:
                return (CGPoint.init(x: size.width, y: 0), CGPoint.init(x: 0, y: size.height))
            case .other(let stat, let end):
                return (stat, end)
        }
    }
}

public extension UIImage{

    /// PHAsset转UIImage
    @objc static func JQ_PHAssetToImage(asset:PHAsset) -> UIImage{
        var image = UIImage()

        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()

        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()

        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true

        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none

        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat

        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: CGSize.init(width: 1080, height: 1920), contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }


    // MARK: -- Class func
    ///生成群聊图标
    static func JQ_GroupIcon(wh:CGFloat, images:[UIImage], bgColor:UIColor?) -> UIImage {
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

    /// 加载JQTools XXX.bundle中的数据
    /// - Parameters:
    ///   - name: 数据名称
    ///   - atResoure: 资源路径
    /// - Returns: 返回图片
    @available(*,deprecated,message: "废弃")
    static func JQ_Bundle(_ name:String, resoure atResoure:String = "Icon")->UIImage?{
        let a = Bundle(for: JQTool.self).path(forResource: atResoure, ofType: "bundle")
        let jqToolBundle = Bundle(path: a!)
        return UIImage(named: name, in: jqToolBundle, compatibleWith: .none)
    }
    
    //获取群聊图标中每个小图片的位置尺寸
    private static func getRectsInGroupIcon(wh:CGFloat, count:Int) -> [CGRect] {
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

    /// 生成对应的码图片
    /// - Parameters:
    ///   - string: 图片中的内容
    ///   - descriptor: 码的类型
    ///   - size: 图片的大小
    ///   - color: 图片的颜色
    ///   - level: 码的容错级别
    /// - Returns: 图片
    static func JQ_generate(string: String,descriptor: CodeDescriptor,size: CGSize,color:UIColor? = nil,level:CorrectionLevel = .M) -> UIImage? {
        guard let data = string.data(using: .utf8),let filter = CIFilter(name: descriptor.rawValue) else {
            return nil
        }

        filter.setValue(data, forKey: CodeKey.inputMessage.rawValue)
        if (descriptor == .qrCpde || descriptor == .pdf417){
            switch level {
                case .L,.M,.Q,.H:
                    filter.setValue(level.levelValue, forKey: CodeKey.inputCorrectionLevel.rawValue)
                default:break
            }
        }else if descriptor == .aztec{
            switch level {
                case .aztecLevel(var value):
                    if value < 5 {
                        value = 5
                    }else if value > 95{
                        value = 95
                    }
                    filter.setValue(NSNumber.init(value: value), forKey: CodeKey.inputCorrectionLevel.rawValue)
                default:break
            }
        }

        guard let image = filter.outputImage else {
            return nil
        }

        let imageSize = image.extent.size
        let transform = CGAffineTransform(scaleX: size.width / imageSize.width,y: size.height / imageSize.height)
        let scaledImage = image.transformed(by: transform)

        guard let codeColor = color else{
            return UIImage.init(ciImage: scaledImage)
        }

        // 设置颜色
        let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":scaledImage,"inputColor0":CIColor(cgColor: codeColor.cgColor ),"inputColor1":CIColor(cgColor: UIColor.clear.cgColor)])

        guard let newOutPutImage = colorFilter?.outputImage else {
            return UIImage.init(ciImage: scaledImage)
        }
        return UIImage.init(ciImage: newOutPutImage)
    }

    /// 根码上夹图片
    /// - Parameters:
    ///   - inputImage: 码图片
    ///   - fillImage: 中间的icon图片
    ///   - fillSize: icon的大小
    /// - Returns: 合成后的图片
    static func JQ_fillImage(_ inputImage:UIImage?,_ fillImage:UIImage?,_ fillSize:CGSize) -> UIImage? {
        guard let input = inputImage,let fill = fillImage  else {
            return inputImage
        }
        let imageSize = input.size
        UIGraphicsBeginImageContext(imageSize)
        input.draw(in: CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let fillWidth = min(imageSize.width, fillSize.width)
        let fillHeight = min(imageSize.height, fillSize.height)
        let fillRect = CGRect(x: (imageSize.width - fillWidth)/2, y: (imageSize.height - fillHeight)/2, width: fillWidth ,height: fillHeight)
        fill.draw(in: fillRect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return inputImage
        }
        UIGraphicsEndImageContext()
        return newImage
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


    /// 将图片转换为字符串
    /// - Returns: 字符串类型
    func jq_toString()->String{
        let imgData = self.pngData()
        return imgData?.base64EncodedString() ?? ""
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

    // MARK: 1.4、layer 转 image
    /// layer 转 image
    /// - Parameters:
    ///   - layer: layer 对象
    ///   - scale: 缩放比例
    /// - Returns: 返回转化后的 image
    static func jq_image(from layer: CALayer, scale: CGFloat = 0.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }

    // MARK: 1.5、设置图片透明度
    /// 设置图片透明度
    /// alpha: 透明度
    /// - Returns: newImage
    func jq_imageByApplayingAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.height)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(self.cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
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


    /// 等比缩放
    /// - Parameter scaleSize: 缩放率：0-∞
    /// - Returns: 返回图片
    func jq_scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * abs(scaleSize), height: self.size.height * abs(scaleSize))
        return jq_reSizeImage(reSize: reSize)
    }

    /// 根据图片大小进行重设图片
    /// - Parameter reSize: 图片大小
    /// - Returns: 返回图片
    private func jq_reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage;
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

    // MARK: 2.1、生成指定尺寸的纯色图像
    /// 生成指定尺寸的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    /// - Returns: 返回对应的图片
    static func jq_image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        return jq_image(color: color, size: size, corners: .allCorners, radius: 0)
    }

    // MARK: 2.2、生成指定尺寸和圆角的纯色图像
    /// 生成指定尺寸和圆角的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    ///   - corners: 剪切的方式
    ///   - round: 圆角大小
    /// - Returns: 返回对应的图片
    static func jq_image(color: UIColor, size: CGSize, corners: UIRectCorner, radius: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }

    // MARK: 2.3、生成渐变色的图片 ["#B0E0E6", "#00CED1", "#2E8B57"]
    /// 生成渐变色的图片 ["#B0E0E6", "#00CED1", "#2E8B57"]
    /// - Parameters:
    ///   - hexsString: 十六进制字符数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    static func jq_gradient(_ hexsString: [String], size: CGSize = CGSize(width: 1, height: 1), locations:[CGFloat]? = nil, direction: GradientDirection = .horizontal) -> UIImage? {
        return jq_gradient(hexsString.map{ UIColor(hexStr: $0) }, size: size, locations: locations, direction: direction)
    }

    // MARK: 2.4、生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// 生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    static func jq_gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations:[CGFloat]? = nil, direction: GradientDirection = .horizontal) -> UIImage? {
        return jq_gradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }

    // MARK: 2.5、生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// 生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - radius: 圆角
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 带圆角的渐变的图片
    static func jq_gradient(_ colors: [UIColor],
                         size: CGSize = CGSize(width: 10, height: 10),
                         radius: CGFloat,
                         locations:[CGFloat]? = nil,
                         direction: GradientDirection = .horizontal) -> UIImage? {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return UIImage.jq_image(color: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map{$0.cgColor} as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 创建条形码
    ///
    /// - Parameters:
    ///   - messgae: 信息
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: 条形码
    func jq_generateBarCode(messgae:NSString,width:CGFloat,height:CGFloat) -> UIImage {
        var returnImage:UIImage?
        if (messgae.length > 0 && width > 0 && height > 0){
            let inputData:NSData? = messgae.data(using: String.Encoding.utf8.rawValue)! as NSData
            // CICode128BarcodeGenerator
            let filter = CIFilter.init(name: "CICode128BarcodeGenerator")!
            filter.setValue(inputData, forKey: "inputMessage")
            var ciImage = filter.outputImage!
            let scaleX = width/ciImage.extent.size.width
            let scaleY = height/ciImage.extent.size.height
            ciImage = ciImage.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
            returnImage = UIImage.init(ciImage: ciImage)
        }else {
            returnImage = nil
        }
        return returnImage ?? UIImage()
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

    // MARK: 1.6、裁剪给定区域
    /// 裁剪给定区域
    /// - Parameter crop: 裁剪区域
    /// - Returns: 剪裁后的图片
    func jq_cropWithCropRect( _ crop: CGRect) -> UIImage? {
        let cropRect = CGRect(x: crop.origin.x * self.scale, y: crop.origin.y * self.scale, width: crop.size.width * self.scale, height: crop.size.height *  self.scale)
        if cropRect.size.width <= 0 || cropRect.size.height <= 0 {
            return nil
        }
        var image:UIImage?
        autoreleasepool{
            let imageRef: CGImage?  = self.cgImage!.cropping(to: cropRect)
            if let imageRef = imageRef {
                image = UIImage(cgImage: imageRef)
            }
        }
        return image
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


/////////////////////////////////////////////////////////////////////////////////////////////
//ImageHelper
public enum UIImageContentMode {
    case scaleToFill, scaleAspectFit, scaleAspectFill
}

public extension UIImage {

    /**
     A singleton shared NSURL cache used for images from URL
     */
    static var shared: NSCache<AnyObject, AnyObject>! {
        struct StaticSharedCache {
            static var shared: NSCache<AnyObject, AnyObject>? = NSCache()
        }

        return StaticSharedCache.shared!
    }

    // MARK: Image from solid color
    /**
     Creates a new solid color image.

     - Parameter color: The color to fill the image with.
     - Parameter size: Image size (defaults: 10x10)

     - Returns A new image
     */
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

    // MARK: Image from gradient colors
    /**
     Creates a gradient color image.

     - Parameter gradientColors: An array of colors to use for the gradient.
     - Parameter size: Image size (defaults: 10x10)

     - Returns A new image
     */
    convenience init?(gradientColors:[UIColor], size:CGSize = CGSize(width: 10, height: 10), locations: [Float] = [] )
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject? in return color.cgColor as AnyObject? } as NSArray
        let gradient: CGGradient
        if locations.count > 0 {
            let cgLocations = locations.map { CGFloat($0) }
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: cgLocations)!
        } else {
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        }
        context!.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

    /**
     Applies gradient color overlay to an image.

     - Parameter gradientColors: An array of colors to use for the gradient.
     - Parameter locations: An array of locations to use for the gradient.
     - Parameter blendMode: The blending type to use.

     - Returns A new image
     */
    func apply(gradientColors: [UIColor], locations: [Float] = [], blendMode: CGBlendMode = CGBlendMode.normal) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(blendMode)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        context?.draw(self.cgImage!, in: rect)
        // Create gradient
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject? in return color.cgColor as AnyObject? } as NSArray
        let gradient: CGGradient
        if locations.count > 0 {
            let cgLocations = locations.map { CGFloat($0) }
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: cgLocations)!
        } else {
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        }
        // Apply gradient
        context?.clip(to: rect, mask: self.cgImage!)
        context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!;
    }

    // MARK: Image with Text
    /**
     Creates a text label image.

     - Parameter text: The text to use in the label.
     - Parameter font: The font (default: System font of size 18)
     - Parameter color: The text color (default: White)
     - Parameter backgroundColor: The background color (default:Gray).
     - Parameter size: Image size (default: 10x10)
     - Parameter offset: Center offset (default: 0x0)

     - Returns A new image
     */
    convenience init?(text: String, font: UIFont = UIFont.systemFont(ofSize: 18), color: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.gray, size: CGSize = CGSize(width: 100, height: 100), offset: CGPoint = CGPoint(x: 0, y: 0)) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.font = font
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.backgroundColor = backgroundColor

        let image = UIImage(fromView: label)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

    // MARK: Image from UIView
    /**
     Creates an image from a UIView.

     - Parameter fromView: The source view.

     - Returns A new image
     */
    convenience init?(fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        //view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

    // MARK: Image with Radial Gradient
    // Radial background originally from: http://developer.apple.com/library/ios/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadings/dq_shadings.html
    /**
     Creates a radial gradient.

     - Parameter startColor: The start color
     - Parameter endColor: The end color
     - Parameter radialGradientCenter: The gradient center (default:0.5,0.5).
     - Parameter radius: Radius size (default: 0.5)
     - Parameter size: Image size (default: 100x100)

     - Returns A new image
     */
    convenience init?(startColor: UIColor, endColor: UIColor, radialGradientCenter: CGPoint = CGPoint(x: 0.5, y: 0.5), radius: Float = 0.5, size: CGSize = CGSize(width: 100, height: 100)) {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)

        let num_locations: Int = 2
        let locations: [CGFloat] = [0.0, 1.0] as [CGFloat]

        let startComponents = startColor.cgColor.components!
        let endComponents = endColor.cgColor.components!

        let components: [CGFloat] = [startComponents[0], startComponents[1], startComponents[2], startComponents[3], endComponents[0], endComponents[1], endComponents[2], endComponents[3]]

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: num_locations)

        // Normalize the 0-1 ranged inputs to the width of the image
        let aCenter = CGPoint(x: radialGradientCenter.x * size.width, y: radialGradientCenter.y * size.height)
        let aRadius = CGFloat(min(size.width, size.height)) * CGFloat(radius)

        // Draw it
        UIGraphicsGetCurrentContext()?.drawRadialGradient(gradient!, startCenter: aCenter, startRadius: 0, endCenter: aCenter, endRadius: aRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)

        // Clean up
        UIGraphicsEndImageContext()
    }

    // MARK: Alpha
    /**
     Returns true if the image has an alpha layer.
     */
    var hasAlpha: Bool {
        let alpha: CGImageAlphaInfo = self.cgImage!.alphaInfo
        switch alpha {
            case .first, .last, .premultipliedFirst, .premultipliedLast:
                return true
            default:
                return false
        }
    }

    /**
     Returns a copy of the given image, adding an alpha channel if it doesn't already have one.
     */
    func applyAlpha() -> UIImage? {
        if hasAlpha {
            return self
        }

        let imageRef = self.cgImage;
        let width = imageRef?.width;
        let height = imageRef?.height;
        let colorSpace = imageRef?.colorSpace

        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let offscreenContext = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)

        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        let rect: CGRect = CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!))
        offscreenContext?.draw(imageRef!, in: rect)
        let imageWithAlpha = UIImage(cgImage: (offscreenContext?.makeImage()!)!)
        return imageWithAlpha
    }

    /**
     Returns a copy of the image with a transparent border of the given size added around its edges. i.e. For rotating an image without getting jagged edges.

     - Parameter padding: The padding amount.

     - Returns A new image.
     */
    func apply(padding: CGFloat) -> UIImage? {
        // If the image does not have an alpha layer, add one
        let image = self.applyAlpha()
        if image == nil {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width + padding * 2, height: size.height + padding * 2)

        // Build a context that's the same dimensions as the new size
        let colorSpace = self.cgImage?.colorSpace
        let bitmapInfo = self.cgImage?.bitmapInfo
        let bitsPerComponent = self.cgImage?.bitsPerComponent
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: bitsPerComponent!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)

        // Draw the image in the center of the context, leaving a gap around the edges
        let imageLocation = CGRect(x: padding, y: padding, width: image!.size.width, height: image!.size.height)
        context?.draw(self.cgImage!, in: imageLocation)

        // Create a mask to make the border transparent, and combine it with the image
        let transparentImage = UIImage(cgImage: (context?.makeImage()?.masking(imageRef(withPadding: padding, size: rect.size))!)!)
        return transparentImage
    }

    /**
     Creates a mask that makes the outer edges transparent and everything else opaque. The size must include the entire mask (opaque part + transparent border).

     - Parameter padding: The padding amount.
     - Parameter size: The size of the image.

     - Returns A Core Graphics Image Ref
     */
    fileprivate func imageRef(withPadding padding: CGFloat, size: CGSize) -> CGImage {
        // Build a context that's the same dimensions as the new size
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        // Start with a mask that's entirely transparent
        context?.setFillColor(UIColor.black.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))

        // Make the inner part (within the border) opaque
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect(x: padding, y: padding, width: size.width - padding * 2, height: size.height - padding * 2))

        // Get an image of the context
        let maskImageRef = context?.makeImage()
        return maskImageRef!
    }


    // MARK: Crop

    /**
     Creates a cropped copy of an image.

     - Parameter bounds: The bounds of the rectangle inside the image.

     - Returns A new image
     */
    func crop(bounds: CGRect) -> UIImage? {
        return UIImage(cgImage: (self.cgImage?.cropping(to: bounds)!)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }

    func cropToSquare() -> UIImage? {
        let size = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let shortest = min(size.width, size.height)

        let left: CGFloat = (size.width > shortest) ? (size.width - shortest) / 2 : 0
        let top: CGFloat = (size.height > shortest) ? (size.height - shortest) / 2 : 0

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let insetRect = rect.insetBy(dx: left, dy: top)

        return crop(bounds: insetRect)
    }

    // MARK: Resize

    /**
     Creates a resized copy of an image.

     - Parameter size: The new size of the image.
     - Parameter contentMode: The way to handle the content in the new size.

     - Returns A new image
     */
    func resize(toSize: CGSize, contentMode: UIImageContentMode = .scaleToFill) -> UIImage? {
        let horizontalRatio = size.width / self.size.width;
        let verticalRatio = size.height / self.size.height;
        var ratio: CGFloat!

        switch contentMode {
            case .scaleToFill:
                ratio = 1
            case .scaleAspectFill:
                ratio = max(horizontalRatio, verticalRatio)
            case .scaleAspectFit:
                ratio = min(horizontalRatio, verticalRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)

        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        let transform = CGAffineTransform.identity

        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform);

        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality(rawValue: 3)!

        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))

        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: rect)

        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }


    // MARK: Corner Radius

    /**
     Creates a new image with rounded corners.

     - Parameter cornerRadius: The corner radius.

     - Returns A new image
     */
    func roundCorners(cornerRadius: CGFloat) -> UIImage? {
        // If the image does not have an alpha layer, add one
        let imageWithAlpha = applyAlpha()
        if imageWithAlpha == nil {
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width = imageWithAlpha?.cgImage?.width
        let height = imageWithAlpha?.cgImage?.height
        let bits = imageWithAlpha?.cgImage?.bitsPerComponent
        let colorSpace = imageWithAlpha?.cgImage?.colorSpace
        let bitmapInfo = imageWithAlpha?.cgImage?.bitmapInfo
        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bits!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        let rect = CGRect(x: 0, y: 0, width: CGFloat(width!)*scale, height: CGFloat(height!)*scale)

        context?.beginPath()
        if (cornerRadius == 0) {
            context?.addRect(rect)
        } else {
            context?.saveGState()
            context?.translateBy(x: rect.minX, y: rect.minY)
            context?.scaleBy(x: cornerRadius, y: cornerRadius)
            let fw = rect.size.width / cornerRadius
            let fh = rect.size.height / cornerRadius
            context?.move(to: CGPoint(x: fw, y: fh/2))
            context?.addArc(tangent1End: CGPoint(x: fw, y: fh), tangent2End: CGPoint(x: fw/2, y: fh), radius: 1)
            context?.addArc(tangent1End: CGPoint(x: 0, y: fh), tangent2End: CGPoint(x: 0, y: fh/2), radius: 1)
            context?.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: fw/2, y: 0), radius: 1)
            context?.addArc(tangent1End: CGPoint(x: fw, y: 0), tangent2End: CGPoint(x: fw, y: fh/2), radius: 1)
            context?.restoreGState()
        }
        context?.closePath()
        context?.clip()

        context?.draw(imageWithAlpha!.cgImage!, in: rect)
        let image = UIImage(cgImage: (context?.makeImage()!)!, scale:scale, orientation: .up)
        UIGraphicsEndImageContext()
        return image
    }

    /**
     Creates a new image with rounded corners and border.

     - Parameter cornerRadius: The corner radius.
     - Parameter border: The size of the border.
     - Parameter color: The color of the border.

     - Returns A new image
     */
    func roundCorners(cornerRadius: CGFloat, border: CGFloat, color: UIColor) -> UIImage? {
        return roundCorners(cornerRadius: cornerRadius)?.apply(border: border, color: color)
    }

    /**
     Creates a new circle image.

     - Returns A new image
     */
    func roundCornersToCircle() -> UIImage? {
        let shortest = min(size.width, size.height)
        return cropToSquare()?.roundCorners(cornerRadius: shortest/2)
    }

    /**
     Creates a new circle image with a border.

     - Parameter border :CGFloat The size of the border.
     - Parameter color :UIColor The color of the border.

     - Returns UIImage?
     */
    func roundCornersToCircle(withBorder border: CGFloat, color: UIColor) -> UIImage? {
        let shortest = min(size.width, size.height)
        return cropToSquare()?.roundCorners(cornerRadius: shortest/2, border: border, color: color)
    }

    // MARK: Border

    /**
     Creates a new image with a border.

     - Parameter border: The size of the border.
     - Parameter color: The color of the border.

     - Returns A new image
     */
    func apply(border: CGFloat, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width = self.cgImage?.width
        let height = self.cgImage?.height
        let bits = self.cgImage?.bitsPerComponent
        let colorSpace = self.cgImage?.colorSpace
        let bitmapInfo = self.cgImage?.bitmapInfo
        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bits!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
        context?.setLineWidth(border)

        let rect = CGRect(x: 0, y: 0, width: size.width*scale, height: size.height*scale)
        let inset = rect.insetBy(dx: border*scale, dy: border*scale)

        context?.strokeEllipse(in: inset)
        context?.draw(self.cgImage!, in: inset)

        let image = UIImage(cgImage: (context?.makeImage()!)!)
        UIGraphicsEndImageContext()

        return image
    }

    // MARK: Image Effects

    /**
     Applies a light blur effect to the image

     - Returns New image or nil
     */
    func applyLightEffect() -> UIImage? {
        return applyBlur(withRadius: 30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
    }

    /**
     Applies a extra light blur effect to the image

     - Returns New image or nil
     */
    func applyExtraLightEffect() -> UIImage? {
        return applyBlur(withRadius: 20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
    }

    /**
     Applies a dark blur effect to the image

     - Returns New image or nil
     */
    func applyDarkEffect() -> UIImage? {
        return applyBlur(withRadius: 20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
    }

    /**
     Applies a color tint to an image

     - Parameter color: The tint color

     - Returns New image or nil
     */
    func applyTintEffect(tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = tintColor.cgColor.numberOfComponents
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0

            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        return applyBlur(withRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0)
    }

    /**
     Applies a blur to an image based on the specified radius, tint color saturation and mask image

     - Parameter blurRadius: The radius of the blur.
     - Parameter tintColor: The optional tint color.
     - Parameter saturationDeltaFactor: The detla for saturation.
     - Parameter maskImage: The optional image for masking.

     - Returns New image or nil
     */
    func applyBlur(withRadius blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        guard size.width > 0 && size.height > 0 && cgImage != nil else {
            return nil
        }
        if maskImage != nil {
            guard maskImage?.cgImage != nil else {
                return nil
            }
        }
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        let hasBlur = blurRadius > CGFloat(Float.ulpOfOne)
        let hasSaturationChange = abs(saturationDeltaFactor - 1.0) > CGFloat(Float.ulpOfOne)
        if (hasBlur || hasSaturationChange) {

            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let effectInContext = UIGraphicsGetCurrentContext()
            effectInContext?.scaleBy(x: 1.0, y: -1.0)
            effectInContext?.translateBy(x: 0, y: -size.height)
            effectInContext?.draw(cgImage!, in: imageRect)

            var effectInBuffer = vImage_Buffer(
                data: effectInContext?.data,
                height: UInt((effectInContext?.height)!),
                width: UInt((effectInContext?.width)!),
                rowBytes: (effectInContext?.bytesPerRow)!)

            UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
            let effectOutContext = UIGraphicsGetCurrentContext()

            var effectOutBuffer = vImage_Buffer(
                data: effectOutContext?.data,
                height: UInt((effectOutContext?.height)!),
                width: UInt((effectOutContext?.width)!),
                rowBytes: (effectOutContext?.bytesPerRow)!)

            if hasBlur {
                let inputRadius = blurRadius * UIScreen.main.scale
                let sqrtPi: CGFloat = CGFloat(sqrt(.pi * 2.0))
                var radius = UInt32(floor(inputRadius * 3.0 * sqrtPi / 4.0 + 0.5))
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }

            var effectImageBuffersAreSwapped = false

            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]

                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)

                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }

                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }

            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }

            UIGraphicsEndImageContext()

            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }

            UIGraphicsEndImageContext()
        }

        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext?.scaleBy(x: 1.0, y: -1.0)
        outputContext?.translateBy(x: 0, y: -size.height)

        // Draw base image.
        outputContext?.draw(self.cgImage!, in: imageRect)

        // Draw effect image.
        if hasBlur {
            outputContext?.saveGState()
            if let image = maskImage {
                outputContext?.clip(to: imageRect, mask: image.cgImage!);
            }
            outputContext?.draw(effectImage.cgImage!, in: imageRect)
            outputContext?.restoreGState()
        }

        // Add in color tint.
        if let color = tintColor {
            outputContext?.saveGState()
            outputContext?.setFillColor(color.cgColor)
            outputContext?.fill(imageRect)
            outputContext?.restoreGState()
        }

        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return outputImage

    }


    // MARK: Image From URL

    /**
     Creates a new image from a URL with optional caching. If cached, the cached image is returned. Otherwise, a place holder is used until the image from web is returned by the closure.

     - Parameter url: The image URL.
     - Parameter placeholder: The placeholder image.
     - Parameter shouldCacheImage: Weather or not we should cache the NSURL response (default: true)
     - Parameter closure: Returns the image from the web the first time is fetched.

     - Returns A new image
     */
    class func image(fromURL url: String, placeholder: UIImage, shouldCacheImage: Bool = true, closure: @escaping (_ image: UIImage?) -> ()) -> UIImage? {
        // From Cache
        if shouldCacheImage {
            if let image = UIImage.shared.object(forKey: url as AnyObject) as? UIImage {
                closure(nil)
                return image
            }
        }
        // Fetch Image
        let session = URLSession(configuration: URLSessionConfiguration.default)
        if let nsURL = URL(string: url) {
            session.dataTask(with: nsURL, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    DispatchQueue.main.async {
                        closure(nil)
                    }
                }
                if let data = data, let image = UIImage(data: data) {
                    if shouldCacheImage {
                        UIImage.shared.setObject(image, forKey: url as AnyObject)
                    }
                    DispatchQueue.main.async {
                        closure(image)
                    }
                }
                session.finishTasksAndInvalidate()
            }).resume()
        }
        return placeholder
    }
}

// MARK:- 三、图片的拉伸和缩放
public extension UIImage {

    // MARK: 3.1、获取固定大小的 image
    /// 获取固定大小的image
    /// - Parameter size: 图片尺寸
    /// - Returns: 固定大小的 image
    func solidTo(size: CGSize) -> UIImage? {
        let w = size.width
        let h = size.height
        if self.size.height <= self.size.width {
            if self.size.width >= w {
                let scaleImage = fixOrientation().scaleTo(size: CGSize(width: w, height: w * self.size.height / self.size.width))
                return scaleImage
            } else {
                return fixOrientation()
            }
        } else {
            if self.size.height >= h {
                let scaleImage = fixOrientation().scaleTo(size: CGSize(width: h * self.size.width / self.size.height, height: h))
                return scaleImage
            } else {
                return fixOrientation()
            }
        }
    }

    // MARK: 3.2、按宽高比系数：等比缩放
    /// 按宽高比系数：等比缩放
    /// - Parameter scale: 要缩放的 宽高比 系数
    /// - Returns: 等比缩放 后的图片
    func scaleTo(scale: CGFloat) -> UIImage? {
        let w = self.size.width
        let h = self.size.height
        let scaledW = w * scale
        let scaledH = h * scale
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: scaledW, height: scaledH))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage;
    }

    // MARK: 3.3、按指定尺寸等比缩放
    /// 按指定尺寸等比缩放
    /// - Parameter size: 要缩放的尺寸
    /// - Returns: 缩放后的图片
    func scaleTo(size: CGSize) -> UIImage? {
        if self.cgImage == nil { return nil }
        var w = CGFloat(self.cgImage!.width)
        var h = CGFloat(self.cgImage!.height)
        let verticalRadio = size.height / h
        let horizontalRadio = size.width / w
        var radio: CGFloat = 1
        if verticalRadio > 1 && horizontalRadio > 1 {
            radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio
        } else {
            radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio
        }
        w = w * radio;
        h = h * radio;
        let xPos = (size.width - w) / 2;
        let yPos = (size.height - h) / 2;
        UIGraphicsBeginImageContext(size);
        draw(in: CGRect(x: xPos, y: yPos, width: w, height: h))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }

    // MARK: 3.4、图片中间 1*1 拉伸——如气泡一般
    /// 图片中间1*1拉伸——如气泡一般
    /// - Returns: 拉伸后的图片
    func strechAsBubble() -> UIImage {
        let top = self.size.height * 0.5;
        let left = self.size.width * 0.5;
        let bottom = self.size.height * 0.5;
        let right = self.size.width * 0.5;
        let edgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right);
        // 拉伸
        return self.resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
    }

    // MARK: 3.5、调整图像方向 避免图像有旋转
    /// 调整图像方向 避免图像有旋转
    /// - Returns: 返正常的图片
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi / 2)
        default:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: (self.cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (self.cgImage?.colorSpace)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        let cgImage: CGImage = ctx.makeImage()!
        return UIImage(cgImage: cgImage)
    }
}

// MARK:- 四、UIImage 压缩相关
public extension UIImage {

    // MARK: 4.1、压缩图片
    /// 压缩图片
    /// - Parameter mode: 压缩模式
    /// - Returns: 压缩后Data
    func compress(mode: CompressionMode = .medium) -> Data? {
        return resizeIO(resizeSize: mode.resize(size))?.compressDataSize(maxSize: mode.maxDataSize)
    }

    // MARK: 4.2、异步图片压缩
    /// 异步图片压缩
    /// - Parameters:
    ///   - mode: 压缩模式
    ///   - queue: 压缩队列
    ///   - complete: 完成回调(压缩后Data, 调整后分辨率)
    func asyncCompress(mode: CompressionMode = .medium, queue: DispatchQueue = DispatchQueue.global(), complete:@escaping (Data?, CGSize) -> Void) {
        queue.async {
            let data = self.resizeIO(resizeSize: mode.resize(self.size))?.compressDataSize(maxSize: mode.maxDataSize)
            DispatchQueue.main.async {
                complete(data, mode.resize(self.size))
            }
       }
    }

    // MARK: 4.3、压缩图片质量
    /// 压缩图片质量
    /// - Parameter maxSize: 最大数据大小
    /// - Returns: 压缩后数据
    func compressDataSize(maxSize: Int = 1024 * 1024 * 2) -> Data? {
        let maxSize = maxSize
        var quality: CGFloat = 0.8
        var data = self.jpegData(compressionQuality: quality)
        var dataCount = data?.count ?? 0

        while (data?.count ?? 0) > maxSize {
            if quality <= 0.6 {
                break
            }
            quality  = quality - 0.05
            data = self.jpegData(compressionQuality: quality)
            if (data?.count ?? 0) <= dataCount {
                break
            }
            dataCount = data?.count ?? 0
        }
        return data
    }

    // MARK: 4.4、ImageIO 方式调整图片大小 性能很好
    /// ImageIO 方式调整图片大小 性能很好
    /// - Parameter resizeSize: 图片调整Size
    /// - Returns: 调整后图片
    func resizeIO(resizeSize: CGSize) -> UIImage? {
        if size == resizeSize {
            return self
        }
        guard let imageData = pngData() else { return nil }
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }

        let maxPixelSize = max(size.width, size.height)
        let options = [kCGImageSourceCreateThumbnailWithTransform: true,
                   kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                   kCGImageSourceThumbnailMaxPixelSize: maxPixelSize]  as CFDictionary

        let resizedImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap{
            UIImage(cgImage: $0)
        }

        return resizedImage
    }

    // MARK: 4.5、CoreGraphics 方式调整图片大小 性能很好
    /// CoreGraphics 方式调整图片大小 性能很好
    /// - Parameter resizeSize: 图片调整Size
    /// - Returns: 调整后图片
    func resizeCG(resizeSize: CGSize) -> UIImage? {
        if size == resizeSize {
            return self
        }
        guard  let cgImage = self.cgImage else { return nil }
        guard  let colorSpace = cgImage.colorSpace else { return nil }
        guard let context = CGContext(data: nil,
                                  width: Int(resizeSize.width),
                                  height: Int(resizeSize.height),
                                  bitsPerComponent: cgImage.bitsPerComponent,
                                  bytesPerRow: cgImage.bytesPerRow,
                                  space: colorSpace,
                                  bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }
        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(origin: .zero, size: resizeSize))
        let resizedImage = context.makeImage().flatMap {
            UIImage(cgImage: $0)
        }
        return resizedImage
    }
}

// MARK: 压缩模式
public enum CompressionMode {
    /// 分辨率规则
    private static let resolutionRule: (min: CGFloat, max: CGFloat, low: CGFloat, default: CGFloat, high: CGFloat) = (10, 4096, 512, 1024, 2048)
    /// 数据大小规则
    private static let  dataSizeRule: (min: Int, max: Int, low: Int, default: Int, high: Int) = (1024 * 10, 1024 * 1024 * 20, 1024 * 512, 1024 * 1024 * 2, 1024 * 1024 * 10)
    // 低质量
    case low
    // 中等质量 默认
    case medium
    // 高质量
    case high
    // 自定义(最大分辨率, 最大输出数据大小)
    case other(CGFloat, Int)

    fileprivate var maxDataSize: Int {
        switch self {
        case .low:
            return CompressionMode.dataSizeRule.low
        case .medium:
            return CompressionMode.dataSizeRule.default
        case .high:
            return CompressionMode.dataSizeRule.high
        case .other(_, let dataSize):
            if dataSize < CompressionMode.dataSizeRule.min {
                return CompressionMode.dataSizeRule.default
            }
            if dataSize > CompressionMode.dataSizeRule.max {
                return CompressionMode.dataSizeRule.max
            }
            return dataSize
        }
    }

    fileprivate func resize(_ size: CGSize) -> CGSize {
        if size.width < CompressionMode.resolutionRule.min || size.height < CompressionMode.resolutionRule.min {
            return size
        }
        let maxResolution = maxSize
        let aspectRatio = max(size.width, size.height) / maxResolution
        if aspectRatio <= 1.0 {
            return size
        } else {
            let resizeWidth = size.width / aspectRatio
            let resizeHeighth = size.height / aspectRatio
            if resizeHeighth < CompressionMode.resolutionRule.min || resizeWidth < CompressionMode.resolutionRule.min {
                return size
            } else {
                return CGSize.init(width: resizeWidth, height: resizeHeighth)
            }
        }
    }

    fileprivate var maxSize: CGFloat {
        switch self {
        case .low:
            return CompressionMode.resolutionRule.low
        case .medium:
            return CompressionMode.resolutionRule.default
        case .high:
            return CompressionMode.resolutionRule.high
        case .other(let size, _):
            if size < CompressionMode.resolutionRule.min {
                return CompressionMode.resolutionRule.default
            }
            if size > CompressionMode.resolutionRule.max {
                return CompressionMode.resolutionRule.max
            }
            return size
        }
    }
}
