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
// Will make a query for a table to find Administrators, all calls will be directed to them
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
            _phoneNumber = @"9287772036";
            NSLog(@"Error while quering for phone number, %@",error);
        } else {
            // Administrator found
            _phoneNumber = (NSString*)[object objectForKey:(NSString*)kCCPhoneNumberKey];
            NSLog(@"%@",_phoneNumber);
        }
    }];
    
    // Drawing circles background
    [self drawCircleBackgroundForButton:self.callUsButtonOutlet edge:2.0 strokeColor:[UIColor orangeColor] fillColor:[UIColor orangeColor]];
    
    UIImage *blurredImage = [UIImage blurryGPUImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
    self.backgroundImageLayer.image = blurredImage;
    self.backgroundImageLayer.clipsToBounds = YES;
    [self.backgroundImageLayer setContentMode:UIViewContentModeScaleAspectFill];
    // This way our image wont fool around/hang out betweet transitions
    
    // Adding layer of dark and blur
    [self.backgroundImageLayer applyDarkBackgroundUsingSuperViewBounds];
    NSLog(@"Image Bounds: %f Image Frame: %f",self.backgroundImageLayer.bounds.size.height, self.backgroundImageLayer.frame.size.height);
    NSLog(@"View Bounds: %f View Frame: %f",self.view.bounds.size.height, self.view.frame.size.height);
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
    // Our user could be impatient, so if we dont have proper number on our hands, we'll give him that one right away
    if (!_phoneNumber) {
        _phoneNumber = @"9287772036";
    }
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://+7%@",_phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView* calert = [[UIAlertView alloc]initWithTitle:@"Ошибка сети" message:@"Номер недоступен" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles:nil, nil];
        [calert show];
    }
}

- (void)drawCircleBackgroundForButton:(UIButton*)button edge:(CGFloat)edge strokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor {
    CAShapeLayer* circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-edge, -edge, button.bounds.size.width + edge*2, button.bounds.size.height + edge*2)]CGPath]];
    [circleLayer setStrokeColor:[strokeColor CGColor]];
    [circleLayer setFillColor:[fillColor CGColor]];
    circleLayer.zPosition = -1.0;
    button.layer.zPosition = 1.0;
    [[button layer]addSublayer:circleLayer];
}

@end
