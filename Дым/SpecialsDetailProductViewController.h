//
//  SpecialsDetailProductViewController.h
//  Дым
//
//  Created by Fenkins on 24/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>
#import <Bolts.h>

@interface SpecialsDetailProductViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *specialsDetailProductImage;
@property (weak, nonatomic) IBOutlet UILabel *specialsDetailProductFullDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialsDetailProductPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialsDetailProductNameLabel;
@property (nonatomic) PFObject *object;
@end
