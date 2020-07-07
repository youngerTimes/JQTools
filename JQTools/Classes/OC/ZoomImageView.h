//
//  ZoomImageView.h
//  caibb
//
//  Created by xh on 17/2/15.
//  Copyright © 2017年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,KGestureRecognizerType){
    
    KSigleTapGestureRecognizerType,   //点击触发
    KDoubleTapGestureRecognizerType,  //双击触发
    KLongPressGestureRecognizerType   //长按触发
};

typedef void(^ZoomImageViewChangeImage)(UIImageView * image);
@interface JQZoomImageView : UIView

@property (nonatomic, copy) ZoomImageViewChangeImage selectBlock;
//实例化一个调用类
+(instancetype)getZoomImageView;

// 初始化要展示的图片
-(void)showZoomImageView:(UIImageView *)imageView addGRType:(KGestureRecognizerType)grType change:(BOOL)isChange changeImage:(void (^)(UIImageView * image))selectImage;


@end
