//
//  ContactsAboutViewController.m
//  Дым
//
//  Created by Fenkins on 09/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsAboutViewController.h"
// PARSE COULD RETURN NULL RESULT(if keys got removed or smth), AND YOUR SUPPLEMENTARY CLASS WILL STORE THAT CRAP IN NSUSERDEFAULTS. FIX IT BEFORE RELEASE!
static const NSString* kCCnullStringPhrase = @"Сегодня мы работаем с (null) до (null)";
@interface ContactsAboutViewController ()
@end

@implementation ContactsAboutViewController {
    CLLocationCoordinate2D desiredLocation;
    NSString* locationName;
    NSString* locationPlaceName;
    NSNumber* locationPhoneNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.sheduleButtonLine && ![self.sheduleButtonLine isEqualToString:(NSString*)kCCnullStringPhrase]) {
        [self.sheduleButtonOutlet setTitle:self.sheduleButtonLine forState:UIControlStateNormal];
    }
    NSLog(@"%@",self.sheduleButtonLine);
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"sheduleButtonLineReceived: %@",self.sheduleButtonLine);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentAlertSheet {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Choose Map App to open"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        UIAlertAction* googleMapsButton = [UIAlertAction actionWithTitle:@"Open with Google Maps"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     NSString *string = [NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%f,%f&zoom=16",locationPlaceName,desiredLocation.latitude,desiredLocation.longitude];
                                                                     NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                                                     [[UIApplication sharedApplication]openURL:url];
                                                                 }];
        [alert addAction:googleMapsButton];
    }
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"yandexmaps://"]]) {
        UIAlertAction* yandexMapsButton = [UIAlertAction actionWithTitle:@"Open with Yandex Maps"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     NSString *string = [NSString stringWithFormat:@"yandexmaps://?pt=%f,%f&z=16",desiredLocation.longitude,desiredLocation.latitude];
                                                                     NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                                                     [[UIApplication sharedApplication]openURL:url];
                                                                 }];
        [alert addAction:yandexMapsButton];
    }
    if (true) {
        UIAlertAction* appleMapsButton = [UIAlertAction actionWithTitle:@"Open with Apple Maps"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action) {
                                                                    MKPlacemark* placeMark = [[MKPlacemark alloc]initWithCoordinate:desiredLocation addressDictionary:nil];
                                                                    MKMapItem* mapItem = [[MKMapItem alloc]initWithPlacemark:placeMark];
                                                                    // DEFAULT PHONE NUMBER / CHANGE UPON RELEASE
                                                                    [mapItem setName:locationName];
                                                                    [mapItem setPhoneNumber:[NSString stringWithFormat:@"+7%@",(NSString*)locationPhoneNumber]];
                                                                    [mapItem openInMapsWithLaunchOptions:nil];
                                                                }];
        [alert addAction:appleMapsButton];
    }
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)queryForLocation {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
        [query whereKey:@"placeName" equalTo:@"Дым Серафимовича"];
        [query getFirstObject];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"Error while quering for location,using default one %@",error);
                desiredLocation = CLLocationCoordinate2DMake(47.219722, 39.715085);
                // CHANGE THIS NUMBER UPON RELEASE
                locationPhoneNumber = [NSNumber numberWithInt:(int)9286110200];
                locationName = @"Дым Серафимовича";
                NSString* locationPlaceNameTemp = @"Россия, Ростов-на-Дону, Серафимовича 74";
                locationPlaceName = [locationPlaceNameTemp stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                NSLog(@"%f",desiredLocation.longitude);
            } else {
                PFGeoPoint *geoPoint = [object objectForKey:@"geoPoint"];
                if (geoPoint) {
                    desiredLocation = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
                    NSLog(@"%f",desiredLocation.longitude);
                }
                NSNumber *phoneNumber = [object objectForKey:@"phoneNumber"];
                if (phoneNumber) {
                    locationPhoneNumber = phoneNumber;
                }
                NSString *nameString = [object objectForKey:@"placeName"];
                if (nameString) {
                    locationName = nameString;
                }
                NSString *locationPlaceString = [object objectForKey:@"placePlainLocation"];
                if (locationPlaceString) {
                    locationPlaceName = [locationPlaceString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                }
            }
        }];

    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)openMapButton:(UIButton *)sender {
    [self queryForLocation];
    [self presentAlertSheet];
}
@end
