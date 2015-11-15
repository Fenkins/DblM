//
//  OurTeamCollectionViewController.m
//  Дым
//
//  Created by Fenkins on 19/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsOurTeamCollectionViewController.h"

@interface ContactsOurTeamCollectionViewController ()

@end

@implementation ContactsOurTeamCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Calculating cell size
    #define kCellsPerRow 2
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.collectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / kCellsPerRow;
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    // Changing colors of the PFLoadingView
    [self changePFLoadingViewLabelTextColor:[UIColor whiteColor] shadowColor:[UIColor darkGrayColor]];
    
    // Adding background UIImageView to a table
    UIImageView *backgroundImageLayer = [[UIImageView alloc]
                                         initWithImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    backgroundImageLayer.layer.zPosition = -1.0;
    [backgroundImageLayer setFrame:self.collectionView.frame];
    // This way our image wont fool around/hang out betweet transitions    
    backgroundImageLayer.clipsToBounds = YES;
    [backgroundImageLayer setContentMode:UIViewContentModeScaleAspectFill];
    self.collectionView.backgroundView = backgroundImageLayer;
    
    UIImage *blurredImage = [UIImage blurryGPUImage:[UIImage imageNamed:@"backgroundLayer.jpg"]];
    
    backgroundImageLayer.image = blurredImage;
    // This way our image wont fool around/hang out betweet transitions
    
    // Adding layer of dark and blur
    [backgroundImageLayer applyDarkBackground];
}

-(void)viewWillLayoutSubviews {
    self.collectionView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height*3/2, 0, self.tabBarController.tabBar.bounds.size.height, 0);
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
        self.parseClassName = @"StuffMembers";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForCollection
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

-(PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *simpleTableIdentifier = @"teamMemberCell";
    
    ContactsOurTeamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ContactsOurTeamCollectionViewCell alloc] init];
    }
    
    // Cell colors
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:153/255.0 green:143/255.0 blue:61/255.0 alpha:0.1];
    [cell setSelectedBackgroundView:bgColorView];
    
    //  Configure the cell to show title and description
    cell.teamMemberNameLabel.text = [object objectForKey:@"name"];
    cell.teamMemberPositionLabel.text = [object objectForKey:@"position"];
    
    //  Configure cell to show photo placeholder and thumbnail
    //  Set your placeholder image first
    cell.teamMemberImage.image = [UIImage imageNamed:@"placeholder"];
    cell.teamMemberImage.backgroundColor = [UIColor blackColor];
    [cell.teamMemberImage setContentMode:UIViewContentModeScaleAspectFill];
    //  Making sure we will have a round image by clipping it to the bounds
    cell.teamMemberImage.clipsToBounds = YES;
    
    //  Making it nice and round
    cell.teamMemberImage.layer.cornerRadius = cell.teamMemberImage.bounds.size.width/2;
    //  Turning it on, to increase performance
    cell.teamMemberImage.layer.shouldRasterize = YES;
    
    
    PFFile *thumbnail = [object objectForKey:@"image"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            // Now that the data is fetched, update the cell's image property with thumbnail
            cell.teamMemberImage.image = [UIImage imageWithData:data];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([segue.identifier isEqualToString:@"ourTeamDetailSegueID"]) {
 // Capture the object (e.g. exam) the user has selected from the list
     if ([sender isKindOfClass:[ContactsOurTeamCollectionViewCell class]]) {
         ContactsOurTeamCollectionViewCell *cell = sender;
         NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
         PFObject *object = [self.objects objectAtIndex:indexPath.row];
         
         // Set destination view controller to DetailViewController to avoid the NavigationViewController in the middle (if you have it embedded into a navigation controller, if not ignore that part)
         ContactsOurTeamDetailViewController *controller = segue.destinationViewController;
         controller.object = object;
     } else {
         NSLog(@"Incorrect cell feeded as sender in ContactsOurTeamCollectionViewController");
     }
}
}

@end
