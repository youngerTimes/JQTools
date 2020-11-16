//
//  UIImage+Util.m
//  WLT
//
//  Created by wlt on 2037/6/5.
//  Copyright © 2037年 admin. All rights reserved.
//

#import "UIImage+Util.h"
@implementation UIImage (Util)
+ (UIImage *)JQ_imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha
{
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAlpha(context, alpha);
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
        
    }
}

/**
 *  设置图片透明度
 * @param alpha 透明度
 * @param image 图片
 */
+ (UIImage *)JQ_imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

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
    imageLocationViewFrame:(CGRect)viewFrame {
    
    if (!text)      {  return image;   }
    if (!fontSize)  {  fontSize = 17;   }
    if (!textColor) {  textColor = [UIColor blackColor];   }
    if (!image)     {  return nil;  }
    if (viewFrame.size.height==0 || viewFrame.size.width==0 || textFrame.size.width==0 || textFrame.size.height==0 ){return nil;}
    
    NSString *mark = text;
//    CGFloat height = [mark sizeWithPreferWidth:textFrame.size.width font:[UIFont systemFontOfSize:fontSize]].height; // 此分类方法要导入头文件
    
    CGFloat height = [mark boundingRectWithSize:CGSizeMake(textFrame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.height;
    
//    CGFloat height = [mark sizeWithSize:CGSizeMake(textFrame.size.width, MAXFLOAT) font:[UIFont systemFontOfSize:fontSize]].height;
    
    if ((height + textFrame.origin.y) > viewFrame.size.height) { // 文字高度超出父视图的宽度
        height = viewFrame.size.height - textFrame.origin.y;
    }
    
    //    CGFloat w = image.size.width;
    //    CGFloat h = image.size.height;
    UIGraphicsBeginImageContext(viewFrame.size);
    [image drawInRect:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height)];
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName : textColor };
    //位置显示
    [mark drawInRect:CGRectMake(textFrame.origin.x, textFrame.origin.y, textFrame.size.width, height) withAttributes:attr];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}


-(UIImage *)jq_resizedImageWidth:(CGFloat)width{
    //获得原图片的尺寸
    CGFloat imageW=self.size.width;
    CGFloat imageH=self.size.height;
    
    //等比调整压缩后的图片尺寸
    if(imageW >width){
        imageW=width;
        imageH=width/self.size.width *imageH;
    }
    //调整后的图片尺寸
    CGSize imageSize=CGSizeMake(imageW, imageH);
    
    //    获得图片绘制上下文
    UIGraphicsBeginImageContext(imageSize);
    //绘图
    [self drawInRect:CGRectMake(0, 0, imageW, imageH)];
    //从绘图上下文获得图片
    UIImage *resizeImage=UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return resizeImage;
}

+(UIImage *)JQ_generateQRCodeWith:(NSString *)string Width:(CGFloat)size{
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSString *urlStr = string;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


+ (UIImage *)JQ_gradientImageWithFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor frame:(CGRect)frame Direction:(GradientColorDirection)direction
{
    if (direction == GradientColorDirectionLeft || direction == GradientColorDirectionTop) {
        UIColor* colors[2] = {fromColor,toColor};
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGFloat colorComponents[8];

        UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        //    CGContextSaveGState(context);

        for (int i = 0; i<2; i++) {
            //
            UIColor* color = colors[i];
            CGColorRef temcolorRef = color.CGColor;
            const CGFloat* components = CGColorGetComponents(temcolorRef);
            for (int j = 0; j < 4; j++) {
                colorComponents[i * 4 + j] = components[j];
            }
        }

        CGPoint startPoint;
        CGPoint endPoint;

        //从上到下渐变
        if (direction == GradientColorDirectionTop) {
            startPoint = CGPointZero;
            endPoint = CGPointMake(0, frame.size.height);
        }

        //从左到右渐变
        else
        {
            startPoint = CGPointZero;
            endPoint = CGPointMake(frame.size.width, 0);
        }
        CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);
        CGColorSpaceRelease(rgb);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);

        CGImageRef cgImage2 = CGBitmapContextCreateImage(context);
        UIImage *image = [UIImage imageWithCGImage:cgImage2];//UIGraphicsGetImageFromCurrentImageContext();
        CGImageRelease(cgImage2);
        return image;
    }
    else
    {
        UIColor* colors[2] = {toColor,fromColor};
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGFloat colorComponents[8];

        UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        //    CGContextSaveGState(context);

        for (int i = 0; i<2; i++) {
            //
            UIColor* color = colors[i];
            CGColorRef temcolorRef = color.CGColor;
            const CGFloat* components = CGColorGetComponents(temcolorRef);
            for (int j = 0; j < 4; j++) {
                colorComponents[i * 4 + j] = components[j];
            }
        }

        CGPoint startPoint;
        CGPoint endPoint;

        //从下到上渐变
        if (direction == GradientColorDirectionBottom) {
            startPoint = CGPointZero;
            endPoint = CGPointMake(0, frame.size.height);
        }

        //从右到左渐变
        else
        {
            startPoint = CGPointZero;
            endPoint = CGPointMake(frame.size.width, 0);
        }
        CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);
        CGColorSpaceRelease(rgb);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);

        CGImageRef cgImage2 = CGBitmapContextCreateImage(context);
        UIImage *image = [UIImage imageWithCGImage:cgImage2];//UIGraphicsGetImageFromCurrentImageContext();
        CGImageRelease(cgImage2);
        return image;
    }
}

@end
