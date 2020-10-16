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
+(UIImage *)JQ_GenerateQRCodeWith:(NSString *)string Width:(CGFloat)size;
+(UIImage *)JQ_ImageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
-(NSData *)jq_compressWithMaxLength:(NSUInteger)maxLength;
+(UIImage *)JQ_Image:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end
