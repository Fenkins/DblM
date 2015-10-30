//
//  PFQueryTableViewController+ChangeLoadingLabelColor.m
//  Дым
//
//  Created by Fenkins on 30/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "PFQueryTableViewController+ChangeLoadingLabelColor.h"

@implementation PFQueryTableViewController (ChangeLoadingLabelColor)
- (void)changePFLoadingViewLabelTextColor:(UIColor*)labelTextColor shadowColor:(UIColor*)labelShadowColor {
    
    UIActivityIndicatorViewStyle activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    // go through all of the subviews until you find a PFLoadingView subclass
    for (UIView *subview in self.view.subviews)
    {
        if ([subview class] == NSClassFromString(@"PFLoadingView"))
        {
            // find the loading label and loading activity indicator inside the PFLoadingView subviews
            for (UIView *loadingViewSubview in subview.subviews) {
                if ([loadingViewSubview isKindOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel *)loadingViewSubview;
                    {
                        label.textColor = labelTextColor;
                        label.shadowColor = labelShadowColor;
                    }
                }
                
                if ([loadingViewSubview isKindOfClass:[UIActivityIndicatorView class]])
                {
                    UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)loadingViewSubview;
                    activityIndicatorView.activityIndicatorViewStyle = activityIndicatorViewStyle;
                }
            }
        }
    }
}
@end
