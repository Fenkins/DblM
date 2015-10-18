//
//  LocationSupplementaryObject.h
//  Дым
//
//  Created by Fenkins on 16/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationSupplementary : NSObject <NSCoding>

@property (nonatomic) NSString* storedPlaceName;
@property (nonatomic) NSString* storedPlaceDescription;
@property (nonatomic) NSString* storedPlacePlaneLocation;
@property (nonatomic) CLLocationCoordinate2D storedGeoPoint;
@property (nonatomic) NSNumber* storedPhoneNumber;
@property (nonatomic) NSString* storedVkontakteLink;
@property (nonatomic) NSString* storedInstagramLink;
@property (nonatomic) NSData* storedImageFile;
@property (nonatomic) NSNumber* storedIsEnabledOption;


-(id)initWithLocationName:(NSString*)locationName
              description:(NSString*)locationDescription
            planeLocation:(NSString*)planeLocation
                 geoPoint:(CLLocationCoordinate2D)locationGeoPoint
              phoneNumber:(NSNumber*)locationPhoneNumber
            vkontakteLink:(NSString*)locationVkontakteLink
            instagramLink:(NSString*)locationInstagramLink
                imageFile:(NSData*)locationImageFile
          isEnabledOption:(NSNumber*)locationIsEnabledOption;
-(void)encodeWithCoder:(NSCoder*)encoder;
-(id)initWithCoder:(NSCoder*)decoder;

+ (void)saveCustomObject:(LocationSupplementary *)object key:(NSString *)key;
+ (LocationSupplementary *)loadCustomObjectWithKey:(NSString *)key;
@end
