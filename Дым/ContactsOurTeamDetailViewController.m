//
//  ContactsOurTeamDetailViewController.m
//  Дым
//
//  Created by Fenkins on 19/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsOurTeamDetailViewController.h"

@interface ContactsOurTeamDetailViewController ()
@property UIView* blackScreen;
@end

@implementation ContactsOurTeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.teamMemberImage.image = [UIImage imageNamed:@"placeholder"];
    self.teamMemberImage.backgroundColor = [UIColor blackColor];
    [self.teamMemberImage setContentMode:UIViewContentModeScaleAspectFill];
    //  Making sure we will have a round image by clipping it to the bounds
    self.teamMemberImage.clipsToBounds = YES;
    
    //  Making it nice and round
    self.teamMemberImage.layer.cornerRadius = self.teamMemberImage.bounds.size.width/2;
    //  Turning it on, to increase performance
    self.teamMemberImage.layer.shouldRasterize = YES;    
    
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
    
    // Adding background UIImageView to a view
//    UIImageView *backgroundImageLayer = [[UIImageView alloc]
//                                         initWithImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
//    backgroundImageLayer.layer.zPosition = -1.0;
//    [backgroundImageLayer setFrame:self.view.frame];
//    // This way our image wont fool around/hang out betweet transitions
//    backgroundImageLayer.clipsToBounds = YES;
//    [backgroundImageLayer setContentMode:UIViewContentModeScaleAspectFill];
//    [self.view addSubview:backgroundImageLayer];
//    
    UIImage *blurredImage = [UIImage blurryGPUImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
    //backgroundImageLayer.image = blurredImage;
    [self.teamMemberScrollView setBackgroundColor:[UIColor colorWithPatternImage:blurredImage]];
    // This way our image wont fool around/hang out betweet transitions
    
    // Adding layer of dark and blur
    //[self.teamMemberScrollView.layer applyDarkBackground];
    
    _blackScreen = [[UIView alloc]init];
    _blackScreen.frame = CGRectMake(self.teamMemberScrollView.bounds.origin.x,
                                   self.teamMemberScrollView.bounds.origin.y,
                                   self.teamMemberScrollView.bounds.size.width,
                                   self.teamMemberScrollView.bounds.size.height);
    _blackScreen.backgroundColor = [UIColor blackColor];
    _blackScreen.layer.zPosition = -1.0;
    [self.teamMemberScrollView addSubview:_blackScreen];
    _blackScreen.alpha = 0.7;
    
    NSLog(@"%f",self.view.bounds.size.height);
}

-(void)viewWillLayoutSubviews {
    NSLog(@"%f",self.view.bounds.size.height);
    _blackScreen.frame = CGRectMake(_blackScreen.bounds.origin.x, _blackScreen.bounds.origin.y + self.view.bounds.origin.y, _blackScreen.frame.size.width, _blackScreen.frame.size.height);

}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"%f",self.view.bounds.size.height);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
