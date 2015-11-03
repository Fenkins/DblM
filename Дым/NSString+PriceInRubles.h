//
//  NSString+PriceInRubles.h
//  Дым
//
//  Created by Fenkins on 04/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PriceInRubles)
// ALL HEIL TO RUBL SIGN!
+ (NSString *)priceWithCurrencySymbol:(NSNumber*)price kopeikasEnabled:(BOOL)enabled;
@end