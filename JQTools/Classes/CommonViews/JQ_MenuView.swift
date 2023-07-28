//
//  JQ_MenuView.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/9/4.
//

import UIKit

#if canImport(SnapKit)

/// 下拉列表框
public class JQ_MenuView: UIView {
    private var handerVC:UIViewController?
    private var topView:UIView?
    private var tableView:UITableView?
    private var tapView:UIView?
    private var items = [String]()
    private var menuClouse:((NSInteger,String)->Void)?
    private var tableWidth:Double = 0
    private var maxW:Double = 0
    private var maxH:Double?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.frame = CGRect(x: 0, y: 0, width: JQ_ScreenW, height: JQ_ScreenH)
    }
    
    public func show(_ hander:UIViewController,tapView:UIView?,items:[String],tableWidth:Double = 0,tableHei:Double? = nil, clouse:@escaping (NSInteger,String)->Void){
        handerVC = hander
        self.tapView = tapView
        self.items = items
        self.tableWidth = tableWidth
        self.maxH = tableHei
        menuClouse = clouse
        let keyWindow  = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.separatorStyle = .none
        tableView!.isScrollEnabled = false
        tableView!.register(MenuItemTCell.self, forCellReuseIdentifier: "_MenuItemTCell")
        tableView!.jq_cornerRadius = 8 * JQ_RateW
        addSubview(tableView!)

        for item in items {
            let w = String.jq_getWidth(text: item, height: 46, font: 13) + 10
            if w > maxW{maxW = w}
        }
        
        if tapView == nil{
            tableView!.snp.makeConstraints {[weak self](make) in
                guard let weakSelf = self else { return }
                make.right.equalToSuperview().offset(-5 * JQ_RateW)
                make.top.equalToSuperview().offset(JQ_NavBarHeight)
                make.width.equalTo(weakSelf.maxW)
                make.height.equalTo(0)
            }
        }else{
            tableView!.snp.makeConstraints { [weak self] (make) in
                guard let weakSelf = self else { return }
                make.centerX.equalTo(tapView!)
                make.top.equalTo(tapView!.snp.bottom).offset(5 * JQ_RateW)
                if tableWidth != 0 && tableWidth > weakSelf.maxW{
                    make.width.equalTo(tableWidth)
                }else if tableWidth != 0 && tableWidth <= weakSelf.maxW{
                    make.width.equalTo(weakSelf.maxW)
                }else{
                    make.width.equalTo(tapView!.jq_width)
                }
                make.height.equalTo(0)
            }
        }
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2) {
            if tapView == nil{
                self.tableView!.snp.remakeConstraints {[weak self] (make) in
                    guard let weakSelf = self else { return }
                    make.right.equalToSuperview().offset(-5 * JQ_RateW)
                    make.top.equalToSuperview().offset(JQ_NavBarHeight)
                    make.width.equalTo(weakSelf.maxW)
                    make.height.equalTo(CGFloat(46 * items.count) * JQ_RateW)
                }
            }else{
                self.tableView!.snp.remakeConstraints {[weak self](make) in
                    guard let weakSelf = self else { return }
                    make.centerX.equalTo(tapView!)
                    make.top.equalTo(tapView!.snp.bottom).offset(5 * JQ_RateW)
                    if tableWidth != 0 && tableWidth > weakSelf.maxW{
                        make.width.equalTo(tableWidth)
                    }else if tableWidth != 0 && tableWidth <= weakSelf.maxW{
                        make.width.equalTo(weakSelf.maxW)
                    }else{
                        make.width.equalTo(tapView!.jq_width)
                    }
                    if weakSelf.maxH != nil{
                        weakSelf.tableView!.isScrollEnabled = true
                        let h = min(weakSelf.maxH!, Double(46 * items.count) * JQ_RateW)
                        make.height.equalTo(h)
                    }else{
                        make.height.equalTo(CGFloat(46 * items.count) * JQ_RateW)
                    }
                }
            }
            self.layoutIfNeeded()
        }
    }
    
    public func show(_ hander:UIView,tapView:UIView?,items:[String],menuWidth:Double? = nil,tableHei:Double? = nil,clouse:@escaping (NSInteger,String)->Void){
        topView = hander
        self.tapView = tapView
        self.items = items
        menuClouse = clouse
        self.maxH  = tableHei
        let keyWindow  = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.separatorStyle = .none
        tableView!.showsVerticalScrollIndicator = false
        tableView!.isScrollEnabled = false
        tableView!.register(MenuItemTCell.self, forCellReuseIdentifier: "_MenuItemTCell")
        tableView!.jq_cornerRadius = 8 * JQ_RateW
        addSubview(tableView!)
        
        if tapView == nil{
            tableView!.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-5 * JQ_RateW)
                make.top.equalToSuperview().offset(JQ_NavBarHeight)
                if menuWidth != nil{
                    make.width.equalTo(menuWidth!)
                }else{
                    make.width.equalTo(tapView!.jq_width)
                }
                make.height.equalTo(0)
            }
        }else{
            tableView!.snp.makeConstraints { (make) in
                make.centerX.equalTo(tapView!)
                make.top.equalTo(tapView!.snp.bottom).offset(5 * JQ_RateW)
                if menuWidth != nil{
                    make.width.equalTo(menuWidth!)
                }else{
                    make.width.equalTo(tapView!.jq_width)
                }
                make.height.equalTo(0)
            }
        }
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2) {
            if tapView == nil{
                self.tableView!.snp.remakeConstraints {[weak self] (make) in
                    guard let weakSelf = self else { return }
                    make.right.equalToSuperview().offset(-5 * JQ_RateW)
                    make.top.equalToSuperview().offset(JQ_NavBarHeight)
                    if menuWidth != nil{
                        make.width.equalTo(menuWidth!)
                    }else{
                        make.width.equalTo(tapView!.jq_width)
                    }

                    if weakSelf.maxH != nil{
                        weakSelf.tableView!.isScrollEnabled = true
                        let h = min(weakSelf.maxH!, Double(46 * items.count) * JQ_RateW)
                        make.height.equalTo(h)
                    }else{
                        make.height.equalTo(CGFloat(46 * items.count) * JQ_RateW)
                    }
                }
            }else{
                self.tableView!.snp.remakeConstraints { (make) in
                    make.centerX.equalTo(tapView!)
                    make.top.equalTo(tapView!.snp.bottom).offset(5 * JQ_RateW)
                    if menuWidth != nil{
                        make.width.equalTo(menuWidth!)
                    }else{
                        make.width.equalTo(tapView!.jq_width)
                    }
                    make.height.equalTo(CGFloat(46 * items.count) * JQ_RateW)
                }
            }
            self.layoutIfNeeded()
        }
    }
    
    public func hiddenView(){
        
        UIView.animate(withDuration: 0.2) {
            for cell in self.tableView!.visibleCells{
                cell.contentView.alpha = 0
            }
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            if self.tapView == nil{
                self.tableView!.snp.remakeConstraints {[weak self](make) in
                    guard let weakSelf = self else { return }
                    make.right.equalToSuperview().offset(-5 * JQ_RateW)
                    make.top.equalToSuperview().offset(JQ_NavBarHeight)
                    make.width.equalTo(weakSelf.maxW)
                    make.height.equalTo(0)
                }
            }else{
                self.tableView!.snp.remakeConstraints {[weak self](make) in
                    guard let weakSelf = self else { return }
                    make.centerX.equalTo(weakSelf.tapView!)
                    make.top.equalTo(weakSelf.tapView!.snp.bottom).offset(5 * JQ_RateW)
                    make.top.equalTo(weakSelf.tapView!.snp.bottom).offset(5 * JQ_RateW)
                    if weakSelf.tableWidth != 0 && weakSelf.tableWidth > weakSelf.maxW{
                        make.width.equalTo(weakSelf.tableWidth)
                    }else if weakSelf.tableWidth != 0 && weakSelf.tableWidth <= weakSelf.maxW{
                        make.width.equalTo(weakSelf.maxW)
                    }else{
                        make.width.equalTo(weakSelf.tapView!.jq_width)
                    }
                    make.height.equalTo(0)
                }
            }
            self.layoutIfNeeded()
        }) { (complete) in
            self.tableView?.snp.removeConstraints()
            self.tableView = nil
            self.removeFromSuperview()
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hiddenView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        tableView?.jq_shadow(shadowColor: UIColor(hexStr: "#00575E"), corner: 16, opacity: 0.1)
        tableView?.jq_masksToBounds = true
        if maxH != nil{
            tableView?.jq_borderColor = .gray
            tableView?.jq_borderWidth = 1
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JQ_MenuView:UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuClouse?(indexPath.row,items[indexPath.row])
        hiddenView()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46 * JQ_RateW
    }
}

extension JQ_MenuView:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "_MenuItemTCell") as! MenuItemTCell
        cell.itemNameL?.text = items[indexPath.row]
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
//        cell.contentView.alpha = 0
        
//        if indexPath.row == items.count - 1{
//            cell.lineView?.alpha = 0
//        }
//
//        UIView.animate(withDuration: 0.1, delay: 0.05 + Double(indexPath.row)/25, options: .layoutSubviews, animations: {
//            cell.contentView.alpha = 1
//        }) { (complete) in
//
//        }
        return cell
    }
}

public class MenuItemTCell:UITableViewCell{
    
    var itemNameL:UILabel!
    var lineView:UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        itemNameL = UILabel()
        itemNameL.font = UIFont.systemFont(ofSize: 13)
        itemNameL.textAlignment = .center
        contentView.addSubview(itemNameL)
        itemNameL.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(10 * JQ_RateW)
            make.bottom.equalTo(-10 * JQ_RateW)
        }
        
        lineView = UIView()
        lineView.backgroundColor = UIColor(hexStr: "E9EBF2")
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10 * JQ_RateW, bottom: 0, right: 10 * JQ_RateW))
            make.height.equalTo(0.5 * JQ_RateW)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
