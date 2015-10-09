//
//  ContactsSegmentsViewController.m
//  Дым
//
//  Created by Fenkins on 07/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsSegmentsViewController.h"

@interface ContactsSegmentsViewController (){
    Reachability* internetReachableCheck;
    BOOL _isNetworkReachable;
}
@property (nonatomic) NSArray* viewControllersArray;
@property (nonatomic) UIViewController* currentViewController;
@end

@implementation ContactsSegmentsViewController

-(void)testInternetConnection {
    internetReachableCheck = [Reachability reachabilityWithHostName:@"www.google.com"];
    // If internet is reachable
    internetReachableCheck.reachableBlock = ^(Reachability*reach) {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            _isNetworkReachable = YES;
            NSLog(@"yea");
        });
    };
    // If internet is not reachable
    internetReachableCheck.unreachableBlock = ^(Reachability*reach) {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            _isNetworkReachable = NO;
            NSLog(@"nope");
        });
    };
    [internetReachableCheck startNotifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Running that method up there to check if we are connected to the internets
    [self testInternetConnection];

    // Loading vc1
    ContactsAboutViewController *howtoFind = [self.storyboard instantiateViewControllerWithIdentifier:@"howto-find"];
    howtoFind.isInternetReachable = YES;
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
