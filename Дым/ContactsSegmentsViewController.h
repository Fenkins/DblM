//
//  ContactsSegmentsViewController.h
//  Дым
//
//  Created by Fenkins on 07/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsAboutViewController.h"
#import <Parse.h>
#import <Bolts.h>

@interface ContactsSegmentsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *switchVCOutlet;

- (IBAction)indexDidChangeForSelectedControl:(UISegmentedControl *)sender;

@end
