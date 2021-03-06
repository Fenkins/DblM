//
//  LocationChangerTableViewController.m
//  Дым
//
//  Created by Fenkins on 14/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "LocationChangerTableViewController.h"
static const NSString* kCCName = @"placeName";
static const NSString* kCCDescription = @"placeDescription";
static const NSString* kCCPlaсeLocation = @"placePlainLocation";
static const NSString* kCCGeoPoint = @"geoPoint";
static const NSString* kCCPhone = @"phoneNumber";
static const NSString* kCCVkontakte = @"vkLink";
static const NSString* kCCInstagram = @"instagramLink";
static const NSString* kCCisEnabled = @"enabled";
static const NSString* kCCimage = @"image";

@interface LocationChangerTableViewController ()

@end

@implementation LocationChangerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:TRUE];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                    target:self
                                    action:@selector(dismissVC)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {

}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Locations";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = (NSString*)kCCName;
        
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
    [query whereKey:(NSString*)kCCisEnabled equalTo:[NSNumber numberWithBool:YES]];
    
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *simpleTableIdentifier = @"placeCellID";
    
    LocationPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[LocationPlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    // Cell colors
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:153/255.0 green:143/255.0 blue:61/255.0 alpha:0.1];
    [cell setSelectedBackgroundView:bgColorView];
    
    //  Configure the cell to show title and description
    cell.locationName.text = [object objectForKey:(NSString*)kCCName];
    cell.locationDescription.text = [object objectForKey:(NSString*)kCCDescription];
    
    //  Configure cell to show photo placeholder and thumbnail
    //  Set your placeholder image first
    cell.locationImage.image = [UIImage imageNamed:@"placeholder"];
    cell.locationImage.backgroundColor = [UIColor blackColor];
    
    PFFile *thumbnail = [object objectForKey:(NSString*)kCCimage];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            // Now that the data is fetched, update the cell's image property with thumbnail
            cell.locationImage.image = [UIImage imageWithData:data];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"%ld",(long)indexPath.row);
    [self dismissVC:^(BOOL finished) {
        if (finished) {
            PFObject *object = [self.objects objectAtIndex:indexPath.row];
            
            // Extracting and preparing geopoint to pass it to object
            PFGeoPoint* geoPoint = [object objectForKey:(NSString*)kCCGeoPoint];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
            // Preparing image data
            PFFile *image = [object objectForKey:(NSString*)kCCimage];
            NSData* imageData = [image getData];
            
            
            //  Creating custom class object to put our PFObject there for further archive/unarchive procedures
            
            LocationSupplementary *suppObject = [[LocationSupplementary alloc]
                                                 initWithLocationName:[object objectForKey:(NSString*)kCCName]
                                                 description:[object objectForKey:(NSString*)kCCDescription]
                                                 planeLocation:[object objectForKey:(NSString*)kCCPlaсeLocation]
                                                 geoPoint:location
                                                 phoneNumber:[object objectForKey:(NSString*)kCCPhone]
                                                 vkontakteLink:[object objectForKey:(NSString*)kCCVkontakte]
                                                 instagramLink:[object objectForKey:(NSString*)kCCInstagram]
                                                 imageFile:imageData
                                                 isEnabledOption:[object objectForKey:(NSString*)kCCisEnabled]];
            
            //  Writing the object to defaults
            
            [LocationSupplementary saveCustomObject:suppObject key:@"StoredLocation"];
            [suppObject locationHasBeenSet];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

typedef void (^completion)(BOOL finished);
- (void)dismissVC:(completion)finished {
    //  We want a customised animation, so we doing that like this:
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];    
    [self.navigationController popViewControllerAnimated:YES];
    finished(YES);
}

- (void)dismissVC {
    //  We want a customised animation, so we doing that like this:
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
