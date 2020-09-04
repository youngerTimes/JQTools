//
//  JQ_RulerView.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/9/4.
//

import UIKit

#if canImport(SnapKit)
/// 滑动轨道，年选取
public class JQ_RulerView: UIScrollView {
    
    private var min = 0
    private var max = 0
    private var step = 0
    var value = 0{
        didSet{
            if value > max && value < min {fatalError("超出范围：越界错误")}
            yearL.text = "\(self.value)年"
        }
    }
    private var w:CGFloat = 0
    private var clouse:((Int)->Void)?
    private var lineViews = [UIView]()
    public var sliderImgView:UIImageView?
    private var yearL = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    public convenience init(min:Int,max:Int,step:Int,value:Int = 0,clouse:@escaping (Int)->Void) {
        self.init(frame: CGRect.zero)
        self.min = min
        self.max = max
        self.step = step
        self.value = value
        self.clouse = clouse
        
        sliderImgView = UIImageView(image:UIImage(named: "Oval", in: Bundle(for:type(of: self)), compatibleWith: .none))
        
        if value > max && value < min {fatalError("超出范围：越界错误")}
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        pan.maximumNumberOfTouches = 1
        sliderImgView!.addGestureRecognizer(pan)
        sliderImgView!.isUserInteractionEnabled = true
    }
    
    
    @objc func panGestureAction(_ gesture:UIPanGestureRecognizer){
        
        let offset = gesture.location(in: self)
        if gesture.state == .changed{
            sliderImgView!.frame.origin.x = offset.x
        }
        
        if offset.x < -5 * JQ_RateW {
            sliderImgView!.frame.origin.x = -5 * JQ_RateW
        }
        
        if offset.x > lineViews.last!.center.x - sliderImgView!.jq_width/2{
            sliderImgView!.frame.origin.x = lineViews.last!.center.x - sliderImgView!.jq_width/2
        }
        
        self.yearL.center.x = self.sliderImgView!.center.x
        let year = floor(self.sliderImgView!.center.x/self.w)
        self.yearL.text = "\(Int(year))年"
        
        if gesture.state == .ended {self.clouse?(Int(year))}
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        w = (self.jq_width - CGFloat(max) - (contentInset.right + contentInset.left)) / CGFloat(max)
        
        for index in min...max {
            let lineView = UIView()
            lineView.backgroundColor = UIColor(hexStr: "#979797").withAlphaComponent(0.8)
            self.addSubview(lineView)
            lineViews.append(lineView)
            
            if index == 0{
                lineView.snp.remakeConstraints { (make) in
                    make.left.equalTo(contentInset.left)
                    make.width.equalTo(1 * JQ_RateW)
                    make.height.equalTo(index%step == 0 ? 10 * JQ_RateW : 8 * JQ_RateW)
                    make.top.equalToSuperview().offset(40 * JQ_RateW)
                }
            }else{
                lineView.snp.remakeConstraints { (make) in
                    make.left.equalTo(lineViews[index - 1]).offset(w)
                    make.width.equalTo(1 * JQ_RateW)
                    make.height.equalTo(index%step == 0 ? 10 * JQ_RateW : 8 * JQ_RateW)
                    make.centerY.equalTo(lineViews[index - 1])
                }
            }
            
            
            if index%step == 0 {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 10)
                label.textColor = UIColor(hexStr: "#979797").withAlphaComponent(0.8)
                label.textAlignment = .center
                label.text = "\(index)"
                self.addSubview(label)
                label.snp.makeConstraints { (make) in
                    make.centerX.equalTo(lineViews[index])
                    make.bottom.equalTo(lineViews[index].snp.top).offset(-15 * JQ_RateW)
                    make.height.equalTo(10 * JQ_RateW)
                }
            }
        }
        
        self.addSubview(sliderImgView!)
        sliderImgView!.snp.remakeConstraints { (make) in
            make.width.height.equalTo(30 * JQ_RateW)
            make.center.equalTo(lineViews[self.value])
        }
        
        yearL.text = "\(self.value)年"
        yearL.textColor = UIColor.black
        yearL.backgroundColor = UIColor.white
        yearL.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .black)
        yearL.textAlignment = .center
        self.addSubview(yearL)
        yearL.snp.makeConstraints {(make) in
            make.bottom.equalTo(sliderImgView!.snp.top)
            make.centerX.equalTo(sliderImgView!)
            make.height.equalTo(20 * JQ_RateW)
            make.width.equalTo(60 * JQ_RateW)
        }
    }
    
    private func setUI(){
        
    }
}
#endif
