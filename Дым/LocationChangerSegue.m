//
//  LocationChangerSegue.m
//  Дым
//
//  Created by Fenkins on 25/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "LocationChangerSegue.h"

@implementation LocationChangerSegue
-(void)perform {
    UIViewController *sourceController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    destinationController.hidesBottomBarWhenPushed = YES;
    UINavigationController *navigationController = sourceController.navigationController;
    // Pop to root view controller (not animated) before pushing
    [navigationController popToRootViewControllerAnimated:NO];
//    [navigationController pushViewController:destinationController animated:YES];

    
//  We want a customised animation, so we doing that like this:
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [navigationController.view.layer addAnimation:transition forKey:nil];
    [navigationController pushViewController:destinationController animated:YES];
}
@end
