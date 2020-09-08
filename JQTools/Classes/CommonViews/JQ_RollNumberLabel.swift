//
//  JQ_RollNumberLabel.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/9/8.
//


#if canImport(SnapKit)

/// JQ_RollDigitLabel的强化版本，可以适用于浮点数，整数，金融类型
public class JQ_RollNumberLabel: UIView {
    
    var defaultNumber:NSNumber?
    var financeType = false
    var isFloatType = false
    var financeStyle:NumberFormatter.Style = .currency
    var format:String = ""
    var rawText = ""
    var items = [String]()
    public var font = UIFont.systemFont(ofSize: 18)
    public var textColor = UIColor.black
    var digalScrollView = [UIScrollView]()
    
    public var valueNumber:NSNumber = NSNumber(floatLiteral: 0){
        didSet{
            if self.valueNumber.stringValue.contains(".") {
                rawText =  financeType ? valueNumber.doubleValue.jq_fuCoin(financeStyle, format: format) : "\(defaultNumber!.doubleValue)"
            }else{
                rawText = financeType ? valueNumber.intValue.jq_fuCoin(financeStyle, format: format) : "\(valueNumber.intValue)"
            }
            layout()
        }
    }
    
    /// 初始化
    /// - Parameters:
    ///   - defaultNumber: 初始值
    ///   - financeType: 是否是金融类型（如果为false，以下的值无需设置）
    ///   - financeStyle: 【金融】类型数值类型
    ///   - format: 【金融】格式
    public convenience init(_ defaultNumber:NSNumber = NSNumber(value: 0),financeType:Bool = false,financeStyle:NumberFormatter.Style = .decimal,format:String = ",###.##") {
        self.init()
        self.defaultNumber = defaultNumber
        self.financeType = financeType
        self.financeStyle = financeStyle
        self.format = format
        
        if defaultNumber.stringValue.contains(".") {
            rawText =  financeType ? defaultNumber.doubleValue.jq_fuCoin(financeStyle, format: format) : "\(defaultNumber.doubleValue)"
        }else{
            rawText = financeType ? defaultNumber.intValue.jq_fuCoin(financeStyle, format: format) : "\(defaultNumber.intValue)"
        }
    }
    
    private func layout(){
    
        qmui_removeAllSubviews()
        digalScrollView.removeAll()
        items.removeAll()
        
        for b in Array(rawText){
            items.append(b.lowercased())
        }
        
        for (index,item) in items.enumerated() {
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.isPagingEnabled = true
            addSubview(scrollView)
            
            scrollView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(CGFloat(index) * font.pointSize * 0.6)
                make.width.equalTo(font.pointSize * 0.6)
                make.height.equalTo(font.pointSize)
                
                if items.count == index + 1{
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
            
            if item.contains(".") || item.contains(",") {
                
                let label = UILabel()
                label.text = item
                label.font = UIFont.systemFont(ofSize: font.pointSize, weight: .medium)
                label.textColor = textColor
                label.textAlignment = .center
                scrollView.addSubview(label)
                label.snp.remakeConstraints { (make) in
                    make.edges.equalToSuperview()
                    make.width.equalTo(font.pointSize * 0.6)
                }
                scrollView.contentSize = CGSize(width: font.pointSize * 0.6, height: font.pointSize)
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                scrollView.contentInset = UIEdgeInsets(top: -6 * JQ_RateW, left: 0, bottom: 0, right: 0)
                
            }else{
                for num in 0...9{
                    let label = UILabel()
                    label.text = "\(num)"
                    label.font = UIFont.systemFont(ofSize: font.pointSize, weight: .medium)
                    label.textColor = textColor
                    label.textAlignment = .center
                    scrollView.addSubview(label)
                    label.snp.remakeConstraints { (make) in
                        make.top.equalToSuperview().offset(CGFloat(num) * font.pointSize)
                        make.height.equalTo(font.pointSize)
                        make.left.equalToSuperview()
                        make.width.equalTo(font.pointSize * 0.6)
                    }
                }
                
                scrollView.setContentOffset(CGPoint(x: 0, y: Int(item)! * Int(font.pointSize)), animated: true)
                scrollView.contentSize = CGSize(width: font.pointSize * 0.6, height: font.pointSize * 10)
                digalScrollView.append(scrollView)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setUI(){
        
    }
}

#endif
