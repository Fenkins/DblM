//
//  ContactsTimeSupplementary.h
//  Дым
//
//  Created by Fenkins on 11/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse.h>
#import <Bolts.h>
#import "LocationSupplementary.h"

@interface ContactsSheduleSupplementary : NSObject

// Initializing class with date - setting up a suppliedDate and currentDate
-(id)initWithDate:(NSDate*)date;
// Triggers the query to db that updates the stored shedule string
-(void)queryForShedule:(NSDate*)date;
// Checks if the stored shedule valid
-(BOOL)isTodaysSheduleValid;
// Loads the string with our desired shedule
-(NSString*)loadTodaysSheduleQuery;
@end
