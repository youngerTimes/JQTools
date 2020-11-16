//
//  UIImage+Util.h
//  WLT
//
//  Created by wlt on 2037/6/5.
//  Copyright © 2037年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger ,GradientColorDirection)
{
    GradientColorDirectionLeft,         // 从左到右渐变
    GradientColorDirectionRight,        // 从右到左渐变
    GradientColorDirectionTop,          // 从上到下渐变
    GradientColorDirectionBottom,       // 从下到上渐变
};

@interface UIImage (Util)
/**
 *  用颜色渲染一张图片
 */
+ (UIImage *)JQ_imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha;

/**
 *  设置图片透明度
 * @param alpha 透明度
 * @param image 图片
 */
+ (UIImage *)JQ_imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image;

/**
 图片合成文字
 @param text            文字
 @param fontSize        字体大小
 @param textColor       字体颜色
 @param textFrame       字体位置
 @param image           原始图片
 @param viewFrame       图片所在View的位置
 @return UIImage *
 */
+ (UIImage *)JQ_imageWithText:(NSString *)text
                  textFont:(NSInteger)fontSize
                 textColor:(UIColor *)textColor
                 textFrame:(CGRect)textFrame
               originImage:(UIImage *)image
    imageLocationViewFrame:(CGRect)viewFrame;


/**
 调整图片的压缩量

 @param width 设置图片的宽度
 @return 返回压缩后的图片
 */
-(UIImage *)jq_resizedImageWidth:(CGFloat)width;


/// 生成二维码
/// @param string 文字
/// @param size 大小
+(UIImage *)JQ_generateQRCodeWith:(NSString *)string Width:(CGFloat)size;

/**
 *  根据颜色生成渐变色图片
 *
 *  @param fromColor 开始颜色
 *  @param toColor   结束颜色
 *  @param frame     渐变图片大小
 *  @param direction 渐变方向
 *
 *  @return 渐变图片
 */
+ (UIImage *)JQ_gradientImageWithFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor frame:(CGRect)frame Direction:(GradientColorDirection)direction;
@end
