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
    
    // Cell Constraints
    cell.priceCircleViewWidth.constant = [self priceViewDimensions];
    cell.priceCircleViewHeight.constant = [self priceViewDimensions];
    
    // Cell colors
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:153/255.0 green:143/255.0 blue:61/255.0 alpha:0.1];
    [cell setSelectedBackgroundView:bgColorView];
    
    //  Configure the cell to show title and description
    cell.nameLabel.text = [object objectForKey:@"name"];
    cell.shortDescriptionLabel.text = [object objectForKey:@"shortDescription"];
    if ([[object objectForKey:@"priceSpecialEnabled"]boolValue]) {
        // Preparing crossed out string
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[NSString priceWithCurrencySymbol:[object
                                                objectForKey:@"priceRegular"]
                                                kopeikasEnabled:NO]
                                                attributes:attributes];
        cell.priceLabel.attributedText = attributedString;
        cell.specialPriceLabel.text = [NSString priceWithCurrencySymbol:[object objectForKey:@"priceSpecial"] kopeikasEnabled:NO];
    } else {
        cell.priceLabel.text = [NSString priceWithCurrencySymbol:[object objectForKey:@"priceRegular"] kopeikasEnabled:NO];
        // Moving label to the center
        [UILabel animateWithDuration:0.0 animations:^{
            cell.priceLabel.transform = CGAffineTransformMakeTranslation(0.0, cell.priceCircleView.frame.size.height/8);
        }];
        cell.specialPriceLabel.hidden = YES;
    }
    
//  Configure cell to show photo placeholder and thumbnail
//  Set your placeholder image first
    cell.thumbnailImageView.image = [UIImage imageNamed:@"placeholder"];
    cell.thumbnailImageView.backgroundColor = [UIColor blackColor];
    [cell.thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
    //  Making sure we will have a round image by clipping it to the bounds
    cell.thumbnailImageView.clipsToBounds = YES;

////  Making it nice and round
//    cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.bounds.size.width/2;
////  Turning it on, to increase performance
//    cell.thumbnailImageView.layer.shouldRasterize = YES;
    
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
    
    // Drawing circle behind view
    //Colored Edge
    [self drawCircleBackgroundForView:cell.priceCircleView
                                 edge:0.0
                              opacity:1.0
                          strokeColor:[UIColor redColor]
                            fillColor:[UIColor clearColor]
                 useCurrentSizeOfView:NO];
    //Circle itself
    [self drawCircleBackgroundForView:cell.priceCircleView
                                 edge:0.0
                              opacity:0.1
                          strokeColor:[UIColor clearColor]
                            fillColor:[UIColor blackColor]
                 useCurrentSizeOfView:NO];
    
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
    if ([segue.identifier isEqualToString:@"productSegueID"]) {
        // Capture the object (e.g. exam) the user has selected from the list
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        // Set destination view controller to DetailViewController to avoid the NavigationViewController in the middle (if you have it embedded into a navigation controller, if not ignore that part)
        MenuDetailProductViewController *controller = segue.destinationViewController;
        controller.object = object;
    }
}

- (void)drawCircleBackgroundForView:(UIView*)view edge:(CGFloat)edge opacity:(CGFloat)opacity strokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor useCurrentSizeOfView:(BOOL)useViewSize {
    CAShapeLayer* circleLayer = [CAShapeLayer layer];
    if (useViewSize) {
        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-edge, -edge, view.bounds.size.width + edge*2, view.bounds.size.width + edge*2)]CGPath]];
    } else {
        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-edge, -edge, [self priceViewDimensions] + edge*2, [self priceViewDimensions] + edge*2)]CGPath]];
    }
    
    [circleLayer setStrokeColor:[strokeColor CGColor]];
    [circleLayer setFillColor:[fillColor CGColor]];
    circleLayer.zPosition = -1.0;
    circleLayer.opacity = opacity;
    view.layer.zPosition = 1.0;
    [[view layer]addSublayer:circleLayer];
}

-(CGFloat)priceViewDimensions {
    switch ((int)[[UIScreen mainScreen] bounds].size.height) {
            // iPhone 6 Plus
        case 736:
            return 90;
            break;
            // iPhone 6
        case 667:
            return 85;
            break;
            // iPhone 5/5s
        case 568:
            return 75;
            break;
            // iPhone 4/4s
        case 480:
            return 70;
            break;
        default:
            return 100;
            break;
    }
}

@end
