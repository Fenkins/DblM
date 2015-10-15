//
//  LocationSupplementary.h
//  Дым
//
//  Created by Fenkins on 15/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse.h>
#import <Bolts.h>

@interface LocationSupplementary : NSObject
// This will store the chosen object to the NSUserDefaults
-(void)storeLocationDataObject:(PFObject*)object;
// This will check if the location object exist
-(BOOL)checkIfLocationObjectExist;

@end
