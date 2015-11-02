//
//  NSString+StringsFromNumbers.m
//  Дым
//
//  Created by Fenkins on 02/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "NSString+StringsFromNumbers.h"

@implementation NSString (StringsFromNumbers)
+(NSString*)stringWithStartTime:(NSNumber*)startTime {
    NSString* tempTimeString = [NSString stringWithFormat:@"%@",startTime];
    NSString* startTimeString = [NSString stringWithFormat:@"%@:%@",
        [tempTimeString substringToIndex:[tempTimeString length]-2],
        [tempTimeString substringFromIndex:[tempTimeString length]-2]];
    return startTimeString;
}
+(NSString*)stringWithEndTime:(NSNumber*)endTime {
    NSString* tempTimeString = [NSString stringWithFormat:@"%@",endTime];
    NSString* endTimeString = [NSString stringWithFormat:@"%@:%@",
        [tempTimeString substringToIndex:[tempTimeString length]-2],
        [tempTimeString substringFromIndex:[tempTimeString length]-2]];
    return endTimeString;
}
+(NSString*)stringWithDayOfWeekNumber:(NSNumber*)dayOfWeekNumber {    
    switch ([dayOfWeekNumber intValue]) {
        case 1:
            return @"Вс";
            break;
        case 2:
            return @"Пн";
            break;
        case 3:
            return @"Вт";
            break;
        case 4:
            return @"Ср";
            break;
        case 5:
            return @"Чт";
            break;
        case 6:
            return @"Пт";
            break;
        case 7:
            return @"Сб";
            break;
        default:
            return @"-";
            break;
    }
}
@end


//            NSString* startTimeString = [NSString stringWithFormat:@"%@",
//                                         [object objectForKey:(NSString*)kCCStartTime]];
//            NSString* endTimeString = [NSString stringWithFormat:@"%@",
//                                       [object objectForKey:(NSString*)kCCEndTime]];
//            // Formatting the strings to HH:MM format
//            NSString* startTimeFormatted = [NSString stringWithFormat:@"%@:%@",
//                                            [startTimeString substringToIndex:[startTimeString length]-2],
//                                            [startTimeString substringFromIndex:[startTimeString length]-2]];
//            // Formatting the strings to HH:MM format
//            NSString* endTimeFormatted = [NSString stringWithFormat:@"%@:%@",
//                                          [endTimeString substringToIndex:[endTimeString length]-2],
//                                          [endTimeString substringFromIndex:[endTimeString length]-2]];
//            NSString* sheduleString = [NSString stringWithFormat:
//                                       @"Сегодня мы работаем с %@ до %@",
//                                       startTimeFormatted,
//                                       endTimeFormatted];
//            [[NSUserDefaults standardUserDefaults]setObject:sheduleString forKey:@"sheduleForDayNumber"];
//            [[NSUserDefaults standardUserDefaults]setObject:weekdayNBR forKey:@"weekDayNumber"];
//            [[NSUserDefaults standardUserDefaults]synchronize];