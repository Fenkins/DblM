//
//  UIImage+vImageBlur.h
//  Дым
//
//  Created by Fenkins on 31/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (vImageBlur)
+ (UIImage *)makeBlurryImageOutOfThis:(UIImage *)image withBlurLevel:(CGFloat)blur;
@end
