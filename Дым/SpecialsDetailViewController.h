//
//  SpecialsDetailViewController.h
//  Дым
//
//  Created by Fenkins on 23/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>
#import <Bolts.h>
#import "SpecialsDetailTableViewController.h"
#import "UIImageView+DarkBlurry.h"

@interface SpecialsDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *specialsImageView;
@property (weak, nonatomic) IBOutlet UILabel *specialsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialsFullDescriptionLabel;
@property (nonatomic) PFObject *object;
@end
