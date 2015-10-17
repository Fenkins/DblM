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
    // If todays schedule is not valid, go for a new query
    if (![sheduleCheck isTodaysSheduleValid]) {
        [sheduleCheck queryForShedule:[NSDate date]];
    }
    
// Somehow dis crap is crashing us
//    if (![locationCheck checkIfLocationObjectExist]) {
//        [self performSegueWithIdentifier:@"locationChangerSegue" sender:self];
//    }
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    // TEMPORARY DISABLING FOR DEVELOPMENT, ENABLE UPON RELEASE OF THE FULL VERSION
    //[[self navigationController]setNavigationBarHidden:YES];

    LocationSupplementary *suppObject = [[LocationSupplementary alloc]loadCustomObjectWithKey:@"StoredLocation"];

    if (suppObject) {
        NSLog(@"We got our name %@",suppObject.storedPlaceName);
    }
// Trying the query for pinned object
//    PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
//    [query fromPinWithName:@"StoredLocation"];
//    [query whereKey:@"enabled" equalTo:[NSNumber numberWithBool:YES]];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
//        if ([[object objectForKey:@"placeName"] isKindOfClass:[NSString class]]) {
//            NSLog(@"Got our stuff %@",[object objectForKey:@"placeDescription"]);
//        } else {
//            NSLog(@"Something goes terribly wrong");
//        }
//    }];
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


@end
