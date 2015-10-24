//
//  SpecialsDetailTableViewCell.h
//  Дым
//
//  Created by Fenkins on 24/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialsDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *specialsDetailImageView;
@property (weak, nonatomic) IBOutlet UILabel *specialsDetailNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialsDetailPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialsDetailShortDescriptionLabel;

@end
