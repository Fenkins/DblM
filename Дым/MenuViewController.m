//
//  MenuViewController.m
//  Дым
//
//  Created by Fenkins on 03/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
}

-(void)viewWillAppear:(BOOL)animated {
    // TEMPORARY DISABLING FOR DEVELOPMENT, ENABLE UPON RELEASE OF THE FULL VERSION
    //[[self navigationController]setNavigationBarHidden:YES];

    LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
    if (suppObject) {
        NSLog(@"We got our name %@",suppObject.storedPlaceName);
    }
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
    self.specialsHideButtonOutlet.hidden = NO;
    self.specialsHideButtonOutlet.alpha = 0.00001;
    [UIView animateWithDuration:0.5 animations:^{
        // Specials button going in
        self.specialsButtonOutlet.transform = CGAffineTransformTranslate(self.specialsButtonOutlet.transform, -100.0, 0.0);
        self.specialsButtonOutlet.alpha = 1.0;
        // Rotating the !
        self.specialsShowButtonOutlet.transform = CGAffineTransformRotate(self.specialsShowButtonOutlet.transform, -M_PI_2);
        self.specialsShowButtonOutlet.alpha = 0.0;
        // Rotating the cross
        self.specialsHideButtonOutlet.transform = CGAffineTransformRotate(self.specialsHideButtonOutlet.transform, -M_PI_2);
        self.specialsHideButtonOutlet.alpha = 1.0;
    }completion:^(BOOL finished) {
        self.specialsShowButtonOutlet.hidden = YES;
    }];
}

- (IBAction)specialsHideButton:(UIButton *)sender {
    // Making sure show button is set and ready to rotation and presentation
    self.specialsShowButtonOutlet.hidden = NO;
    self.specialsShowButtonOutlet.alpha = 0.00001;
    [UIView animateWithDuration:0.5 animations:^{
        // Specials button going out
        self.specialsButtonOutlet.transform = CGAffineTransformTranslate(self.specialsButtonOutlet.transform, 100.0, 0.0);
        self.specialsButtonOutlet.alpha = 0.0;
        // Rotating the cross
        self.specialsHideButtonOutlet.transform = CGAffineTransformRotate(self.specialsHideButtonOutlet.transform, M_PI_2);
        self.specialsHideButtonOutlet.alpha = 0.0;
        // Rotating the !
        self.specialsShowButtonOutlet.transform = CGAffineTransformRotate(self.specialsShowButtonOutlet.transform, M_PI_2);
        self.specialsShowButtonOutlet.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.specialsHideButtonOutlet.hidden = YES;
    }];
}
@end
