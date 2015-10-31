//
//  SpecialsDetailViewController.m
//  Дым
//
//  Created by Fenkins on 23/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "SpecialsDetailViewController.h"

@interface SpecialsDetailViewController ()

@end

@implementation SpecialsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.specialsImageView.image = [UIImage imageNamed:@"placeholder"];
    self.specialsImageView.backgroundColor = [UIColor blackColor];
    
    PFFile *thumbnail = [_object objectForKey:@"image"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            // Now that the data is fetched, update the cell's image property with thumbnail
            self.specialsImageView.image = [UIImage imageWithData:data];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    self.specialsNameLabel.text = [_object objectForKey:@"name"];
    self.specialsFullDescriptionLabel.text = [_object objectForKey:@"description"];
    
    // Background color
    self.view.backgroundColor = [UIColor blackColor];
    
    // Adding background UIImageView to a table
    UIImage *blurredImage = [UIImage blurryGPUImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
    UIImageView *backgroundImageLayer = [[UIImageView alloc]
                                         initWithImage:blurredImage];
    
    backgroundImageLayer.layer.zPosition = -1.0;
    [backgroundImageLayer setFrame:self.view.frame];
    // This way our image wont fool around/hang out betweet transitions
    backgroundImageLayer.clipsToBounds = YES;
    [backgroundImageLayer setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:backgroundImageLayer];
    
    // Adding layer of dark and blur
    [backgroundImageLayer applyDarkBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSpecialsDetailTableViewSegue"]) {
        // Passing the object further
        PFObject *object = _object;
        
        // Set destination view controller to DetailViewController to avoid the NavigationViewController in the middle (if you have it embedded into a navigation controller, if not ignore that part)
        SpecialsDetailTableViewController *controller = segue.destinationViewController;
        controller.object = object;
    }
}

@end
