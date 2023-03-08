//
//  UIMenu+JQExtension.swift
//  JQTools
//
//  Created by 无故事王国 on 2022/12/27.
//

import Foundation

// UIAction: "_state"
public let kActionState = "_state"

@available(iOS 14.0, *)
public extension UIMenu{

    /// Data mapping UIMenu structure
    static func map(_ title: String = "", data: [(String, [(String, UIImage?)])], handler: @escaping UIActionHandler) -> UIMenu {
        return UIMenu(title: title, children: data.map {
            UIMenu(title: $0.0, options: .displayInline, children: $0.1.map({
                    return UIAction(title: $0.0, image: $0.1, handler: handler)
                })
            )
        })
    }
}

@available(iOS 14.0, *)
public extension UIAction{

    /// state change(.on/.off), Support single selection/multiple selection.
    func handleStateChange(_ sender: UIButton, section: Int, isSingleChoose: Bool, handler: (()->Void)?) {
        guard let menu = sender.menu?.children[section] as? UIMenu else { return }
        if isSingleChoose == false {
            if self.state == .off {
                self.setValue(1, forKey: kActionState)
            } else if self.state == .on {
                self.setValue( 0, forKey: kActionState)
            }
        } else {
            menu.children.forEach {
                $0.setValue($0 == self ? 1 : 0, forKey: kActionState)
            }
        }
        handler?()
    }
}


@available(iOS 14.0, *)
public extension UIButton {

    /// Actions (Support single selection/multiple selection)
    /// - Returns: row(state is on)
    func checkActions(by section: Int) -> [UIAction]?{
        guard let sectionMenu = menu?.children[section] as? UIMenu
              else { return nil }

        let firters = sectionMenu.children.filter {
            guard let action = $0 as? UIAction,
                  let value = action.value(forKey: kActionState) as? Int else { return false }
            return value == 1
        }
        return firters as? [UIAction]
    }

    /// row(Support single selection)
    /// - Returns: row(state is on)
    func checkRow(by section: Int) -> Int?{
        guard let sectionMenu = menu?.children[section] as? UIMenu
              else { return nil }

        let firters = sectionMenu.children.filter {
            guard let value = $0.value(forKey: kActionState) as? Int else { return false }
            return value == 1
        }

        guard let checkAction = firters.first as? UIAction else { return nil }
        return sectionMenu.children.firstIndex(of: checkAction)
    }

}
