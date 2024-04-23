//
//  UIColor+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

public extension UIColor{
				///ColorHex
				convenience init(hexStr:String,darkStr:String? = nil,autoDart:Bool = false) {

								var tempStr = hexStr

								if autoDart {
												if #available(iOS 13.0, *) {
																if UITraitCollection.current.userInterfaceStyle == .dark  {
																				tempStr = UIColor.darkenHexColorStr(hexStr)
																}
												}
								}

								if darkStr != nil {
												if #available(iOS 13.0, *) {
																if UITraitCollection.current.userInterfaceStyle == .dark  {
																				tempStr = darkStr!
																}
												}
								}

								var cString:String = tempStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
								if (cString.hasPrefix("#")) {
												cString.remove(at: cString.startIndex)
								}
								if ((cString.count) != 6) {
												self.init()
								} else {
												var rgbValue:UInt32 = 0
												Scanner(string: cString).scanHexInt32(&rgbValue)
												self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
																						green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
																						blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
																						alpha: 1)
								}
				}

    convenience init(lr:CGFloat,lg:CGFloat,lb:CGFloat,dr:CGFloat? = nil,dg:CGFloat? = nil, db:CGFloat? = nil,alpha:CGFloat = 1.0) {

        var r:CGFloat = lr
        var g:CGFloat = lg
        var b:CGFloat = lb

        if dr != nil && dg != nil && db != nil {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark  {
                    r = dr!
                    g = dg!
                    b = db!
                }
            }
        }

        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    ///使用rgb方式生成自定义颜色
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    ///使用rgba方式生成自定义颜色
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat) {
        
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
    
    ///返回随机颜色
    static var jq_randomColor:UIColor{
        get{
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    //获取反色
    func jq_invertColor() -> UIColor {
          var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0
          self.getRed(&r, green: &g, blue: &b, alpha: nil)
          return UIColor(red:1.0-r, green: 1.0-g, blue: 1.0-b, alpha: 1)
      }

				private static func darkenHexColorStr(_ hexStr: String) -> String {
								var cString: String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
								if (cString.hasPrefix("#")) {
												cString.remove(at: cString.startIndex)
								}
								if ((cString.count) != 6) {
												return hexStr
								} else {
												var rgbValue: UInt32 = 0
												Scanner(string: cString).scanHexInt32(&rgbValue)
												let r = max(CGFloat((rgbValue & 0xFF0000) >> 16) - 50.0, 0.0)
												let g = max(CGFloat((rgbValue & 0x00FF00) >> 8) - 50.0, 0.0)
												let b = max(CGFloat(rgbValue & 0x0000FF) - 50.0, 0.0)
												return String(format: "%02lX%02lX%02lX", Int(r), Int(g), Int(b))
								}
				}

}
