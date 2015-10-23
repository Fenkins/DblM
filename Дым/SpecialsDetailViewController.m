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
