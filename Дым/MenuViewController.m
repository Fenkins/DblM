//
//  MenuViewController.m
//  Дым
//
//  Created by Fenkins on 03/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@property BOOL isSpecialsShifted;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        NSLog(@"Button size height load %f",self.menuHookahButtonOutlet.bounds.size.height);
    
    // Adding orange circles
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        // iPhone 6 Plus
        if ([[UIScreen mainScreen] bounds].size.height == 736) {
            [self drawCirclesBackgroundBlockWithCorrection:38.666667 edge:0.0];
        }
        // iPhone 6
        else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            [self drawCirclesBackgroundBlockWithCorrection:19.0 edge:2.0];
        }
        // iPhone 5/5s
        else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            [self drawCirclesBackgroundBlockWithCorrection:-9.0 edge:2.0];
        }
        // iPhone 4/4s
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            [self drawCirclesBackgroundBlockWithCorrection:-34.0 edge:2.0];
        }
    }
    
    NSLog(@"ViewDidLoad %f %f",self.menuHookahButtonOutlet.bounds.size.width,self.menuHookahButtonOutlet.bounds.size.height);

    // Checkin for schedule
    ContactsSheduleSupplementary *sheduleCheck = [[ContactsSheduleSupplementary alloc]initWithDate:[NSDate date]];
    
    // Checkin for location
    LocationSupplementary *locationCheck = [[LocationSupplementary alloc]init];
    
    // If todays schedule is not valid, go for a new query
    // We dont want to queue for schedule until location is set, otherwise we will have a bad time
    // So we are going to update schedule line IF today's schedule is invalid and location IS set
    if (![sheduleCheck isTodaysSheduleValid] && [locationCheck isLocationSet]) {
        [sheduleCheck queryForShedule:[NSDate date]];
    }
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //code to be executed on the main queue after delay
        
        if (![locationCheck isLocationSet]) {
            [self performSegueWithIdentifier:@"locationChangerSegue" sender:self];
        }
    });
    
    // Setting label's text size
    [self.specialsButtonOutlet setTitle:@"Специальные предложения" forState:UIControlStateNormal];
    self.specialsButtonOutlet.titleLabel.adjustsFontSizeToFitWidth = YES;
