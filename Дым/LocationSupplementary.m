//
//  LocationSupplementaryObject.m
//  Дым
//
//  Created by Fenkins on 16/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "LocationSupplementary.h"
@interface LocationSupplementary()
//@property NSString* storedPlaceName;
//@property NSString* storedPlaceDescription;
//@property NSString* storedPlacePlaneLocation;
//@property CLLocationCoordinate2D storedGeoPoint;
//@property NSNumber* storedPhoneNumber;
//@property NSString* storedVkontakteLink;
//@property NSString* storedInstagramLink;
//@property NSData* storedImageFile;
//@property NSNumber* storedIsEnabledOption;
@end

@implementation LocationSupplementary

- (id)initWithLocationName:(NSString *)locationName description:(NSString *)locationDescription planeLocation:(NSString *)planeLocation geoPoint:(CLLocationCoordinate2D)locationGeoPoint phoneNumber:(NSNumber *)locationPhoneNumber vkontakteLink:(NSString *)locationVkontakteLink instagramLink:(NSString *)locationInstagramLink imageFile:(NSData *)locationImageFile isEnabledOption:(NSNumber *)locationIsEnabledOption
{
    self = [super init];
    if (self) {
        self.storedPlaceName = locationName;
        NSLog(@"Initialization success! Name is %@",self.storedPlaceName);
        self.storedPlaceDescription = locationDescription;
        self.storedPlacePlaneLocation = planeLocation;
        self.storedGeoPoint = locationGeoPoint;
        self.storedPhoneNumber = locationPhoneNumber;
        self.storedVkontakteLink = locationVkontakteLink;
        self.storedInstagramLink = locationInstagramLink;
        self.storedImageFile = locationImageFile;
        self.storedIsEnabledOption = locationIsEnabledOption;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    // Encode the properties of the object
    [encoder encodeObject:self.storedPlaceName forKey:@"stored_placeName"];
    [encoder encodeObject:self.storedPlaceDescription forKey:@"stored_placeDescription"];
    [encoder encodeObject:self.storedPlacePlaneLocation forKey:@"stored_placePlaneLocation"];
    [encoder encodeDouble:self.storedGeoPoint.latitude forKey:@"stored_placeGeoPointLatitude"];
    [encoder encodeDouble:self.storedGeoPoint.longitude forKey:@"stored_placeGeoPointLongitude"];
    [encoder encodeObject:self.storedPhoneNumber forKey:@"stored_placePhoneNumber"];
    [encoder encodeObject:self.storedVkontakteLink forKey:@"stored_vkontakteLink"];
    [encoder encodeObject:self.storedInstagramLink forKey:@"stored_instagramLink"];
    [encoder encodeObject:self.storedImageFile forKey:@"stored_imageFile"];
    [encoder encodeObject:self.storedIsEnabledOption forKey:@"stored_isEnabledOption"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        // Decode properties for the object
        self.storedPlaceName = [decoder decodeObjectForKey:@"stored_placeName"];
        self.storedPlaceDescription = [decoder decodeObjectForKey:@"stored_placeDescription"];
        self.storedPlacePlaneLocation = [decoder decodeObjectForKey:@"stored_placePlaneLocation"];
        self.storedGeoPoint = CLLocationCoordinate2DMake([decoder decodeDoubleForKey:@"stored_placeGeoPointLatitude"], [decoder decodeDoubleForKey:@"stored_placeGeoPointLongitude"]);
        self.storedPhoneNumber = [decoder decodeObjectForKey:@"stored_placePhoneNumber"];
        self.storedVkontakteLink = [decoder decodeObjectForKey:@"stored_vkontakteLink"];
        self.storedInstagramLink = [decoder decodeObjectForKey:@"stored_instagramLink"];
        self.storedImageFile = [decoder decodeObjectForKey:@"stored_imageFile"];
        self.storedIsEnabledOption = [decoder decodeObjectForKey:@"stored_isEnabledOption"];
    }
    return self;
}

- (void)saveCustomObject:(LocationSupplementary *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (LocationSupplementary *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    LocationSupplementary *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
