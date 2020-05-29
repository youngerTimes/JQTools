//
//  UIView+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

extension UIView{
    
    public var jq_identity:String{
        get{return "\(type(of: self))"}
    }
    
    public var jq_x:CGFloat{
        get{return self.frame.origin.x}
        set(value){self.frame.origin.x = value}
    }
    
    public var jq_y:CGFloat{
        get{return self.frame.origin.y}
        set(value){self.frame.origin.y = value}
    }
    
    public var jq_height:CGFloat{
        get{return self.frame.size.height}
        set(value){self.frame.size.height = value}
    }
    
    public var jq_width:CGFloat{
        get{return self.frame.size.width}
        set(value){self.frame.size.width = value}
    }
    
    public var jq_cornerRadius:CGFloat{
        get{return self.layer.cornerRadius}
        set(value){self.layer.cornerRadius = value}
    }
    
    public var jq_masksToBounds:Bool{
        get{return self.layer.masksToBounds}
        set(value){self.layer.masksToBounds = value}
    }
    
    public var jq_borderWidth:CGFloat{
        get{return self.layer.borderWidth}
        set(value){self.layer.borderWidth = value}
    }
    
    public var jq_borderCololr:CGColor?{
        get{return self.layer.borderColor}
        set(value){self.layer.borderColor = value}
    }
    
    
    ///切部分圆角(Frame) 注意不能用错，storyboard和nib 在高度动态变化时，容易出现BUG
    public func jq_cornerPart(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.masksToBounds = false
        self.layer.mask = maskLayer
    }
    ///切部分圆角(Xib)
    public func jq_cornerPartWithNib(byRoundingCorners corners: UIRectCorner, radii: CGFloat, size: CGSize) {
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    ///切圆角并且设置阴影
    public func jq_cornerWith(radii: CGFloat, isXib:Bool) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(hexStr: "E6E6E6").cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = radii
        self.layer.cornerRadius = radii
        self.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        self.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: isXib ?self.bounds.size.width : self.bounds.size.width, height: isXib ? self.bounds.size.height : self.bounds.size.height), cornerRadius: radii).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    /// 设置阴影
    public func jq_shadow(shadowColor: UIColor, corner: CGFloat, opacity: Double) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.borderColor = shadowColor.cgColor
        self.layer.borderWidth = 0.000001;
        self.layer.cornerRadius = corner
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowRadius = corner
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    //UIView->UIImage
    public func jq_convertViewToImage() -> UIImage {
        var imageRet = UIImage()
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        imageRet = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return imageRet
    }
    
    ///设置渐变色(Frame)
    public func jq_gradientColor(colorArr:[CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colorArr
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    ///设置渐变色(Nib)
    @discardableResult
    public func jq_gradientNibColor(colorArr:[CGColor]) -> CAGradientLayer? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width*JQ_RateW, height: self.frame.height*JQ_RateH)
        gradientLayer.colors = colorArr
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}
