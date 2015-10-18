//
//  ContactsAboutSheduleViewController.h
//  Дым
//
//  Created by Fenkins on 12/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <Parse.h>
#import <ParseUI.h>
#import <Bolts.h>
#import "ContactsAboutSheduleTableViewCell.h"
#import "LocationSupplementary.h"

@interface ContactsAboutSheduleViewController : PFQueryTableViewController
@property (weak, nonatomic) IBOutlet UIImageView *sheduleImage;

@end
