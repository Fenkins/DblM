//
//  ContactsAboutViewController.m
//  Дым
//
//  Created by Fenkins on 09/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsAboutViewController.h"

static const NSString* kCCnullStringPhrase = @"Сегодня мы работаем с (null) до (null)";

@interface ContactsAboutViewController ()
@end

@implementation ContactsAboutViewController {
    CLLocationCoordinate2D desiredLocation;
    NSString* locationName;
    NSString* locationPlaceName;
    NSNumber* locationPhoneNumber;
    NSString* locationVKLink;
    NSString* locationInstagramLink;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Query for phone number & vk link & instagram link
    PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
    // Adding location check to query
    LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
    if ([suppObject isLocationSet]) {
        [query whereKey:@"placeName" equalTo:suppObject.storedPlaceName];
    }
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // DEFAULT PHONE NUMBER / CHANGE UPON RELEASE
            locationPhoneNumber = [NSNumber numberWithInt:(int)9286110200];
            locationVKLink = @"https://vk.com/dym_rostov";
            locationInstagramLink = @"https://instagram.com/dym_rostov/";
            NSLog(@"Error while quering for phone number, %@",error);
        } else {
            // Object found
            NSNumber *phoneNumber = [object objectForKey:@"phoneNumber"];
            if (phoneNumber) {
                locationPhoneNumber = phoneNumber;
            }
            NSString *vkLink = [object objectForKey:@"vkLink"];
            if (vkLink) {
                locationVKLink = vkLink;
            }
            NSString *instagramLink = [object objectForKey:@"instagramLink"];
            if (instagramLink) {
                locationInstagramLink = instagramLink;
            }
        }
    }];
    
    // Setting up button name with Schedule
    if (self.sheduleButtonLine && ![self.sheduleButtonLine isEqualToString:(NSString*)kCCnullStringPhrase]) {
        [self.sheduleButtonOutlet setTitle:self.sheduleButtonLine forState:UIControlStateNormal];
    }
    NSLog(@"%@",self.sheduleButtonLine);
    
    // Drawing circles background
    [self drawCircleBackgroundForButton:self.callButtonOutlet
                                   edge:2.0
                            strokeColor:[UIColor orangeColor]
                              fillColor:[UIColor orangeColor]];
    
    [self drawCircleBackgroundForButton:self.vkButtonOutlet
                                   edge:2.0
                            strokeColor:[UIColor orangeColor]
                              fillColor:[UIColor orangeColor]];
    
    [self drawCircleBackgroundForButton:self.instagramButtonOutlet
                                   edge:2.0
                            strokeColor:[UIColor orangeColor]
                              fillColor:[UIColor orangeColor]];
    
    UIImage *blurredImage = [UIImage blurryGPUImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
    self.backgroundImageLayer.image = blurredImage;
    // This way our image wont fool around/hang out betweet transitions
    
    // Adding layer of dark and blur
    [self.backgroundImageLayer applyDarkBackground];

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
        // Adding location check to query
        LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
        if ([suppObject isLocationSet]) {
            [query whereKey:@"placeName" equalTo:suppObject.storedPlaceName];
        }
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

- (IBAction)callButton:(UIButton *)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://+7%@",locationPhoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Ошибка сети" message:@"Номер недоступен" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)vkButton:(UIButton *)sender {
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"vk://"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"vk://%@",locationVKLink]]];
    } else {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",locationVKLink]]];
    }
}

- (IBAction)instagramButton:(UIButton *)sender {
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"instagram://"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"instagram://%@",locationInstagramLink]]];
    } else {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",locationInstagramLink]]];
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
