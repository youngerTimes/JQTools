//
//  Stack.swift
//  YKTools
//
//  Created by 杨锴 on 2019/6/5.
//  Copyright © 2019 younger_times. All rights reserved.
//

/// 有固定长度的Array（堆处理）
protocol JQ_QueueProtocol:IteratorProtocol,Sequence{
    var items:Array<Element> {get}
    var length:Int {get}
    var overflow:Bool {get}
    mutating func pop()->Element?
    mutating func push(_ item:Element)->Bool
    mutating func pushAll(_ items:[Element])
    mutating func clear()
}

public struct JQ_Queue<T>:JQ_QueueProtocol{
    
    public typealias Element = T
    private(set) var items: Array<Element> = Array()
    private(set) var length = 0
    private(set) var overflow = true
    
    init(length:Int,overflow:Bool = true) {
        self.length = length
        self.overflow = overflow
    }
    
    mutating func pop() -> Element?{
        return items.removeFirst()
    }
    
    mutating func push(_ item: JQ_Queue<T>.Element) -> Bool {
        if self.items.count >= length{
            if !overflow {
                return false
            }
            self.items.removeFirst()
        }
        self.items.append(item)
        return true
    }
    
    mutating func pushAll(_ items: [Element]) {
        self.items.append(contentsOf: items[0...length])
    }
    
    mutating public func next() -> T? {
        return self.pop()
    }
    
    mutating func clear() {
        self.items.removeAll()
    }
    
    mutating func makeIterator() -> JQ_Queue<T> {
        return self.next() as! JQ_Queue<Element>
    }
}


public struct JQ_Stack<T>:JQ_QueueProtocol{
    
    public typealias Element = T
    
    private(set) var items:Array<Element> = Array()
    /// 允许溢出，溢出会删除最早的数据，如果不允许，当达到上限后不会添加任何数据
    private(set) var overflow = true
    private(set) var length:Int = 0
    init(length:Int,overflow:Bool = true) {
        self.length = length
        self.overflow = overflow
    }
    
    //移除
    mutating func pop() -> T?{
        guard !items.isEmpty else {
            return nil
        }
        return items.removeLast()
    }
    
    //新增一条数据
    @discardableResult
    mutating func push(_ item:Element)->Bool{
        if self.items.count > length{
            if !overflow {
                return false
            }
            self.items.removeFirst()
        }
        self.items.append(item)
        return true
    }
    
    mutating func pushAll(_ items:[Element]){
        self.items.append(contentsOf: items[0...length])
    }
    
    public mutating func next() -> JQ_Stack<T>.Element? {
        return self.pop()
    }
    
    mutating func clear(){
        self.items.removeAll()
    }
    
    mutating func makeIterator() -> JQ_Stack<Element> {
        return self.next() as! JQ_Stack<Element>
    }
    
}
