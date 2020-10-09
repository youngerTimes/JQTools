//
//  UIView+CornerRadius.h
//  FindCampus
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年  Mr. Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)

@property (nonatomic, assign) IBInspectable CGFloat jq_xibCornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *jq_xibBorderColor;
@property (nonatomic, assign) IBInspectable CGFloat jq_xibBorderWidth;

@property (nonatomic, assign) CGFloat jq_cornerRadius;
@property (nonatomic, strong) UIColor *jq_borderColor;
@property (nonatomic, assign) CGFloat jq_borderWidth;

@end
