//
//  UiScrollView+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/9/7.
//

import Foundation
extension UIScrollView {
    
    /// 长截图
    /// - Parameter saveToAlbum: 保存至相册
    /// - Returns: 返回截图
    @discardableResult
    public func jq_captureAsLongImage(saveToAlbum:Bool = false) -> UIImage? {
        var image: UIImage? = nil
        let savedContentOffset = contentOffset
        let savedFrame = frame
        
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0,width: contentSize.width,height: contentSize.height)
        
        UIGraphicsBeginImageContext(frame.size)
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: frame.size.width,height: frame.size.height),false,UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print("contentSize == \(contentSize)")
        contentOffset = savedContentOffset
        frame = savedFrame
        
        if saveToAlbum && (image != nil) {
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
        return image
    }
}
