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
    blackScreen.frame = CGRectMake(self.frame.origin.x,
                                   self.frame.origin.y,
                                   self.frame.size.width,
                                   self.frame.size.height);
    blackScreen.backgroundColor = [UIColor blackColor];
    [self addSubview:blackScreen];
    blackScreen.alpha = 0.4;
}

- (void)applyBlurryBackground {
    UIBlurEffect *blurryBackgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurryBackground = [[UIVisualEffectView alloc]initWithEffect:blurryBackgroundEffect];
    blurryBackground.frame = CGRectMake(self.frame.origin.x,
                                        self.frame.origin.y,
                                        self.frame.size.width,
                                        self.frame.size.height);
    [self addSubview:blurryBackground];
}
@end
