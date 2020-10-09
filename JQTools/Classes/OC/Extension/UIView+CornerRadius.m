//
//  UIView+CornerRadius.m
//  FindCampus
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年  Mr. Hu. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

-(void)setJq_xibCornerRadius:(CGFloat)jq_xibCornerRadius{
    self.layer.cornerRadius = jq_xibCornerRadius;
    self.layer.masksToBounds = jq_xibCornerRadius > 0;
}


-(void)setJq_xibBorderColor:(UIColor *)jq_xibBorderColor{
    self.layer.borderColor = jq_xibBorderColor.CGColor;
}


-(void)setJq_xibBorderWidth:(CGFloat)jq_xibBorderWidth{
    self.layer.borderWidth = jq_xibBorderWidth;
}

- (void)setJq_cornerRadius:(CGFloat)jq_cornerRadius{
    self.layer.cornerRadius = jq_cornerRadius;
    self.layer.masksToBounds = jq_cornerRadius > 0;
}


- (void)setJq_borderColor:(UIColor *)jq_borderColor{
    self.layer.borderColor = jq_borderColor.CGColor;
}


- (void)setJq_borderWidth:(CGFloat)jq_borderWidth{
    self.layer.borderWidth = jq_borderWidth;
}


- (CGFloat)jq_cornerRadius{
    return self.layer.cornerRadius;
}

- (UIColor *)jq_borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (CGFloat)jq_borderWidth{
    return self.layer.borderWidth;
}

- (CGFloat)jq_xibCornerRadius{
    return self.layer.cornerRadius;
}

- (UIColor *)jq_xibBorderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (CGFloat)jq_xibBorderWidth{
    return self.layer.borderWidth;
}

@end
