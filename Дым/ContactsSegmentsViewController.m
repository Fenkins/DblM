//
//  ContactsSegmentsViewController.m
//  Дым
//
//  Created by Fenkins on 07/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsSegmentsViewController.h"

@interface ContactsSegmentsViewController (){
    NSNumber* _startTimeRetrievedFromDefaults;
    NSNumber* _endTimeRetrievedFromDefaults;
    NSNumber* _dayOfWeekNumberRetrievedFromDefaults;
}
@property (nonatomic) NSArray* viewControllersArray;
@property (nonatomic) UIViewController* currentViewController;
@end

@implementation ContactsSegmentsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // We want to receive shedule for today
    ContactsSheduleSupplementary *receiveShedule = [[ContactsSheduleSupplementary alloc]initWithDate:[NSDate date]];
    if ([receiveShedule isTodaysSheduleValid]) {
        _startTimeRetrievedFromDefaults = [receiveShedule loadTodaysScheduleStartTime];
        _endTimeRetrievedFromDefaults = [receiveShedule loadTodaysScheduleEndTime];
        _dayOfWeekNumberRetrievedFromDefaults = [receiveShedule loadTodaysScheduleDayOfWeekNumber];
    } else {
        [receiveShedule queryForShedule:[NSDate date]];
    }
    
    // Loading vc1
    ContactsAboutViewController *howtoFind = [self.storyboard instantiateViewControllerWithIdentifier:@"howto-find"];
    if (_startTimeRetrievedFromDefaults && _endTimeRetrievedFromDefaults && _dayOfWeekNumberRetrievedFromDefaults) {
        howtoFind.suppliedScheduleStartTime = _startTimeRetrievedFromDefaults;
        howtoFind.suppliedScheduleEndTime = _endTimeRetrievedFromDefaults;
        howtoFind.suppliedScheduleDayOfWeekNumber = _dayOfWeekNumberRetrievedFromDefaults;
    } else {
        NSLog(@"NOOOOOOOOOO!!!!!!!");
    }
    // Loading vc2
    UIViewController *ourTeam = [self.storyboard instantiateViewControllerWithIdentifier:@"our-team"];
    // Adding controllers to array
    self.viewControllersArray = [[NSArray alloc]initWithObjects:howtoFind,ourTeam, nil];
    
    // Making sure vc is loaded
    self.switchVCOutlet.selectedSegmentIndex = 0;
    [self cycleFromViewController:self.currentViewController toViewController:[self.viewControllersArray objectAtIndex:self.switchVCOutlet.selectedSegmentIndex]];
}

#pragma mark - View controllers switching and saving
-(void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC {
    // Do nothing if we are attempting to switch to the same controller
    if (newVC == oldVC) return;
    if (newVC) {
        // Setting the new VC frame
        // Calculate any other frame animations here
        newVC.view.frame = CGRectMake(CGRectGetMinX(self.view.bounds),
                                      CGRectGetMinY(self.view.bounds),
                                      CGRectGetWidth(self.view.bounds),
                                      CGRectGetHeight(self.view.bounds));
        if (oldVC) {
            // Start both VC transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap View Controllers
            // No frame animations in this code but these would go in the animations block
            [self transitionFromViewController:oldVC toViewController:newVC duration:0.25 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
                // Finishing both VC transition
                [oldVC removeFromParentViewController];
                [newVC didMoveToParentViewController:self];
                // Reference to a current VC
                self.currentViewController = newVC;
            }];
        } else {
            // Otherwise we are adding VC for the first time
            // Start the VC transition
            [self addChildViewController:newVC];
            // Add the new VC to the view hierarchy
            [self.view addSubview:newVC.view];
            // End the VC transition
            [self didMoveToParentViewController:self];
            // Store the reference to the current controller
            self.currentViewController = newVC;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)indexDidChangeForSelectedControl:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    // We dont want for control to switch itself or something
    if (UISegmentedControlNoSegment != index) {
        UIViewController* incomingViewController = [self.viewControllersArray objectAtIndex:index];
        [self cycleFromViewController:self.currentViewController toViewController:incomingViewController];
    }
}
@end
