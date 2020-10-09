//
//  JQ_Matrix.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/9.
//

import Foundation

/// 二维数组模拟
public class JQ_Matrix<Element> {
    public let rows: Int
    public let columns: Int
    public var grid: [Element]

    /// 初始化二维数组
    public init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns

        if Element.Type.self == String.Type.self {
            grid = Array(repeating: "" as! Element, count: rows * columns)
        }else if Element.Type.self == Double.Type.self{
            grid = Array(repeating: 0.0 as! Element, count: rows * columns)
        }else if Element.Type.self == Int.Type.self{
            grid = Array(repeating: 0 as! Element, count: rows * columns)
        }else{
            grid = Array(repeating: 0 as! Element, count: rows * columns)
        }
    }

    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    public subscript(row: Int, column: Int) -> Element {
        get {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
