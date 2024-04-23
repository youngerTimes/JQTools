//
//  JQSheetAlertView.swift
//  HeartCompanion
//
//  Created by 无故事王国 on 2020/6/17.
//  Copyright © 2020 Mr. Hu. All rights reserved.
//

import UIKit

#if canImport(SnapKit)
public typealias SheetAlertClouse = (NSInteger)->Void

public enum SheetAlertViewType {
				case twoBtn
				case oneBtn
}

/// 一种弹框
public class JQSheetAlertView: UIView {

				public var centerView = UIView()
				public var titleL = UILabel()
				public var subTitleL = UILabel()
				public var cancelBtn = UIButton(type: .custom)
				public var completeBtn = UIButton(type: .custom)
				public var type:SheetAlertViewType = .twoBtn
				private var sheetAlertClouse:SheetAlertClouse?
				private var cancelColor:UIColor?
				private var completeColor:UIColor?

				public override init(frame: CGRect) {
								super.init(frame: frame)
								backgroundColor = UIColor(hexStr: "#000000").withAlphaComponent(0.6)

								let window = UIApplication.shared.keyWindow!
								self.frame = window.frame
								window.addSubview(self)

								let closeBtn = UIButton(type: .custom)
								closeBtn.addTarget(self, action: #selector(hiddenBack), for: .touchUpInside)
								self.addSubview(closeBtn)
								closeBtn.snp.makeConstraints { make in
												make.edges.equalToSuperview()
								}

								centerView.backgroundColor = UIColor.white
								addSubview(centerView)
								centerView.snp.makeConstraints { (make) in
												make.left.bottom.right.equalToSuperview()
												make.width.equalTo(JQ_ScreenW)
												make.height.equalTo(0)
								}

								titleL.alpha = 0
								titleL.font = UIFont.systemFont(ofSize: 18, weight: .medium)
								titleL.textColor = UIColor(hexStr: "#0E1823")
								centerView.addSubview(titleL)
								titleL.snp.makeConstraints { (make) in
												make.left.top.equalTo(30)
												make.height.equalTo(25)
								}

								subTitleL.alpha = 0
								subTitleL.font = UIFont.systemFont(ofSize: 14)
								subTitleL.textColor = UIColor(hexStr: "#0E1823")
								subTitleL.numberOfLines = 0
								centerView.addSubview(subTitleL)
								subTitleL.snp.makeConstraints { (make) in
												make.top.equalTo(titleL.snp.bottom).offset(18)
												make.left.equalTo(30)
												make.right.equalTo(-20)
												make.height.greaterThanOrEqualTo(20)
								}

								cancelBtn.alpha = 0

								cancelBtn.setTitleColor(UIColor(hexStr: "#0E1823"), for: .normal)
								cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
								cancelBtn.layer.cornerRadius = 24.5
								cancelBtn.layer.masksToBounds = true
								cancelBtn.addTarget(self, action: #selector(hiddenV), for: .touchUpInside)
								centerView.addSubview(cancelBtn)
								cancelBtn.snp.makeConstraints { (make) in
												make.top.equalTo(subTitleL.snp.bottom).offset(34)
												make.bottom.equalTo(-40)
												make.left.equalTo(30)
												make.height.equalTo(49)
												make.width.equalTo(155)
								}

								completeBtn.alpha = 0
								completeBtn.backgroundColor = completeColor == nil ? UIColor(hexStr:"#01B09A"):completeColor!
								completeBtn.setTitleColor(UIColor.white, for: .normal)
								completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
								completeBtn.layer.cornerRadius = 24.5
								completeBtn.layer.masksToBounds = true
								completeBtn.addTarget(self, action: #selector(compelteAction), for: .touchUpInside)
								centerView.addSubview(completeBtn)
								completeBtn.snp.makeConstraints { (make) in
												make.top.equalTo(subTitleL.snp.bottom).offset(34)
												make.bottom.equalTo(-40)
												make.right.equalTo(-30)
												make.height.equalTo(49)
												make.width.equalTo(155)
								}
								layoutIfNeeded()
				}


				public func show(type:SheetAlertViewType = .twoBtn, title:String = "提示",content:String, cancelTitle:String = "取消",complele:String = "确定",cancelColor:UIColor? = nil,completeColor:UIColor? = nil,clouse:@escaping SheetAlertClouse){
								sheetAlertClouse = clouse
								titleL.text = title
								subTitleL.text = content
								cancelBtn.setTitle(cancelTitle, for: .normal)
								completeBtn.setTitle(complele, for: .normal)
								completeBtn.backgroundColor = completeColor == nil ? UIColor(hexStr:"#01B09A"):completeColor!
								cancelBtn.backgroundColor = cancelColor == nil ? UIColor(hexStr:"#EBEFF2"):cancelColor!

								if type == .oneBtn{
												cancelBtn.isHidden = true
												cancelBtn.snp.removeConstraints()

												completeBtn.snp.remakeConstraints { (make) in
																make.top.equalTo(subTitleL.snp.bottom).offset(34)
																make.bottom.equalTo(-40)
																make.left.equalTo(30)
																make.right.equalTo(-30)
																make.height.equalTo(49)
												}
								}

								UIView.animate(withDuration: 0.5, animations: {
												self.centerView.snp.remakeConstraints { (make) in
																make.left.bottom.right.equalToSuperview()
																make.width.equalTo(JQ_ScreenW)
																make.height.greaterThanOrEqualTo(0)
												}
												self.layoutIfNeeded()
								}) { (complte) in
												UIView.animate(withDuration: 0.4) {
																self.cancelBtn.alpha = 1
																self.completeBtn.alpha = 1
																self.subTitleL.alpha = 1
																self.titleL.alpha = 1
												}
								}
				}

				@objc private func hiddenV(){

								UIView.animate(withDuration: 0.5, animations: {
												self.alpha = 0
												self.centerView.snp.remakeConstraints { (make) in
																make.left.right.equalToSuperview()
																make.width.equalTo(JQ_ScreenW)
																make.height.greaterThanOrEqualTo(0)
																make.top.equalTo(JQ_ScreenH)
												}
												self.layoutIfNeeded()
								}) { (complte) in
												self.removeFromSuperview()
												self.sheetAlertClouse?(0)
								}
				}

				@objc private func hiddenBack(){
								UIView.animate(withDuration: 0.5, animations: {
												self.alpha = 0
												self.centerView.snp.remakeConstraints { (make) in
																make.left.right.equalToSuperview()
																make.width.equalTo(JQ_ScreenW)
																make.height.greaterThanOrEqualTo(0)
																make.top.equalTo(JQ_ScreenH)
												}
												self.layoutIfNeeded()
								}) { (complte) in
												self.removeFromSuperview()
								}
				}


				@objc private func compelteAction(){
								UIView.animate(withDuration: 0.5, animations: {
												self.centerView.snp.remakeConstraints { (make) in
																self.alpha = 0
																make.left.right.equalToSuperview()
																make.width.equalTo(JQ_ScreenW)
																make.height.greaterThanOrEqualTo(0)
																make.top.equalTo(JQ_ScreenH)
												}
												self.layoutIfNeeded()
								}) { (complte) in
												self.removeFromSuperview()
												self.sheetAlertClouse?(1)
								}
				}

				public override func layoutSubviews() {
								super.layoutSubviews()
								centerView.jq_cornerPart(byRoundingCorners: [.topLeft,.topRight], radii: 15)
				}

				required init?(coder: NSCoder) {
								fatalError("init(coder:) has not been implemented")
				}

}
#endif
