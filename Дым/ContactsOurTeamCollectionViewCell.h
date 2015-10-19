//
//  OurTeamCollectionViewCell.h
//  Дым
//
//  Created by Fenkins on 18/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <ParseUI.h>
#import <Parse.h>
#import <Bolts.h>
#import <UIKit/UIKit.h>

@interface ContactsOurTeamCollectionViewCell : PFCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *teamMemberImage;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberPositionLabel;

@end
