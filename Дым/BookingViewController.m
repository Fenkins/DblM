//
//  BookingViewController.m
//  Дым
//
//  Created by Fenkins on 05/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "BookingViewController.h"

@interface BookingViewController ()

@end

static const NSString* kCCStaffMembersClassKey = @"StuffMembers";
static const NSString* kCCStaffPositionKey = @"Administrator";
static const NSString* kCCPhoneNumberKey = @"phoneNumber";


@implementation BookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    PFQuery *query = [PFQuery queryWithClassName:(NSString*)kCCStaffMembersClassKey];
    [query whereKey:@"position" equalTo:kCCStaffPositionKey];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"Error while quering for phone number, %@",error);
        } else {
            // Administrator found
            NSNumber* phoneNumber = (NSNumber*)[object objectForKey:(NSString*)kCCPhoneNumberKey];
            NSLog(@"%@",phoneNumber);
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
    NSString *phNo = @"+919876543210";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView* calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
    
}
@end
