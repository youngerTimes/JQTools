//
//  ZoomImageView.m
//  caibb
//
//  Created by xh on 17/2/15.
//  Copyright © 2017年 xh. All rights reserved.
//

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#import "ZoomImageView.h"

@interface JQZoomImageView ()<UIScrollViewDelegate>{
    
    UIImageView *_showImageView;//图片视图
    CGRect _originalFrame;
    UIScrollView *_scrollView;
    UIButton * _rightBtn;
    BOOL _isChange;
}


@property(strong,nonatomic)UIImageView *tempImageView;


@end

@implementation JQZoomImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
 
*/
//实例化一个调用类
+(instancetype)getZoomImageView{
    
    static JQZoomImageView *aZoomImageView;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        aZoomImageView=[[self alloc]init];
    });
    return aZoomImageView;

}

//初始化要展示的图片
-(void)showZoomImageView:(UIImageView *)imageView addGRType:(KGestureRecognizerType)grType change:(BOOL)isChange changeImage:(void (^)(UIImageView * image))selectImage{
    _isChange = isChange;
    _selectBlock = selectImage;
    [self imageViewAddGRType:grType byImageView:imageView];
}

-(void)changeImage{
    if (_selectBlock != nil) {
        _selectBlock(_showImageView);
    }
}

-(void)imageViewAddGRType:(KGestureRecognizerType)gRType byImageView:(UIImageView *)imageView{
    
    imageView.userInteractionEnabled=YES;
    imageView.superview.userInteractionEnabled=YES;
    
    switch (gRType) {
        case KSigleTapGestureRecognizerType: {
            
            UITapGestureRecognizer *tapSingleGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGestureAction:)];//添加单击的手势

            tapSingleGR.numberOfTapsRequired = 1; //设置单击几次才触发方法
            
            [imageView addGestureRecognizer:tapSingleGR];
            
            break;
        }
            
        case KDoubleTapGestureRecognizerType: {
            
        
            UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGestureAction:)];//添加单击的手势
            doubleTapGR.numberOfTapsRequired = 2; //设置单击几次才触发方法
            doubleTapGR.numberOfTouchesRequired = 1;
            
            if(imageView.gestureRecognizers.count!=0){
                UITapGestureRecognizer *tempTapGR=imageView.gestureRecognizers.firstObject;
                tempTapGR.numberOfTapsRequired = 1;
                [tempTapGR requireGestureRecognizerToFail:doubleTapGR];
            }
            
            [imageView addGestureRecognizer:doubleTapGR];
            
            break;
        }
            
        case KLongPressGestureRecognizerType: {
            
            UILongPressGestureRecognizer *pressLongGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
            
            [pressLongGestureRecognizer addTarget:self action:@selector(imageViewGestureAction:)]; //给长按手势添加方法
            
            [imageView addGestureRecognizer:pressLongGestureRecognizer]; // 添加到当前的ImageView
            
            break;
        }
    }
}


-(void)imageViewGestureAction:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]){
        
        if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
            
          [self tapGR:gestureRecognizer];
        }
    }else{
          [self tapGR:gestureRecognizer];
    }

}


-(void)tapGR:(UIGestureRecognizer *)gestureRecognizer{
    
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    
    if (imageView.image) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        UIImageView *showImageView=[[UIImageView alloc]initWithImage:imageView.image];
        showImageView.userInteractionEnabled=YES;
        _showImageView = showImageView;
        [self addSubview:showImageView];
        
        
        UIScrollView *bgView = [[UIScrollView alloc] init];//scrollView作为背景
        bgView.frame = [UIScreen mainScreen].bounds;
        bgView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgViewGestureR:)];
        [bgView addGestureRecognizer:tapBg];
        
        showImageView.frame = [imageView convertRect:imageView.bounds toView:nil];
        
        [bgView addSubview:showImageView];
        
        
        [window addSubview:bgView];
        _originalFrame = _showImageView.frame;
        _scrollView = bgView;
        
        //最大放大比例
        _scrollView.maximumZoomScale = 1.5;
        _scrollView.delegate = self;
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = imageView.frame;
            frame.size.width = bgView.frame.size.width-10;
            frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
            frame.origin.x = 5;
            if (frame.size.height<kHeight-20) {
                
                frame.origin.y =(bgView.frame.size.height - frame.size.height) * 0.5;;
            }else{
                frame.origin.y =10;
            }

            _showImageView.frame = frame;
        }];
        bgView.contentSize=CGSizeMake(0, _showImageView.frame.size.height);
        
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setHidden:!_isChange];
        [rightBtn setImage:[UIImage imageNamed:@"message_detail_more"] forState:UIControlStateNormal];
        
        [rightBtn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(kWidth-50, 15, 50, 35);
        [window addSubview:rightBtn];
        [window bringSubviewToFront:rightBtn];
        _rightBtn = rightBtn;
    }
}


-(void)tapBgViewGestureR:(UITapGestureRecognizer *)tapGR{
    
    _scrollView.contentOffset = CGPointZero;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _showImageView.frame = _originalFrame;
        
        tapGR.view.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [_showImageView removeFromSuperview];
        [_scrollView removeFromSuperview];
        [_rightBtn removeFromSuperview];
    }];
}


//返回可缩放的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _showImageView;
}



@end
