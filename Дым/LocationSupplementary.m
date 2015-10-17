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

- (void)saveCustomObject:(LocationSupplementaryObject *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (LocationSupplementaryObject *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    LocationSupplementaryObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}


@end
