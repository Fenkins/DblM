//
//  SpecialsTableViewController.m
//  Дым
//
//  Created by Fenkins on 23/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "SpecialsTableViewController.h"

@interface SpecialsTableViewController ()

@end

@implementation SpecialsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Background color
    self.tableView.backgroundColor = [UIColor blackColor];
    
    // Changing colors of the PFLoadingView
    [self changePFLoadingViewLabelTextColor:[UIColor whiteColor] shadowColor:[UIColor darkGrayColor]];
    
    // Adding background UIImageView to a table
    UIImage *blurredImage = [UIImage blurryGPUImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
    UIImageView *backgroundImageLayer = [[UIImageView alloc]
                                         initWithImage:blurredImage];
    
    backgroundImageLayer.layer.zPosition = -1.0;
    [backgroundImageLayer setFrame:self.tableView.frame];
    // This way our image wont fool around/hang out betweet transitions
    backgroundImageLayer.clipsToBounds = YES;
    [backgroundImageLayer setContentMode:UIViewContentModeScaleAspectFill];
    self.tableView.backgroundView = backgroundImageLayer;
    
    // Adding layer of dark and blur
    [backgroundImageLayer applyDarkBackground];
}

-(void)viewWillAppear:(BOOL)animated {
    [[self navigationController]setNavigationBarHidden:NO];
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
        self.parseClassName = @"SpecialOffers";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"enabled" equalTo:[NSNumber numberWithBool:YES]];
    // Adding location check to query
    LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
    if ([suppObject isLocationSet]) {
        [query whereKey:@"availibleAt" equalTo:suppObject.storedPlaceName];
    }
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {

    static NSString *simpleTableIdentifier = @"specialsTableViewCell";
    
    SpecialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[SpecialsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    //  Configure the cell to show title and description
    cell.specialsNameLabel.text = [object objectForKey:@"name"];
    cell.specialsShortDescriptionLabel.text = [object objectForKey:@"shortDescription"];
    
    //  Configure cell to show photo placeholder and thumbnail
    //  Set your placeholder image first
    cell.specialsImageView.image = [UIImage imageNamed:@"placeholder"];
    cell.specialsImageView.backgroundColor = [UIColor blackColor];
    [cell.specialsImageView setContentMode:UIViewContentModeScaleAspectFill];
    //  Making sure we will have a round image by clipping it to the bounds
    cell.specialsImageView.clipsToBounds = YES;
    
//    //  Making it nice and round
//    cell.specialsImageView.layer.cornerRadius = cell.specialsImageView.bounds.size.width/2;
//    //  Turning it on, to increase performance
//    cell.specialsImageView.layer.shouldRasterize = YES;
    
    PFFile *thumbnail = [object objectForKey:@"image"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            // Now that the data is fetched, update the cell's image property with thumbnail
            cell.specialsImageView.image = [UIImage imageWithData:data];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((int)[[UIScreen mainScreen] bounds].size.height) {
            // iPhone 6 Plus
        case 736:
            return 150;
            break;
            // iPhone 6
        case 667:
            return 135;
            break;
            // iPhone 5/5s
        case 568:
            return 100;
            break;
            // iPhone 4/4s
        case 480:
            return 100;
            break;
        default:
            return 135;
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSpecialsDetailSegue"]) {
        // Capture the object (e.g. exam) the user has selected from the list
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        // Set destination view controller to DetailViewController to avoid the NavigationViewController in the middle (if you have it embedded into a navigation controller, if not ignore that part)
        SpecialsDetailViewController *controller = segue.destinationViewController;
        controller.object = object;
    }
}

@end
