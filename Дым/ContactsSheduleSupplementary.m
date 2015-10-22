//
//  ContactsTimeSupplementary.m
//  Дым
//
//  Created by Fenkins on 11/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsSheduleSupplementary.h"
static const NSString* kCCSheduleClassName = @"Schedule";
static const NSString* kCCDayIndex = @"dayIndex";
static const NSString* kCCStartTime = @"startTime";
static const NSString* kCCEndTime = @"endTime";

@interface ContactsSheduleSupplementary()
// Using current date to store date received when class is loaded
@property (nonatomic) NSDate* currentDate;
// Using supplied date to store date received as an argument
@property (nonatomic) NSDate* suppliedDate;
@end

@implementation ContactsSheduleSupplementary

-(id)initWithDate:(NSDate*)date {
    self = [super init];
    if (self) {
        self.suppliedDate = date;
        self.currentDate = [NSDate date];
    }
    return self;
}

-(void)queryForShedule:(NSDate*)date {
    // What day is it?
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [dateComps weekday];
    NSNumber* weekdayNBR = [NSNumber numberWithInteger:weekday];
    NSLog(@"What day is it? %li",(long)weekday);
    
    // Query for shedule
    PFQuery *query = [PFQuery queryWithClassName:(NSString*)kCCSheduleClassName];
    [query whereKey:(NSString*)kCCDayIndex equalTo:weekdayNBR];
    // Adding location check to query
    LocationSupplementary *suppObject = [LocationSupplementary loadCustomObjectWithKey:@"StoredLocation"];
    if ([suppObject isLocationSet]) {
        [query whereKey:@"availibleAt" equalTo:suppObject.storedPlaceName];
    }

    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {

        if ([[object objectForKey:(NSString*)kCCStartTime] isKindOfClass:[NSNumber class]] ||
            [[object objectForKey:(NSString*)kCCEndTime] isKindOfClass:[NSNumber class]]) {
            NSString* startTimeString = [NSString stringWithFormat:@"%@",
                                         [object objectForKey:(NSString*)kCCStartTime]];
            NSString* endTimeString = [NSString stringWithFormat:@"%@",
                                       [object objectForKey:(NSString*)kCCEndTime]];
            // Formatting the strings to HH:MM format
            NSString* startTimeFormatted = [NSString stringWithFormat:@"%@:%@",
                                            [startTimeString substringToIndex:[startTimeString length]-2],
                                            [startTimeString substringFromIndex:[startTimeString length]-2]];
            // Formatting the strings to HH:MM format
            NSString* endTimeFormatted = [NSString stringWithFormat:@"%@:%@",
                                          [endTimeString substringToIndex:[endTimeString length]-2],
                                          [endTimeString substringFromIndex:[endTimeString length]-2]];
            NSString* sheduleString = [NSString stringWithFormat:
                                       @"Сегодня мы работаем с %@ до %@",
                                       startTimeFormatted,
                                       endTimeFormatted];
            [[NSUserDefaults standardUserDefaults]setObject:sheduleString forKey:@"sheduleForDayNumber"];
            [[NSUserDefaults standardUserDefaults]setObject:weekdayNBR forKey:@"weekDayNumber"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        } else {
            NSLog(@"Not able to retrieve schedule from server and store it in NSUserDefaults");
        }
    }];
}


-(BOOL)isTodaysSheduleValid {
    NSNumber *weekDayStored = [[NSUserDefaults standardUserDefaults]objectForKey:@"weekDayNumber"];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [dateComps weekday];
    NSNumber* weekdayNBR = [NSNumber numberWithInteger:weekday];
    
    if (weekDayStored == weekdayNBR) {
        return YES;
    } else {
        return NO;
    }
}

-(NSString*)loadTodaysSheduleQuery {
    NSString* queryString = [[NSUserDefaults standardUserDefaults]objectForKey:@"sheduleForDayNumber"];
    return queryString;
}

@end
