//
//  UIView+DarkBlurry.h
//  Дым
//
//  Created by Fenkins on 08/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DarkBlurry)
- (void)applyDarkBackground;
+ (UIView*)createDarkBackgroundUnderScrollView: (UIScrollView*)scrollView;
- (void)applyBlurryBackground;
- (void)applyDarkBackgroundUsingSuperViewBounds;
@end
