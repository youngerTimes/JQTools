//
//  UIBarButtonItem+Util.m
//  黑马微博2期
//
//  Created by tjarry on 15/11/17.
//  Copyright © 2015年 heima. All rights reserved.
//

#import "UIBarButtonItem+Util.h"
@implementation UIBarButtonItem (Util)



/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
    // 设置尺寸
//    btn.backgroundColor = [UIColor orangeColor];
//    btn.imageView.contentMode = UIViewContentModeCenter;
    
    CGRect rect = btn.frame;
    rect.size = btn.currentBackgroundImage.size;
    btn.frame = rect;
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action size:(CGSize)size title:(NSString *)title norColor:(UIColor *)color selTitle:(NSString *)selTitle selColor:(UIColor *)selColor {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:selColor forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:selTitle forState:UIControlStateSelected];
//    btn.backgroundColor = [UIColor orangeColor];
    // 设置尺寸
    
    CGRect rect = btn.frame;
    rect.size = size;
    btn.frame = rect;
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


@end
