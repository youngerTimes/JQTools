//
//  JQBaser.swift
//  JQTools
//
//  Created by 无故事王国 on 2022/5/6.
//

public struct JQBase<Base>{
    public let base:Base
    init(_ base:Base) {self.base = base}
}

public protocol JQCompatible:AnyObject{}

public protocol JQCompatibleValue{}

extension JQCompatible{
    public var jq:JQBase<Self>{
        get{
            return JQBase(self)
        }
        set{}
    }
}

extension JQCompatibleValue{
    public var jq:JQBase<Self>{
        get{
            return JQBase(self)
        }
        set{}
    }
}


