//
//  NSString+PriceInRubles.m
//  Дым
//
//  Created by Fenkins on 04/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "NSString+PriceInRubles.h"

@implementation NSString (PriceInRubles)
// ALL HEIL TO RUBL SIGN!
+ (NSString *)priceWithCurrencySymbol:(NSNumber*)price kopeikasEnabled:(BOOL)enabled{
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    enabled ? [numberFormatter setMaximumFractionDigits:2] : [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setCurrencyCode:@"RUB"];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ru"]];
    
    NSString * productPrice = [numberFormatter stringFromNumber:price];
    
    return productPrice;
    
}
@end
