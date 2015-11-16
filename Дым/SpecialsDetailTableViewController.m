//
//  SpecialsDetailTableViewController.m
//  Дым
//
//  Created by Fenkins on 24/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "SpecialsDetailTableViewController.h"

@interface SpecialsDetailTableViewController ()

@end

@implementation SpecialsDetailTableViewController

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
    [query whereKey:@"tags" containedIn:[_object objectForKey:@"tags"]];
    // Adding location check to query
    LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
    if ([suppObject isLocationSet]) {
        [query whereKey:@"availibleAt" equalTo:suppObject.storedPlaceName];
    }
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {

    static NSString *simpleTableIdentifier = @"specialsDetailTableViewCell";
    
    SpecialsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[SpecialsDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
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
    cell.specialsDetailNameLabel.text = [object objectForKey:@"name"];
    cell.specialsDetailShortDescriptionLabel.text = [object objectForKey:@"shortDescription"];
    if ([[object objectForKey:@"priceSpecialEnabled"]boolValue]) {
        // Preparing crossed out string
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithString:[NSString priceWithCurrencySymbol:[object objectForKey:@"priceRegular"] kopeikasEnabled:NO]
                                                attributes:attributes];
        cell.specialsDetailPriceLabel.attributedText = attributedString;
        cell.specialsDetailSpecialPriceLabel.text = [NSString priceWithCurrencySymbol:[object objectForKey:@"priceSpecial"] kopeikasEnabled:NO];
    } else {
        cell.specialsDetailPriceLabel.text = [NSString priceWithCurrencySymbol:[object objectForKey:@"priceRegular"] kopeikasEnabled:NO];
        // Moving label to the center
        [UILabel animateWithDuration:0.0 animations:^{
            cell.specialsDetailPriceLabel.transform = CGAffineTransformMakeTranslation(0.0, cell.specialsDetailPriceCircleView.frame.size.height/9);
        }];
        cell.specialsDetailSpecialPriceLabel.hidden = YES;
    }
    
    //  Configure cell to show photo placeholder and thumbnail
    //  Set your placeholder image first
    cell.specialsDetailImageView.image = [UIImage imageNamed:@"placeholder"];
    cell.specialsDetailImageView.backgroundColor = [UIColor blackColor];
    [cell.specialsDetailImageView setContentMode:UIViewContentModeScaleAspectFill];
    //  Making sure we will have a round image by clipping it to the bounds
    cell.specialsDetailImageView.clipsToBounds = YES;
    
    
    PFFile *thumbnail = [object objectForKey:@"image"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            // Now that the data is fetched, update the cell's image property with thumbnail
            cell.specialsDetailImageView.image = [UIImage imageWithData:data];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    // Drawing circle behind view
    //Colored Edge
    [self drawCircleBackgroundForView:cell.specialsDetailPriceCircleView
                                 edge:0.0
                              opacity:1.0
                          strokeColor:[UIColor redColor]
                            fillColor:[UIColor clearColor]
                 useCurrentSizeOfView:NO];
    //Circle itself
    [self drawCircleBackgroundForView:cell.specialsDetailPriceCircleView
                                 edge:0.0
                              opacity:0.1
                          strokeColor:[UIColor clearColor]
                            fillColor:[UIColor blackColor]
                 useCurrentSizeOfView:NO];
    
    NSLog(@"Circle bounds size %f",cell.specialsDetailPriceCircleView.bounds.size.height);
    
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
    if ([segue.identifier isEqualToString:@"showSpecialsDetailProductSegue"]) {
        // Capture the object (e.g. exam) the user has selected from the list
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        // Set destination view controller to DetailViewController to avoid the NavigationViewController in the middle (if you have it embedded into a navigation controller, if not ignore that part)
        MenuDetailProductViewController *controller = segue.destinationViewController;
        controller.object = object;
    }
}

- (void)drawCircleBackgroundForView:(UIView*)view edge:(CGFloat)edge opacity:(CGFloat)opacity strokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor useCurrentSizeOfView:(BOOL)useViewSize{
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
