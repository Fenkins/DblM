//
//  ContactsTimeSupplementary.m
//  Дым
//
//  Created by Fenkins on 11/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsSheduleSupplementary.h"
static const NSString* kCCSheduleClassName = @"Shedule";
static const NSString* kCCDayIndex = @"dayIndex";
static const NSString* kCCStartTime = @"startTime";
static const NSString* kCCEndTime = @"endTime";

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
    NSLog(@"What day is it? %i",weekday);
    
    // Query for shedule
    PFQuery *query = [PFQuery queryWithClassName:(NSString*)kCCSheduleClassName];
    [query whereKey:(NSString*)kCCDayIndex equalTo:weekdayNBR];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        NSString* sheduleString = [NSString stringWithFormat:
                                   @"Сегодня мы работаем с %@ до %@",
                                   [object objectForKey:(NSString*)kCCStartTime],
                                   [object objectForKey:(NSString*)kCCEndTime]];
        [[NSUserDefaults standardUserDefaults]setObject:sheduleString forKey:@"sheduleForDayNumber"];
        [[NSUserDefaults standardUserDefaults]setObject:weekdayNBR forKey:@"weekDayNumber"];
        [[NSUserDefaults standardUserDefaults]synchronize];
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
