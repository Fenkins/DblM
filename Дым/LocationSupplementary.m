//
//  LocationSupplementary.m
//  Дым
//
//  Created by Fenkins on 15/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "LocationSupplementary.h"
static const NSString* kCClocationObjectName;
@implementation LocationSupplementary
-(BOOL)checkIfLocationObjectExist {
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:(NSString*)kCClocationObjectName]isKindOfClass:[PFObject class]]) {
        return true;
    } else {
        return false;
    }
}
-(void)storeLocationDataObject:(PFObject *)object {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [[NSUserDefaults standardUserDefaults]setObject:object forKey:(NSString*)kCClocationObjectName];
    [[NSUserDefaults standardUserDefaults]synchronize];
        });
}
@end
