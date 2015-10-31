//
//  UIImageView+DarkBlurry.m
//  Дым
//
//  Created by Fenkins on 29/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "UIImageView+DarkBlurry.h"

@implementation UIImageView (DarkBlurry)
- (void)applyDarkBackground {
    UIView *blackScreen = [[UIView alloc]init];
    blackScreen.frame = CGRectMake(self.bounds.origin.x,
                                   self.bounds.origin.y,
                                   self.bounds.size.width,
                                   self.bounds.size.height);
    blackScreen.backgroundColor = [UIColor blackColor];
    [self addSubview:blackScreen];
    blackScreen.alpha = 0.7;
}

- (void)applyBlurryBackground {
    UIBlurEffect *blurryBackgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurryBackground = [[UIVisualEffectView alloc]initWithEffect:blurryBackgroundEffect];
    blurryBackground.frame = CGRectMake(self.bounds.origin.x,
                                        self.bounds.origin.y,
                                        self.bounds.size.width,
                                        self.bounds.size.height);
    [self addSubview:blurryBackground];
}

@end
