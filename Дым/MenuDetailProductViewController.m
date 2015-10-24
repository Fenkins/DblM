//
//  MenuDetailProductViewController.m
//  Дым
//
//  Created by Fenkins on 04/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "MenuDetailProductViewController.h"

@interface MenuDetailProductViewController ()

@end

@implementation MenuDetailProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.productImageView.image = [UIImage imageNamed:@"placeholder"];
    self.productImageView.backgroundColor = [UIColor blackColor];
    
    PFFile *thumbnail = [_object objectForKey:@"image"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            // Now that the data is fetched, update the cell's image property with thumbnail
            self.productImageView.image = [UIImage imageWithData:data];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    self.productNameLabel.text = [_object objectForKey:@"name"];
    self.productDescriptionLabel.text = [_object objectForKey:@"description"];
    self.productPriceLabel.text = [[_object objectForKey:@"priceRegular"]stringValue];
    self.productSpecialPriceLabel.text = [[_object objectForKey:@"priceSpecial"]stringValue];
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
