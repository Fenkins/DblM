//
//  NSString+StringsFromNumbers.h
//  Дым
//
//  Created by Fenkins on 02/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringsFromNumbers)
+(NSString*)stringWithStartTime:(NSNumber*)startTime;
+(NSString*)stringWithEndTime:(NSNumber*)endTime;
+(NSString*)stringWithDayOfWeekNumber:(NSNumber*)dayOfWeekNumber;
@end
