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
#import "UIImage+GPUImageBlur.h"

@interface ContactsOurTeamDetailViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *teamMemberImage;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberDescriptionMember;
@property (strong, nonatomic) IBOutlet UIScrollView *teamMemberScrollView;
@property (nonatomic) PFObject *object;

@end
