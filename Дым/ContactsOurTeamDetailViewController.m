//
//  ContactsOurTeamDetailViewController.m
//  Дым
//
//  Created by Fenkins on 19/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsOurTeamDetailViewController.h"

@interface ContactsOurTeamDetailViewController ()

@end

@implementation ContactsOurTeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.teamMemberImage.image = [UIImage imageNamed:@"placeholder"];
    self.teamMemberImage.backgroundColor = [UIColor blackColor];
    
    PFFile *thumbnail = [_object objectForKey:@"image"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            // Now that the data is fetched, update the cell's image property with thumbnail
            self.teamMemberImage.image = [UIImage imageWithData:data];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    self.teamMemberNameLabel.text = [_object objectForKey:@"name"];
    self.teamMemberPositionLabel.text = [_object objectForKey:@"position"];
    self.teamMemberDescriptionMember.text = [_object objectForKey:@"description"];
    
    // Adding background UIImageView to a table
    UIImageView *backgroundImageLayer = [[UIImageView alloc]
                                         initWithImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    backgroundImageLayer.layer.zPosition = -1.0;
    [backgroundImageLayer setFrame:self.view.frame];
    // This way our image wont fool around/hang out betweet transitions
    backgroundImageLayer.clipsToBounds = YES;
    [backgroundImageLayer setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:backgroundImageLayer];
    
    UIImage *blurredImage = [UIImage blurryGPUImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
    backgroundImageLayer.image = blurredImage;
    // This way our image wont fool around/hang out betweet transitions
    
    // Adding layer of dark and blur
    [backgroundImageLayer applyDarkBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
