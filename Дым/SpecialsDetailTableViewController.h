//
//  SpecialsDetailTableViewController.h
//  Дым
//
//  Created by Fenkins on 24/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import <Parse.h>
#import <Bolts.h>
#import <ParseUI.h>
#import "LocationSupplementary.h"
#import "SpecialsDetailTableViewCell.h"
#import "MenuDetailProductViewController.h"
#import "UIImageView+DarkBlurry.h"
#import "PFQueryTableViewController+ChangeLoadingLabelColor.h"

@interface SpecialsDetailTableViewController : PFQueryTableViewController
@property (nonatomic) PFObject* object;
@end
