//
//  SpecialsTableViewCell.h
//  Дым
//
//  Created by Fenkins on 23/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *specialsImageView;
@property (weak, nonatomic) IBOutlet UILabel *specialsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialsDescriptionLabel;

@end
