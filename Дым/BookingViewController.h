//
//  BookingViewController.h
//  Дым
//
//  Created by Fenkins on 05/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>
#import <Bolts.h>
#import "LocationSupplementary.h"
#import "UIImageView+DarkBlurry.h"

@interface BookingViewController : UIViewController
- (IBAction)callUsButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *callUsButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabelOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageLayer;

@end
