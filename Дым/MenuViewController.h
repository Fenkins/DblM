//
//  MenuViewController.h
//  Дым
//
//  Created by Fenkins on 03/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDetailTableViewController.h"
#import "ContactsSheduleSupplementary.h"
#import "LocationSupplementary.h"
#import "UIImageView+DarkBlurry.h"
#import "UIImage+GPUImageBlur.h"

@interface MenuViewController : UIViewController
- (IBAction)specialsShowButton:(UIButton *)sender;
- (IBAction)specialsHideButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageLayer;

@property (weak, nonatomic) IBOutlet UIView *specialsBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *specialsButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *specialsHideButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *specialsShowButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *menuHookahButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *menuTobaccoButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *menuTeaButtonOutlet;

@end
