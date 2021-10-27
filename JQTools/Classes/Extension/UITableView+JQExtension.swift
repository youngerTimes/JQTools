//
//  UITableView+JQExtension.swift
//  JQTools
//
//  Created by 无故事王国 on 2021/2/8.
//

import Foundation

public extension UITableView {
    func jq_register(cellName: String, identifier: String? = nil){
        if identifier == nil{
            register(NIB(name: cellName), forCellReuseIdentifier: "_\(cellName)")
        }else{
            register(NIB(name: cellName), forCellReuseIdentifier: identifier!)
        }
    }

    func jq_register(viewName: String, identifier: String) {
        register(NIB(name: viewName), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func jq_register(headName: String, identifier: String) {
        register(NIB(name: headName), forHeaderFooterViewReuseIdentifier: identifier)
    }

    private func NIB(name: String) -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
}

public extension UITableView{
    /// 添加动画
    /// - Parameter type: 动画类型
    func jq_addAni(type:JQ_TableAniType){
        DispatchQueue.main.async {
            self.reloadData()
            let cells = self.visibleCells
            var i = 0
            for cell in cells {
                if type == .moveFromLeft{
                    JQ_AnisTools.MoveAnimation(cell, Double(JQ_ScreenW),i)
                }else if type == .moveFromRight{
                    JQ_AnisTools.MoveAnimation(cell, Double(-JQ_ScreenW),i)
                }else if type == .fadeDut{
                    cell.alpha = 0
                    JQ_AnisTools.FadeDutAnimation(cell, i)
                }else if type == .fadeDut_move{
                    cell.alpha = 0
                    JQ_AnisTools.FadeDutAnimationMove(cell,Double(50),i)
                }else if type == .bounds{
                    cell.alpha = 0
                    JQ_AnisTools.BoundsAnimation(cell,Double(50),i)
                }else if type == .bothway{
                    cell.alpha = 0
                    JQ_AnisTools.BothwayAnimation(cell, Double(JQ_ScreenW), i)
                }else if type == .fillOne{
                    JQ_AnisTools.FillOneAnimation(cell,Double(50), i)
                }
                i+=1
            }
        }
    }
}
