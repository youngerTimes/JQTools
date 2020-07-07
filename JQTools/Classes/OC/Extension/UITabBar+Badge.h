//
//  UITabBar+Badge.h
//  SnapEasy
//
//  Created by 苏斌 on 2018/6/18.
//  Copyright © 2018年 苏斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)jq_showBadgeOnItemIndex:(int)index badgeValue:(NSString *)badge;   //显示小红点

- (void)jq_hideBadgeOnItemIndex:(int)index; //隐藏小红点


@end
