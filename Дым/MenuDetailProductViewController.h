//
//  MenuDetailProductViewController.h
//  Дым
//
//  Created by Fenkins on 04/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <Parse.h>
#import <ParseUI.h>
#import <Bolts.h>
#import <UIKit/UIKit.h>
#import "UIImageView+DarkBlurry.h"

@interface MenuDetailProductViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productSpecialPriceLabel;
@property (nonatomic) PFObject *object;
@end
