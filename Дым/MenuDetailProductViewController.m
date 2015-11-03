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
    [self.productImageView setContentMode:UIViewContentModeScaleAspectFill];
    //  Making sure we will have a round image by clipping it to the bounds
    self.productImageView.clipsToBounds = YES;
    
//    //  Making it nice and round
//    self.productImageView.layer.cornerRadius = self.productImageView.bounds.size.width/2;
//    //  Turning it on, to increase performance
//    self.productImageView.layer.shouldRasterize = YES;
    
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

    // If special price is active, enabling it and crossing out the regular price
    if ([[_object objectForKey:@"priceSpecialEnabled"]boolValue]) {
        // Preparing crossed out string
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithString:[NSString priceWithCurrencySymbol:[_object objectForKey:@"priceRegular"] kopeikasEnabled:NO]
                                                attributes:attributes];
        self.productPriceLabel.attributedText = attributedString;
        self.productSpecialPriceLabel.text = [NSString priceWithCurrencySymbol:[_object objectForKey:@"priceSpecial"] kopeikasEnabled:NO];
    } else {
        self.productPriceLabel.text = [NSString priceWithCurrencySymbol:[_object objectForKey:@"priceRegular"] kopeikasEnabled:NO];;
        self.productSpecialPriceLabel.hidden = YES;
    }
    self.productNameLabel.text = [_object objectForKey:@"name"];
    self.productDescriptionLabel.text = [_object objectForKey:@"description"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
