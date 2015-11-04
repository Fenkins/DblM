//
//  UIImageView+DarkBlurry.h
//  Дым
//
//  Created by Fenkins on 29/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DarkBlurry)
- (void)applyDarkBackground;
- (void)applyBlurryBackground;
- (void)applyDarkBackgroundUsingSuperViewBounds;
@end
