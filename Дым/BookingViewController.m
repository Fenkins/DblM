//
//  BookingViewController.m
//  Дым
//
//  Created by Fenkins on 05/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "BookingViewController.h"

@interface BookingViewController ()
@property (nonatomic) NSString *phoneNumber;
@end

static const NSString* kCCStaffMembersClassKey = @"StuffMembers";
static const NSString* kCCStaffPositionKey = @"Administrator";
static const NSString* kCCPhoneNumberKey = @"phoneNumber";


@implementation BookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *query = [PFQuery queryWithClassName:(NSString*)kCCStaffMembersClassKey];
    [query whereKey:@"position" equalTo:kCCStaffPositionKey];
    
    // Adding location check to query
    LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
    if ([suppObject isLocationSet]) {
        [query whereKey:@"availibleAt" equalTo:suppObject.storedPlaceName];
    }
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // DEFAULT PHONE NUMBER / CHANGE UPON RELEASE
            _phoneNumber = @"9286110200";
            NSLog(@"Error while quering for phone number, %@",error);
        } else {
            // Administrator found
            _phoneNumber = (NSString*)[object objectForKey:(NSString*)kCCPhoneNumberKey];
            NSLog(@"%@",_phoneNumber);
        }
    }];
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

- (IBAction)callUsButton:(UIButton *)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://+7%@",_phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView* calert = [[UIAlertView alloc]initWithTitle:@"Ошибка сети" message:@"Номер недоступен" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles:nil, nil];
        [calert show];
    }
}
@end
