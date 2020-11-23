//
//  JQ_DeviceTool.h
//  JQTools
//
//  Created by 无故事王国 on 2020/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//https://www.dazhuanlan.com/2019/12/21/5dfe225dcb723/
@interface JQ_DeviceTool : NSObject

/// 强制横屏
/// @param orientation 方向
+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
