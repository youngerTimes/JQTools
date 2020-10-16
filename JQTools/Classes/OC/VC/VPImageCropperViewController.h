//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^VPIImageCropperClouse)(UIViewController *,UIImage *);
typedef void(^VPIImageCancelClouse)(void);

@protocol VPImageCropperDelegate;

@interface VPImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nullable, nonatomic,weak) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

-(void)imageCropperHandler:(VPIImageCropperClouse)complete CancelClouse:(VPIImageCancelClouse)cancel;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end


@protocol VPImageCropperDelegate<NSObject>
@optional
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;

@end
NS_ASSUME_NONNULL_END
