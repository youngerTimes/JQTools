//
//  UITabBar+Badge.m
//  SnapEasy
//
//  Created by 苏斌 on 2018/6/18.
//  Copyright © 2018年 苏斌. All rights reserved.
//

#import "UITabBar+Badge.h"

#define TabbarItemNums 4.0    //tabbar的数量 如果是5个设置为5.0

@implementation UITabBar (Badge)

//显示小红点
- (void)jq_showBadgeOnItemIndex:(int)index badgeValue:(NSString *)badge{
    //移除之前的小红点
    [self jq_removeBadgeOnItemIndex:index];
    
    //新建小红点
    UILabel *badgeView = [[UILabel alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 9;//圆形
    badgeView.textColor = UIColor.whiteColor;
    badgeView.textAlignment = NSTextAlignmentCenter;
    badgeView.font = [UIFont systemFontOfSize:9];
    badgeView.text = badge;
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.55) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = 3; //ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 18, 18);//圆形大小为10
    [self addSubview:badgeView];
    
    
}

//隐藏小红点
- (void)jq_hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self jq_removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)jq_removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