//    self.specialsButtonOutlet.titleLabel.minimumScaleFactor = 2;
    
    // Setting animation for specialsShowButton
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isSpecialsHidden"]) {
        // Hiding the hide button and showing the showbutton
        
        if (!self.isSpecialsShifted) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [NSThread sleepForTimeInterval:1.5f];
                // Getting back to main q to update the interface
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:1.0 animations:^{
                        self.specialsShowButtonOutlet.alpha = 0.4;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:1.0 animations:^{
                            self.specialsShowButtonOutlet.alpha = 1;
                        }];
                    }];
                    
                });
            });
        }
    }
    
    // Moving buttons out
    [UIView animateWithDuration:0.0 animations:^{
        self.menuHookahButtonOutlet.transform = CGAffineTransformTranslate(self.menuHookahButtonOutlet.transform, 0.0, -30.0);
        self.menuTeaButtonOutlet.transform = CGAffineTransformTranslate(self.menuTeaButtonOutlet.transform, 0.0, 30.0);
        
        // Scaling buttons down
        self.menuHookahButtonOutlet.transform = CGAffineTransformScale(self.menuHookahButtonOutlet.transform, 0.0, 0.7);
        self.menuTobaccoButtonOutlet.transform = CGAffineTransformScale(self.menuTobaccoButtonOutlet.transform, 0.0, 0.7);
        self.menuTeaButtonOutlet.transform = CGAffineTransformScale(self.menuTeaButtonOutlet.transform, 0.0, 0.7);
    }];
    
    // Animating menuButtons
    
    [self menuButtonPopAnimate:self.menuHookahButtonOutlet];
    [self menuButtonPopAnimate:self.menuTobaccoButtonOutlet];
    [self menuButtonPopAnimate:self.menuTeaButtonOutlet];
    
    
    UIImage *blurredImage = [UIImage blurryGPUImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
    self.backgroundImageLayer.image = blurredImage;
    // This way our image wont fool around/hang out betweet transitions
    self.backgroundImageLayer.clipsToBounds = YES;
    [self.backgroundImageLayer setContentMode:UIViewContentModeScaleAspectFill];
    
    // Adding layer of dark and blur
    [self.backgroundImageLayer applyDarkBackgroundUsingSuperViewBounds];
    
    [self.specialsButtonOutlet.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

-(void)viewWillAppear:(BOOL)animated {
    // TEMPORARY DISABLING FOR DEVELOPMENT, ENABLE UPON RELEASE OF THE FULL VERSION
    //[[self navigationController]setNavigationBarHidden:YES];
    NSLog(@"ViewWillAppear %f %f",self.menuHookahButtonOutlet.bounds.size.width,self.menuHookahButtonOutlet.bounds.size.height);

    LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
    if (suppObject) {
        NSLog(@"We got our name %@",suppObject.storedPlaceName);
    }
    
    // Setting up a specials button
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isSpecialsHidden"]) {
        // Hiding the hide button and showing the showbutton
        self.specialsShowButtonOutlet.hidden = NO;
        self.specialsHideButtonOutlet.hidden = YES;
        self.specialsShowButtonOutlet.alpha = 1.0;
        self.specialsHideButtonOutlet.alpha = 0.0;
        self.specialsButtonOutlet.alpha = 0.0;
        if (!self.isSpecialsShifted) {
            // Specials button going out
            self.specialsButtonOutlet.transform = CGAffineTransformTranslate(self.specialsButtonOutlet.transform, self.specialsButtonOutlet.frame.size.width*2/3, 0.0);
            // Background view going out
            CGAffineTransform movingBackgroundViewRight = CGAffineTransformTranslate(self.specialsBackgroundView.transform, self.specialsBackgroundView.frame.size.width*2/4, 0.0);
            CGAffineTransform scalingBackgroundView = CGAffineTransformScale(self.specialsBackgroundView.transform, 0.5, 1.0);
            self.specialsBackgroundView.alpha = 0.0;
            self.specialsBackgroundView.transform = CGAffineTransformConcat(movingBackgroundViewRight, scalingBackgroundView);
            // Rotating the hideButton
            self.specialsHideButtonOutlet.transform = CGAffineTransformRotate(self.specialsHideButtonOutlet.transform, M_PI_2);
            // Rotating the showButton
            self.specialsShowButtonOutlet.transform = CGAffineTransformRotate(self.specialsShowButtonOutlet.transform, M_PI_2);
            self.isSpecialsShifted = YES;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"ViewDidAppear %f %f",self.menuHookahButtonOutlet.bounds.size.width,self.menuHookahButtonOutlet.bounds.size.height);
}

- (void)viewDidLayoutSubviews {
    NSLog(@"Button size height lay %f",self.menuHookahButtonOutlet.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MenuDetailTableViewController *controller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"hookahSegueID"]) {
        controller.menuName = @"hookah";
    }
    if ([segue.identifier isEqualToString:@"tobaccoSegueID"]) {
        controller.menuName = @"tobacco";
    }
    if ([segue.identifier isEqualToString:@"teaSegueID"]) {
        controller.menuName = @"tea";
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)specialsShowButton:(UIButton *)sender {
    // Making sure hide button is set and ready to rotation and presentation
    self.specialsHideButtonOutlet.hidden = NO;
    self.specialsHideButtonOutlet.alpha = 0.00001;
    [UIView animateWithDuration:0.5 animations:^{
        
        // Specials button going in
        self.specialsButtonOutlet.transform = CGAffineTransformTranslate(self.specialsButtonOutlet.transform, -self.specialsButtonOutlet.frame.size.width, 0.0);
        self.specialsButtonOutlet.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.specialsButtonOutlet.alpha = 1.0;
        
        // Background view going in
        self.specialsBackgroundView.transform = CGAffineTransformTranslate(self.specialsBackgroundView.transform, -self.specialsBackgroundView.frame.size.width*2/4, 0.0);
        self.specialsBackgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.specialsBackgroundView.alpha = 0.3;
        
        // Rotating the showButton
        self.specialsShowButtonOutlet.transform = CGAffineTransformRotate(self.specialsShowButtonOutlet.transform, -M_PI_2);
        self.specialsShowButtonOutlet.alpha = 0.0;
        // Rotating the hideButton
        self.specialsHideButtonOutlet.transform = CGAffineTransformRotate(self.specialsHideButtonOutlet.transform, -M_PI_2);
        self.specialsHideButtonOutlet.alpha = 1.0;
    }completion:^(BOOL finished) {
        self.specialsShowButtonOutlet.hidden = YES;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isSpecialsHidden"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.isSpecialsShifted = NO;
    }];
}

- (IBAction)specialsHideButton:(UIButton *)sender {
    // Making sure show button is set and ready to rotation and presentation
    self.specialsShowButtonOutlet.hidden = NO;
    self.specialsShowButtonOutlet.alpha = 0.00001;
    [UIView animateWithDuration:0.5 animations:^{
        
        // Specials button going out
        CGAffineTransform movingSpecialsButtonRight = CGAffineTransformTranslate(self.specialsButtonOutlet.transform, self.specialsButtonOutlet.frame.size.width, 0.0);
        CGAffineTransform scalingSpecialsButtonDown = CGAffineTransformScale(self.specialsButtonOutlet.transform, 0.5, 1.0);
        self.specialsButtonOutlet.alpha = 0.0;
        self.specialsButtonOutlet.transform = CGAffineTransformConcat(movingSpecialsButtonRight, scalingSpecialsButtonDown);
        
        // Background view going out
        CGAffineTransform movingBackgroundViewRight = CGAffineTransformTranslate(self.specialsBackgroundView.transform, self.specialsBackgroundView.frame.size.width*2/4, 0.0);
        CGAffineTransform scalingBackgroundView = CGAffineTransformScale(self.specialsBackgroundView.transform, 0.5, 1.0);
        self.specialsBackgroundView.alpha = 0.0;
        self.specialsBackgroundView.transform = CGAffineTransformConcat(movingBackgroundViewRight, scalingBackgroundView);
        
        // Rotating the hideButton
        self.specialsHideButtonOutlet.transform = CGAffineTransformRotate(self.specialsHideButtonOutlet.transform, M_PI_2);
        self.specialsHideButtonOutlet.alpha = 0.0;
        // Rotating the showButton
        self.specialsShowButtonOutlet.transform = CGAffineTransformRotate(self.specialsShowButtonOutlet.transform, M_PI_2);
        self.specialsShowButtonOutlet.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.specialsHideButtonOutlet.hidden = YES;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isSpecialsHidden"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.isSpecialsShifted = YES;
    }];
}

- (void)menuButtonPopAnimate:(UIView*)view {

    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:5.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        view.transform = CGAffineTransformMakeScale(1.07, 1.07);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:3.0 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }];

}

