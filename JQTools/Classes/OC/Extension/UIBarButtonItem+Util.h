//
//  UIBarButtonItem+Util.h
//  黑马微博2期
//
//  Created by tjarry on 15/11/17.
//  Copyright © 2015年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Util)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action size:(CGSize)size title:(NSString *)title norColor:(UIColor *)color selTitle:(NSString *)selTitle selColor:(UIColor *)selColor;
@end
