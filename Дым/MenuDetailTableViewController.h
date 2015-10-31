//
//  MenuDetailTableViewController.h
//  Дым
//
//  Created by Fenkins on 03/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <Parse.h>
#import <ParseUI.h>
#import <Bolts.h>
#import "MenuDetailTableViewCell.h"
#import "MenuDetailProductViewController.h"
#import "LocationSupplementary.h"
#import "PFQueryTableViewController+ChangeLoadingLabelColor.h"
#import "UIImageView+DarkBlurry.h"
//#import "UIImage+vImageBlur.h"
#import "UIImage+GPUImageBlur.h"

@interface MenuDetailTableViewController : PFQueryTableViewController
@property (nonatomic) NSString* menuName;
@end
