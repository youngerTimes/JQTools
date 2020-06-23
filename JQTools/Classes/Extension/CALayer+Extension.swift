//
//  CALayer+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/6/23.
//

import Foundation
extension CALayer{
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
          get{return self.cornerRadius}
          set(value){self.cornerRadius = value}
      }
      
      public var jq_masksToBounds:Bool{
          get{return self.masksToBounds}
          set(value){self.masksToBounds = value}
      }
      
      public var jq_borderWidth:CGFloat{
          get{return self.borderWidth}
          set(value){self.borderWidth = value}
      }
      
      public var jq_borderCololr:CGColor?{
          get{return self.borderColor}
          set(value){self.borderColor = value}
      }
      
      /// size
      public var size: CGSize {
          get {return frame.size}
          set {frame.size = newValue}
      }
}
