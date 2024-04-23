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

extension UIScrollView {
	/**
	 scrollview截长图
	 可以保留阴影
	 图片拼接
	 */

	public func snapShotOfFullContent(_ completion: ((_ image: UIImage?) -> Void)?) {
		let orginOffset = contentOffset,
			color = backgroundColor ?? .white,
			height = frame.height
		var pageNum = 1,
			imageView: UIImageView?
		if contentSize.height > height {
			/**
			 如果超过一屏需要对图片进行轮循截图
			 */
			pageNum = Int(floorf(Float(contentSize.height/height)))
			UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.main.scale)
			if let _ = UIGraphicsGetCurrentContext(), let superView = superview {
				superView.drawHierarchy(in: frame, afterScreenUpdates: false)
				if let image = UIGraphicsGetImageFromCurrentImageContext() {
					/**
					 获取快照
					 轮循截图时需要对滚动图进行滚动
					 这时通过对当前屏幕截图覆盖制造滚动图未改变的假象
					 */
					imageView = UIImageView(image: image)
					imageView?.backgroundColor = color
					imageView?.frame = frame
					if let view = imageView {
						superView.addSubview(view)
					}
				}
			}
			UIGraphicsEndImageContext()
		}
		UIGraphicsBeginImageContextWithOptions(contentSize, true, UIScreen.main.scale)
		if let block = completion, let context = UIGraphicsGetCurrentContext() {
			context.setFillColor(color.cgColor)
			context.setStrokeColor(color.cgColor)
			drawSnapShotOfPage(index: 0, maxIndex: pageNum) {
				/**
				 完成截图后移除滚动图上的快照
				 */
				if let _ = imageView?.superview {
					imageView?.removeFromSuperview()
					imageView = nil
				}
				let image = UIGraphicsGetImageFromCurrentImageContext()
				UIGraphicsEndImageContext()
				self.contentOffset = orginOffset
				block(image)
			}
		}
	}

	private func drawSnapShotOfPage( index: Int, maxIndex: Int, completion: (() -> Void)?) {
		/**
		 对指定位置截图
		 */
		let width = frame.width,
			height = frame.height
		setContentOffset(CGPoint(x: 0, y: CGFloat(index)*height), animated: false)
		let pageFrame = CGRect(x: 0, y: CGFloat(index)*height, width: width, height: height)
		if let block = completion {
			DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
				self.drawHierarchy(in: pageFrame, afterScreenUpdates: true)
				if index < maxIndex {
					self.drawSnapShotOfPage(index: index+1, maxIndex: maxIndex, completion: block)
				}else {
					block()
				}
			}
		}
	}

}


