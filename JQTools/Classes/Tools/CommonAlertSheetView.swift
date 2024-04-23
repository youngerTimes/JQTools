//
//  CommonAlertSheetView.swift
//  OoProject
//
//  Created by 无故事王国 on 2021/10/25.
//

import UIKit
import RxSwift

public enum AlertSheetType {
				case single
				case img
}
// MARK: -- 【需封装此类】
public class CommonAlertSheetView: UIView,JQNibView {

				@IBOutlet weak var centerView: UIView!
				@IBOutlet weak var tableView: UITableView!
				@IBOutlet weak var cancelHeiCons: NSLayoutConstraint!
				@IBOutlet weak var contentHeiCons: NSLayoutConstraint!
				@IBOutlet weak var cancelBtn: UIButton!

				private var handlerVC:UIViewController?
				private var titles = [String]()
				private var imgs:[String]? = nil
				private var clouse:((Int,String)->Void)?
				private var disposeBag = DisposeBag()

				public override func awakeFromNib() {
								super.awakeFromNib()
								cancelHeiCons.constant = UIDevice.jq_safeEdges.bottom + 56
								tableView.jq_registerTool(cellName: "CommonSheetTCell")
								tableView.delegate = self
								tableView.dataSource = self
								tableView.isScrollEnabled = false
								tableView.separatorStyle = .none
				}

				public override func layoutSubviews() {
								super.layoutSubviews()
								centerView.jq_cornerPartWithNib(byRoundingCorners: [.topLeft,.topRight], radii: 12, size: centerView.jq_size)
				}

				@discardableResult
				public static func show(vc:UIViewController? = nil,type:AlertSheetType,titles:[String],imgs:[String]? = nil,clouse:@escaping (Int,String)->Void)->CommonAlertSheetView{
								let window = UIApplication.shared.keyWindow
								let sheetView = CommonAlertSheetView.jq_loadToolNibView()
								sheetView.handlerVC = vc
								sheetView.titles = titles
								sheetView.imgs = imgs
								sheetView.alpha = 0
								sheetView.clouse = clouse
								window?.addSubview(sheetView)
								sheetView.frame = window?.frame ?? CGRect.zero
								if titles.count >= 5{
												sheetView.contentHeiCons.constant = 260
												sheetView.tableView.isScrollEnabled = true
								}else{
												sheetView.contentHeiCons.constant = CGFloat(titles.count) * 56.0 + 20
												sheetView.tableView.isScrollEnabled = false
								}

								UIView.animate(withDuration: 0.4) {
												sheetView.alpha = 1.0
												sheetView.layoutIfNeeded()
								}
								return sheetView
				}

				@discardableResult
				public static func showWithNoCancel(vc:UIViewController? = nil,type:AlertSheetType,titles:[String],imgs:[String]? = nil,clouse:@escaping (Int,String)->Void)->CommonAlertSheetView{
								let window = UIApplication.shared.keyWindow
								let sheetView = CommonAlertSheetView.jq_loadToolNibView()
								sheetView.handlerVC = vc
								sheetView.titles = titles
								sheetView.imgs = imgs
								sheetView.alpha = 0
								sheetView.clouse = clouse
								window?.addSubview(sheetView)
								sheetView.frame = window?.frame ?? CGRect.zero
								sheetView.contentHeiCons.constant = CGFloat(titles.count) * 56.0
								sheetView.cancelBtn.setTitle("", for: .normal)
								sheetView.cancelHeiCons.constant = UIDevice.jq_safeEdges.bottom


								UIView.animate(withDuration: 0.4) {
												sheetView.alpha = 1.0
												sheetView.layoutIfNeeded()
								}
								return sheetView
				}

				@IBAction func cancelAction(_ sender: UIButton) {
								UIView.animate(withDuration: 0.4) {
												self.alpha = 0
								} completion: { _ in
												self.removeFromSuperview()
								}
				}
}

extension CommonAlertSheetView:UITableViewDelegate{

}


extension CommonAlertSheetView:UITableViewDataSource{
				public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
								return titles.count
				}

				public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
								let cell = tableView.dequeueReusableCell(withIdentifier: "_CommonSheetTCell") as! CommonSheetTCell
								cell.btn.setTitle(titles[indexPath.row], for: .normal)
								if imgs != nil{
												cell.btn.setImage(UIImage(named: imgs![indexPath.row]), for: .normal)
												cell.btn.imagePosition = .left
												cell.btn.spacingBetweenImageAndTitle = 6
								}

								cell.btn.rx.tap.subscribe { [weak self]_ in
												self?.clouse?(indexPath.row,self?.titles[indexPath.row] ?? "")
												UIView.animate(withDuration: 0.4) {
																self?.alpha = 0
												} completion: { _ in
																self?.removeFromSuperview()
												}
								}.disposed(by: disposeBag)
								return cell
				}
}
