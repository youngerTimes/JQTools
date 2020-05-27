//
//  UIImage+GenerateQRCode.h
//  chuanYou
//
//  Created by ky_mini on 2018/9/27.
//  Copyright © 2018年 成都金翼致远科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 生成二维码
 */
@interface UIImage (GenerateQRCode)
+(UIImage *)GenerateQRCodeWith:(NSString *)string Width:(CGFloat)size;
+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
-(NSData *)compressWithMaxLength:(NSUInteger)maxLength;
+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end
