//
//  ContactsAboutViewController.h
//  Дым
//
//  Created by Fenkins on 09/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>
#import <Bolts.h>
#import <MapKit/MapKit.h>
#import "LocationSupplementary.h"
#import "UIImageView+DarkBlurry.h"

@interface ContactsAboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sheduleButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *callButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *vkButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *instagramButtonOutlet;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageLayer;

- (IBAction)openMapButton:(UIButton *)sender;
- (IBAction)callButton:(UIButton *)sender;
- (IBAction)vkButton:(UIButton *)sender;
- (IBAction)instagramButton:(UIButton *)sender;

@property (nonatomic) NSString* sheduleButtonLine;
@end
