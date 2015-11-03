//
//  MenuDetailTableViewController.m
//  Дым
//
//  Created by Fenkins on 03/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "MenuDetailTableViewController.h"

@interface MenuDetailTableViewController ()

@end

@implementation MenuDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"We are looking at %@ table",self.menuName);
    // Do any additional setup after loading the view.

    // Background color
    self.tableView.backgroundColor = [UIColor blackColor];
    
    // Changing colors of the PFLoadingView
    [self changePFLoadingViewLabelTextColor:[UIColor whiteColor] shadowColor:[UIColor darkGrayColor]];
    
    // Adding background UIImageView to a table
    //UIImageView *backgroundImageLayer = [[UIImageView alloc]
      //                                   initWithImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
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
        self.parseClassName = @"MenuItems";
        
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
    [query whereKey:@"category" equalTo:self.menuName];
    // Adding location check to query
    LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
    if ([suppObject isLocationSet]) {
        [query whereKey:@"availibleAt" equalTo:suppObject.storedPlaceName];    
    }
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *simpleTableIdentifier = @"menuItemCell";
    
    MenuDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[MenuDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
//  Configure the cell to show title and description
    cell.nameLabel.text = [object objectForKey:@"name"];
    cell.shortDescriptionLabel.text = [object objectForKey:@"shortDescription"];
    if ([[object objectForKey:@"priceSpecialEnabled"]boolValue]) {
        // Preparing crossed out string
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:[[object objectForKey:@"priceRegular"]stringValue] attributes:attributes];
        cell.priceLabel.attributedText = attributedString;
        cell.specialPriceLabel.text = [[object objectForKey:@"priceSpecial"]stringValue];
    } else {
        cell.priceLabel.text = [[object objectForKey:@"priceRegular"]stringValue];
        cell.specialPriceLabel.hidden = YES;
    }
    
//  Configure cell to show photo placeholder and thumbnail
//  Set your placeholder image first
    cell.thumbnailImageView.image = [UIImage imageNamed:@"placeholder"];
    cell.thumbnailImageView.backgroundColor = [UIColor blackColor];
    [cell.thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
//  Making it nice and round
    cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.bounds.size.width/2;
//  Turning it on, to increase performance
    cell.thumbnailImageView.layer.shouldRasterize = YES;
//  Making sure we will have a round image by clipping it to the bounds
    cell.thumbnailImageView.clipsToBounds = YES;
    
    PFFile *thumbnail = [object objectForKey:@"image"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            // Now that the data is fetched, update the cell's image property with thumbnail
            cell.thumbnailImageView.image = [UIImage imageWithData:data];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"productSegueID"]) {
        // Capture the object (e.g. exam) the user has selected from the list
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        // Set destination view controller to DetailViewController to avoid the NavigationViewController in the middle (if you have it embedded into a navigation controller, if not ignore that part)
        MenuDetailProductViewController *controller = segue.destinationViewController;
        controller.object = object;
    }
}


@end
