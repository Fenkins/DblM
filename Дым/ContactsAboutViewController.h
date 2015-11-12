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
#import "NSString+StringsFromNumbers.h"
#import "UIImageView+DarkBlurry.h"
#import "UIImage+GPUImageBlur.h"

@interface ContactsAboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *calendarButtonDayLabelOutlet;
@property (weak, nonatomic) IBOutlet UILabel *calendarButtonStartTimeLabelOutlet;
@property (weak, nonatomic) IBOutlet UILabel *calendarButtonEndTimeLabelOutlet;

@property (weak, nonatomic) IBOutlet UIButton *callButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *vkButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *instagramButtonOutlet;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageLayer;

- (IBAction)openMapButton:(UIButton *)sender;
- (IBAction)callButton:(UIButton *)sender;
- (IBAction)vkButton:(UIButton *)sender;
- (IBAction)instagramButton:(UIButton *)sender;

@property (nonatomic) NSNumber* suppliedScheduleStartTime;
@property (nonatomic) NSNumber* suppliedScheduleEndTime;
@property (nonatomic) NSNumber* suppliedScheduleDayOfWeekNumber;

// Background Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *socialMediaGroupBottomToSuperViewButtonLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *socialMediaGroupToScheduleGroupVerticalHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *socialMediaGroupToMapGroupVerticalHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *socialMediaGroupProportionToSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapGroupProportionToSuperview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scheduleGroupProportionToSuperView;
// Map Button
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapButtonTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapButtonLeading;
// Schedule Button
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scheduleButtonLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scheduleButtonTrailing;

@end
