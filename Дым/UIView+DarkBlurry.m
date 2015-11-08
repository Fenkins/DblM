//
//  UIView+DarkBlurry.m
//  Дым
//
//  Created by Fenkins on 08/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "UIView+DarkBlurry.h"

@implementation UIView (DarkBlurry)
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

+ (UIView*)createDarkBackgroundUnderScrollView: (UIScrollView*)scrollView {
    UIView *blackScreen = [[UIView alloc]init];
    blackScreen.frame = CGRectMake(scrollView.bounds.origin.x,
                                   scrollView.bounds.origin.y,
                                   scrollView.bounds.size.width,
                                   scrollView.bounds.size.height);
    blackScreen.backgroundColor = [UIColor blackColor];
    blackScreen.layer.zPosition = -1.0;
    blackScreen.alpha = 0.7;
    return blackScreen;
}

- (void)applyDarkBackgroundUsingSuperViewBounds {
    UIView *blackScreen = [[UIView alloc]init];
    blackScreen.frame = CGRectMake(self.superview.bounds.origin.x,
                                   self.superview.bounds.origin.y,
                                   self.superview.bounds.size.width,
                                   self.superview.bounds.size.height);
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
