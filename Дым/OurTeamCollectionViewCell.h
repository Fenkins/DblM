//
//  OurTeamCollectionViewCell.h
//  Дым
//
//  Created by Fenkins on 18/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OurTeamCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *teamMemberImage;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberNameLabel;

@end
