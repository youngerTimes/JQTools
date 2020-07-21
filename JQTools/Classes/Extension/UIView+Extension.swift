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
    
    /// centerY
    public var centerY: CGFloat {
        get {return center.y}
        set {center.y = newValue}
    }
    
    /// size
    public var size: CGSize {
        get {return frame.size}
        set {frame.size = newValue}
    }
    
    public var right: CGFloat {
        get {return frame.maxX}
    }
    
    public var bottom: CGFloat {
        get {return frame.maxY}
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
    
    ///读取本地json文件
    public func jq_readFilesOfJsonfiles(name:String,type:String) -> NSArray{
        let path = Bundle.main.path(forResource: name, ofType: type)
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! NSArray
            
            for dict in jsonArr {
                print(dict)
            }
            return jsonArr
        } catch let error as Error {
            print("读取本地数据出现错误!%@",error)
            return []
        }
    }
    
    public func jq_backgroundColorClear(){
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
    }
    
    /// 圆角加阴影
    func jq_addShadows(shadowColor: UIColor, corner: CGFloat,radius:CGFloat,offset:CGSize, opacity: Double) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.cornerRadius = corner
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    /// 添加阴影（父视图）
    public static func jq_addRoundedOrShadow(frame: CGRect,radius:CGFloat, shadowOpacity:CGFloat, shadowColor:UIColor) -> CALayer {
        let subLayer = CALayer()
        let fixframe = frame
        let newFrame = CGRect(x: 0, y: fixframe.minY, width: fixframe.width, height: fixframe.height) // 修正偏差
        subLayer.frame = newFrame
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = CGSize(width: 0, height: 4) // 阴影偏移,width:向右偏移3，height:向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = Float(shadowOpacity) //阴影透明度
        subLayer.shadowRadius = 5;//阴影半径，默认3
        return subLayer
    }
    
    /// 添加阴影（父视图）
    public static func jq_addRoundedOrShadows(frame: CGRect,radius:CGFloat, shadowOpacity:CGFloat, shadowColor:UIColor) -> CALayer {
        let subLayer = CALayer()
        let fixframe = frame
        let newFrame = CGRect(x: fixframe.minX-(375-UIScreen.main.bounds.size.width)/2, y: fixframe.minY, width: fixframe.width, height: fixframe.height) // 修正偏差
        subLayer.frame = newFrame
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = CGSize(width: 0, height: 0) // 阴影偏移,width:向右偏移3，height:向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = Float(shadowOpacity) //阴影透明度
        subLayer.shadowRadius = 5;//阴影半径，默认3
        return subLayer
    }
    
    /// 进度圆环
    /// - Parameters:
    ///   - circleWeight: 圆环宽度
    ///   - circleColor: 圆环颜色
    ///   - barBgColor: 圆环底色
    ///   - percent: 进度值 0 ~ 1.0
    ///   - duration: 动画执行，为0 则没有动画
    public func jq_addCircle(circleWeight: CGFloat, circleColor: UIColor,barBgColor:UIColor, percent:CGFloat,duration:CGFloat = 0){
        let X = self.bounds.midX
        let Y = self.bounds.midY
        let startAngle = CGFloat(-Double.pi/2)
        let endAngle = CGFloat(Double.pi*1.5)
        
        if percent > 1.0{
            fatalError("范围0～1.0")
        }
        
        
        let barBgPath = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius: jq_width/2,startAngle: startAngle, endAngle: endAngle,clockwise: true).cgPath
        
        self.addOval(lineWidth: circleWeight, path: barBgPath, strokeStart: 0, strokeEnd: 1,strokeColor: barBgColor, fillColor: UIColor.clear,shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSize.zero)
        
        // 进度条圆弧
        let barPath = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius:jq_width/2,startAngle: startAngle, endAngle: endAngle,clockwise: true).cgPath
        
        let layer = self.addOval(lineWidth: circleWeight, path: barPath, strokeStart: 0, strokeEnd: percent,strokeColor: circleColor, fillColor: UIColor.clear,shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSize.zero)
        if duration != 0 {
            addAnimation(layer, strokeStart: 0, strokeEnd: percent,duration: duration)
        }
    }
    
    //添加圆弧
    @discardableResult
    private func addOval(lineWidth: CGFloat, path: CGPath, strokeStart: CGFloat,strokeEnd: CGFloat, strokeColor: UIColor, fillColor: UIColor,shadowRadius: CGFloat, shadowOpacity: Float, shadowOffsset: CGSize)->CAShapeLayer {
        
        let arc = CAShapeLayer()
        arc.lineWidth = lineWidth
        arc.path = path
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = strokeColor.cgColor
        arc.fillColor = fillColor.cgColor
        arc.shadowColor = UIColor.black.cgColor
        arc.lineCap = CAShapeLayerLineCap(rawValue: "round")
        arc.shadowRadius = shadowRadius
        arc.shadowOpacity = shadowOpacity
        arc.shadowOffset = shadowOffsset
        layer.addSublayer(arc)
        return arc
    }
    
    private func addAnimation(_ layer:CAShapeLayer,strokeStart: CGFloat,strokeEnd: CGFloat,duration:CGFloat){
        let basic = CABasicAnimation(keyPath: "strokeEnd")
        basic.duration = CFTimeInterval(duration)
        basic.fromValue = strokeStart
        basic.toValue = strokeEnd
        layer.add(basic, forKey: "checkAnimation")
    }
}
