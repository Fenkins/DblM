//
//  ContactsOurTeamDetailViewController.h
//  Дым
//
//  Created by Fenkins on 19/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>
#import <Bolts.h>
#import "UIImageView+DarkBlurry.h"

@interface ContactsOurTeamDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *teamMemberImage;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberDescriptionMember;
@property (nonatomic) PFObject *object;

@end
