//
//  ContactsSegmentsViewController.m
//  Дым
//
//  Created by Fenkins on 07/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsSegmentsViewController.h"

@interface ContactsSegmentsViewController (){
    NSString* _sheduleButtonLinePrep;
}
@property (nonatomic) NSArray* viewControllersArray;
@property (nonatomic) UIViewController* currentViewController;
@end

static const NSString* kCCSheduleClassName = @"Shedule";
static const NSString* kCCDayIndex = @"dayIndex";
static const NSString* kCCStartTime = @"startTime";
static const NSString* kCCEndTime = @"endTime";

@implementation ContactsSegmentsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // What day of week it is?
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [dateComps weekday];
    NSNumber* weekdayNBR = [NSNumber numberWithInteger:weekday];
    NSLog(@"What day is it? %i",weekday);

    
    // Query for shedule
    PFQuery *query = [PFQuery queryWithClassName:(NSString*)kCCSheduleClassName];
    [query whereKey:(NSString*)kCCDayIndex equalTo:weekdayNBR];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!object) {
            NSLog(@"Wow this is bad, but what we could do?");
        } else {
            NSLog(@"Work is starting at %@",[object objectForKey:(NSString*)kCCStartTime]);
            if (!_sheduleButtonLinePrep) {
                NSLog(@"Beep");
                _sheduleButtonLinePrep = [[NSString alloc]init];
                _sheduleButtonLinePrep = [NSString stringWithFormat:@"Сегодня мы работаем с %@ до %@",
                                          [object objectForKey:(NSString*)kCCStartTime],
                                          [object objectForKey:(NSString*)kCCEndTime]];
                NSLog(@"%@",_sheduleButtonLinePrep);
            } else {
                NSLog(@"Blurp");
                _sheduleButtonLinePrep = [NSString stringWithFormat:@"Сегодня мы работаем с %@ до %@",
                                          [object objectForKey:(NSString*)kCCStartTime],
                                          [object objectForKey:(NSString*)kCCEndTime]];
                NSLog(@"%@",_sheduleButtonLinePrep);
            }
        }
    }];
    
    // Loading vc1
    ContactsAboutViewController *howtoFind = [self.storyboard instantiateViewControllerWithIdentifier:@"howto-find"];
    if (_sheduleButtonLinePrep) {
        howtoFind.sheduleButtonLine = _sheduleButtonLinePrep;
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
        newVC.view.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
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