- (void)drawCirclesBackgroundBlockWithCorrection:(CGFloat)correction edge:(CGFloat)edge {
    // Drawing circles background
    [self drawCircleBackgroundForButton:self.menuHookahButtonOutlet edge:edge strokeColor:[UIColor orangeColor] fillColor:[UIColor orangeColor] boundsSizeCorrection:correction];
    [self drawCircleBackgroundForButton:self.menuTobaccoButtonOutlet edge:edge strokeColor:[UIColor orangeColor] fillColor:[UIColor orangeColor]boundsSizeCorrection:correction];
    [self drawCircleBackgroundForButton:self.menuTeaButtonOutlet edge:edge strokeColor:[UIColor orangeColor] fillColor:[UIColor orangeColor]boundsSizeCorrection:correction];
}

- (void)drawCircleBackgroundForButton:(UIButton*)button edge:(CGFloat)edge strokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor boundsSizeCorrection:(CGFloat)correction{
    CAShapeLayer* circleLayer = [CAShapeLayer layer];
    // We will have an issues if we will scale the background circles bigger then image original size becouse our original images has a size of 150/300/450p for respectively 1x/2x/3x
    if (button.bounds.size.height<=150.0 && button.bounds.size.width<=150.0) {
        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-edge, -edge, button.bounds.size.width + edge*2 + correction, button.bounds.size.height + edge*2 + correction)]CGPath]];
    } else {
        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-edge + button.bounds.size.width/2 - 150.0/2, -edge + button.bounds.size.height/2 - 150.0/2, 150.0 + edge*2 + correction, 150.0 + edge*2 + correction)]CGPath]];
    }

    [circleLayer setStrokeColor:[strokeColor CGColor]];
    [circleLayer setFillColor:[fillColor CGColor]];
    circleLayer.zPosition = -1.0;
    button.layer.zPosition = 1.0;
    [[button layer]addSublayer:circleLayer];
}

@end
