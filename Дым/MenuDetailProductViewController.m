//
//  MenuDetailProductViewController.m
//  Дым
//
//  Created by Fenkins on 04/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "MenuDetailProductViewController.h"

@interface MenuDetailProductViewController ()
@property UIView* darkLayer;
@property UIImageView* blurryLayer;
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
        self.productPriceLabel.text = [NSString priceWithCurrencySymbol:[_object objectForKey:@"priceRegular"] kopeikasEnabled:NO];
        // Moving label to the center
        [UILabel animateWithDuration:0.0 animations:^{
            self.productPriceLabel.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width/4, 0.0);
        }];
        self.productSpecialPriceLabel.hidden = YES;
    }
    self.productNameLabel.text = [_object objectForKey:@"name"];
    self.productDescriptionLabel.text = [_object objectForKey:@"description"];
    
    // Background color
    self.view.backgroundColor = [UIColor blackColor];
    
//    // Constraints
//    self.productPriceLabelLeading.constant = [self returnPriceLeadingTrailing];
//    self.productSpecialPriceLabelTrailing.constant = -[self returnPriceLeadingTrailing];
    
    // Adding background UIImageView to a Scroll View
    _blurryLayer = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    _blurryLayer.layer.zPosition = -1.0;
    [_blurryLayer setFrame:self.view.frame];
    // This way our image wont fool around/hang out betweet transitions
    _blurryLayer.clipsToBounds = YES;
    [_blurryLayer setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:_blurryLayer];
    
    UIImage *blurredImage = [UIImage blurryGPUImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
    _blurryLayer.image = blurredImage;
    
    // Adding dark background to a Scroll View
    _darkLayer = [UIView createDarkBackgroundUnderScrollView:self.detailProductScrollView];
    [self.detailProductScrollView addSubview:_darkLayer];
}

-(void)viewWillLayoutSubviews {
//  We also need to set the frame in viewWillLayoutSubviews to fill the whole scrollView with dark/blurry background
    _blurryLayer.frame = CGRectMake(_blurryLayer.bounds.origin.x, _blurryLayer.bounds.origin.y + self.view.bounds.origin.y, _blurryLayer.frame.size.width, _blurryLayer.frame.size.height);
    _darkLayer.frame = CGRectMake(_darkLayer.bounds.origin.x, _darkLayer.bounds.origin.y + self.view.bounds.origin.y, _darkLayer.frame.size.width, _darkLayer.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(CGFloat)returnPriceLeadingTrailing {
//    switch ((int)[[UIScreen mainScreen] bounds].size.height) {
//            // iPhone 6 Plus
//        case 736:
//            return 35;
//            break;
//            // iPhone 6
//        case 667:
//            return 25;
//            break;
//            // iPhone 5/5s
//        case 568:
//            return 25;
//            break;
//            // iPhone 4/4s
//        case 480:
//            return 20;
//            break;
//        default:
//            return 30;
//            break;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
