//
//  UIImage+GPUImageBlur.h
//  Дым
//
//  Created by Fenkins on 31/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage.h>

@interface UIImage (GPUImageBlur)
+ (UIImage *)blurryGPUImage:(UIImage *)image
              withBlurLevel:(NSInteger)blur;
@end
