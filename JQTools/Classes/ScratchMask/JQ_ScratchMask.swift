//
//  JQ_ScratchMask.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/11.
//

import UIKit

///刮刮卡涂层
public class JQ_ScratchMask: UIImageView {
     
    //代理对象
    weak var delegate: ScratchCardDelegate?
     
    //线条形状
    var lineType:CGLineCap!
    //线条粗细
    var lineWidth: CGFloat!
    //保存上一次停留的位置
    var lastPoint: CGPoint?
     
 
    override init(frame: CGRect) {
        super.init(frame: frame)
         
        //当前视图可交互
        isUserInteractionEnabled = true
    }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    //触摸开始
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //多点触摸只考虑第一点
        guard  let touch = touches.first else {
            return
        }
        //保存当前点坐标
        lastPoint = touch.location(in: self)
         
        //调用相应的代理方法
        delegate?.scratchBegan?(point: lastPoint!)
    }
     
    //滑动
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //多点触摸只考虑第一点
        guard  let touch = touches.first, let point = lastPoint, let img = image else {
            return
        }
         
        //获取最新触摸点坐标
        let newPoint = touch.location(in: self)
        //清除两点间的涂层
        eraseMask(fromPoint: point, toPoint: newPoint)
        //保存最新触摸点坐标，供下次使用
        lastPoint = newPoint
         
        //计算刮开面积的百分比
        let progress = getAlphaPixelPercent(img: img)
        //调用相应的代理方法
        delegate?.scratchMoved?(progress: progress)
    }
     
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //多点触摸只考虑第一点
        guard  touches.first != nil else {
            return
        }
         
        //调用相应的代理方法
        delegate?.scratchEnded?(point: lastPoint!)
    }
     
    //清除两点间的涂层
    func eraseMask(fromPoint: CGPoint, toPoint: CGPoint) {
        //根据size大小创建一个基于位图的图形上下文
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
         
        //先将图片绘制到上下文中
        image?.draw(in: self.bounds)
         
        //再绘制线条
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
         
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setLineCap(lineType)
        context.setLineWidth(lineWidth)
        context.setBlendMode(.clear) //混合模式设为清除
        context.addPath(path)
        context.strokePath()
         
        //将二者混合后的图片显示出来
        image = UIGraphicsGetImageFromCurrentImageContext()
        //结束图形上下文
        UIGraphicsEndImageContext()
    }
     
    //获取透明像素占总像素的百分比
    private func getAlphaPixelPercent(img: UIImage) -> Float {
        //计算像素总个数
        let width = Int(img.size.width)
        let height = Int(img.size.height)
        let bitmapByteCount = width * height
         
        //得到所有像素数据
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width,
                                space: colorSpace,
                                bitmapInfo: CGBitmapInfo(rawValue:
                                    CGImageAlphaInfo.alphaOnly.rawValue).rawValue)!
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.clear(rect)
        context.draw(img.cgImage!, in: rect)
         
        //计算透明像素个数
        var alphaPixelCount = 0
        for x in 0...Int(width) {
            for y in 0...Int(height) {
                if pixelData[y * width + x] == 0 {
                    alphaPixelCount += 1
                }
            }
        }
         
        free(pixelData)
         
        return Float(alphaPixelCount) / Float(bitmapByteCount)
    }
}
