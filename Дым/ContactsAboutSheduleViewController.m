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

@end

@implementation ContactsAboutSheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sheduleImage.image = [UIImage imageNamed:@"placeholder"];
    self.sheduleImage.backgroundColor = [UIColor blackColor];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Shedule"];
    [query whereKey:@"dayIndex" equalTo:[NSNumber numberWithInt:0]];
    [query getFirstObject];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // DEFAULT PHONE NUMBER / CHANGE UPON RELEASE
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
        self.parseClassName = @"Shedule";
        
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
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *sheduleCellID = @"sheduleCell";
    
    
    ContactsAboutSheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sheduleCellID];
    if (cell == nil) {
        cell = [[ContactsAboutSheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sheduleCellID];
    }
    
    //  Configure the cell to show title and description
    cell.sheduleDayText.text = [NSString stringWithFormat:@"В %@ мы работаем с %@ до %@",
                                [object objectForKey:@"dayOfWeek"],
                                [object objectForKey:(NSString*)kCCStartTime],
                                [object objectForKey:(NSString*)kCCEndTime]];
    return cell;
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
