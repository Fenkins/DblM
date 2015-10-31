//
//  UIImage+GPUImageBlur.m
//  Дым
//
//  Created by Fenkins on 31/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "UIImage+GPUImageBlur.h"

@implementation UIImage (GPUImageBlur)
+ (UIImage *)blurryGPUImage:(UIImage *)image
              withBlurLevel:(NSInteger)blur {
    GPUImageiOSBlurFilter *blurFilter =
    [[GPUImageiOSBlurFilter alloc] init];
    UIImage *result = [blurFilter imageByFilteringImage:image];
    return result;
}
@end
