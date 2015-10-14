//
//  LocationPlaceTableViewCell.h
//  Дым
//
//  Created by Fenkins on 14/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationPlaceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *locationImage;
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *locationDescription;

@end
