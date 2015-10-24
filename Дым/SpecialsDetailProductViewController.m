//
//  SpecialsDetailProductViewController.m
//  Дым
//
//  Created by Fenkins on 24/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "SpecialsDetailProductViewController.h"

@interface SpecialsDetailProductViewController ()

@end

@implementation SpecialsDetailProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.specialsDetailProductImage.image = [UIImage imageNamed:@"placeholder"];
    self.specialsDetailProductImage.backgroundColor = [UIColor blackColor];
    
    PFFile *thumbnail = [_object objectForKey:@"image"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            // Now that the data is fetched, update the cell's image property with thumbnail
            self.specialsDetailProductImage.image = [UIImage imageWithData:data];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    self.specialsDetailProductNameLabel.text = [_object objectForKey:@"name"];
    self.specialsDetailProductFullDescriptionLabel.text = [_object objectForKey:@"description"];
    self.specialsDetailProductPriceLabel.text = [[_object objectForKey:@"priceRegular"]stringValue];
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
