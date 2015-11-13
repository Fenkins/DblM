//
//  ContactsAboutSheduleViewController.m
//  Дым
//
//  Created by Fenkins on 12/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsAboutSheduleViewController.h"
static const NSString* kCCStartTime = @"startTime";
static const NSString* kCCEndTime = @"endTime";
@interface ContactsAboutSheduleViewController ()
@property BOOL doneLoading;
@end

@implementation ContactsAboutSheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sheduleImage.image = [UIImage imageNamed:@"placeholder"];
    self.sheduleImage.backgroundColor = [UIColor blackColor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            PFQuery *query = [PFQuery queryWithClassName:@"Schedule"];
            // Adding location check to query
            LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
            if ([suppObject isLocationSet]) {
                [query whereKey:@"availibleAt" equalTo:suppObject.storedPlaceName];
            }
            [query whereKey:@"dayIndex" equalTo:[NSNumber numberWithInt:0]];
            [query getFirstObject];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!object) {
                    NSLog(@"Error while quering for image, %@",error);
                } else {
                    PFFile *thumbnail = [object objectForKey:@"image"];
                    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            // Now that the data is fetched, update the cell's image property with thumbnail
                            self.sheduleImage.image = [UIImage imageWithData:data];
                        } else {
                            // Log details of the failure
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }];
                }
            }];
    });
    
    // Background color
    self.tableView.backgroundColor = [UIColor blackColor];
    
    // Changing colors of the PFLoadingView
    [self changePFLoadingViewLabelTextColor:[UIColor whiteColor] shadowColor:[UIColor darkGrayColor]];
    
    // Adding background UIImageView to a table
    UIImageView *backgroundImageLayer = [[UIImageView alloc]
                                         initWithImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    backgroundImageLayer.layer.zPosition = -1.0;
    [backgroundImageLayer setFrame:self.tableView.frame];
    // This way our image wont fool around/hang out betweet transitions
    backgroundImageLayer.clipsToBounds = YES;
    [backgroundImageLayer setContentMode:UIViewContentModeScaleAspectFill];
    self.tableView.backgroundView = backgroundImageLayer;
    
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

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Schedule";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"dayIndex";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"dayIndex" notEqualTo:[NSNumber numberWithInt:0]];
    // Adding location check to query
    LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
    if ([suppObject isLocationSet]) {
        [query whereKey:@"availibleAt" equalTo:suppObject.storedPlaceName];
    }
    return query;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.objects.count + 1);
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if (_doneLoading == YES) {
        if (indexPath.row < 1) {
            return nil;
        } else if (indexPath.row > (self.objects.count + 1)) {
            return nil;
        } else {
            return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
        }
    }
    
    return nil;
}

-(void)objectsDidLoad:(NSError *)error {
    _doneLoading = YES;
    if (_doneLoading) {
        [super objectsDidLoad:error];
    }
    if (error) {
        NSLog(@"Error in loading objects %@",error);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *sheduleCellID = @"sheduleCell";
    
    
    ContactsAboutSheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sheduleCellID];
    if (cell == nil) {
        cell = [[ContactsAboutSheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sheduleCellID];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    if ([[object objectForKey:(NSString*)kCCStartTime]isKindOfClass:[NSNumber class]] &&
        [[object objectForKey:(NSString*)kCCEndTime]isKindOfClass:[NSNumber class]]) {
        //  Configure the cell
        // Extracting start and end time
        NSString* startTimeString = [NSString stringWithFormat:@"%@",
                                     [object objectForKey:(NSString*)kCCStartTime]];
        NSString* endTimeString = [NSString stringWithFormat:@"%@",
                                   [object objectForKey:(NSString*)kCCEndTime]];
        // Formatting the strings to HH:MM format
        NSString* startTimeFormatted = [NSString stringWithFormat:@"%@:%@",
            [startTimeString substringToIndex:[startTimeString length]-2],
            [startTimeString substringFromIndex:[startTimeString length]-2]];
        // Formatting the strings to HH:MM format
        NSString* endTimeFormatted = [NSString stringWithFormat:@"%@:%@",
            [endTimeString substringToIndex:[endTimeString length]-2],
            [endTimeString substringFromIndex:[endTimeString length]-2]];
        
        [self changeFontSizeForEveryOtherRowCells:cell];
        cell.sheduleDayText.text = [NSString stringWithFormat:@"%@",
                                        [object objectForKey:@"dayOfWeek"]];
        
        cell.scheduleDayTIme.text = [NSString stringWithFormat:@"с %@ до %@",
                                                            startTimeFormatted,
                                                            endTimeFormatted];

    } else if (indexPath.row < 1 && _doneLoading) {
        [self changeFontSizeForZeroIndexPathRowCell:cell];
        cell.sheduleDayText.text = @"Расписание работы";
        cell.scheduleDayTIme.text = nil;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((int)[[UIScreen mainScreen] bounds].size.height) {
        // iPhone 6 Plus
        case 736:
            return 75;
            break;
        // iPhone 6
        case 667:
            return 65;
            break;
        // iPhone 5/5s
        case 568:
            return 55;
            break;
        // iPhone 4/4s
        case 480:
            return 45;
            break;
        default:
            return 75;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)changeFontSizeForZeroIndexPathRowCell:(ContactsAboutSheduleTableViewCell*)cell {
    // Setting up font for "Расписание работы"
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        // iPhone 6 Plus
        if ([[UIScreen mainScreen] bounds].size.height == 736) {
            [cell.sheduleDayText setFont:[UIFont systemFontOfSize:38]];
        }
        // iPhone 6
        else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            [cell.sheduleDayText setFont:[UIFont systemFontOfSize:34]];
        }
        // iPhone 5/5s
        else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            [cell.sheduleDayText setFont:[UIFont systemFontOfSize:28]];
        }
        // iPhone 4/4s
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            [cell.sheduleDayText setFont:[UIFont systemFontOfSize:24]];
        }
    }
}

-(void)changeFontSizeForEveryOtherRowCells:(ContactsAboutSheduleTableViewCell*)cell {
    // Setting up font for "Расписание работы"
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        // iPhone 6 Plus
        if ([[UIScreen mainScreen] bounds].size.height == 736) {
            [cell.sheduleDayText setFont:[UIFont systemFontOfSize:25]];
            [cell.scheduleDayTIme setFont:[UIFont systemFontOfSize:23]];
        }
        // iPhone 6
        else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            [cell.sheduleDayText setFont:[UIFont systemFontOfSize:24]];
            [cell.scheduleDayTIme setFont:[UIFont systemFontOfSize:22]];
        }
        // iPhone 5/5s
        else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            [cell.sheduleDayText setFont:[UIFont systemFontOfSize:20]];
            [cell.scheduleDayTIme setFont:[UIFont systemFontOfSize:18]];
        }
        // iPhone 4/4s
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            [cell.sheduleDayText setFont:[UIFont systemFontOfSize:18]];
            [cell.scheduleDayTIme setFont:[UIFont systemFontOfSize:16]];        }
    }
}

@end
