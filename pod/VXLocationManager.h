//
//  VXLocationManager.h
//  spacefact
//
//  Created by Graham Lancashire on 03.07.12.
//  Copyright (c) 2012 Swift Management AG, Basel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define kVXLocationAcquired @"ch.swift.vxlocationupdate"
#define kVXLocationKeyLocation @"location"
#define kVXLocationKeyState @"state"
#define kVXLocationTimeout 30.0f
#define kVXLocationDistanceFilter 100.0f

#define kVXLocationStateTimeout @"ch.swift.vxlocationstate.timeout"
#define kVXLocationStateAcquired @"ch.swift.vxlocationstate.success"
#define kVXLocationStateError @"ch.swift.vxlocationstate.error"

/*
Usage:
 // Basel:
    // Decimal Minutes (GPS) : N47 33.43295 E7 35.53776
    // Decimal (WGS84) : 47.557216, 7.592296
    // Degrees Minutes Seconds : N 47° 33' 25.977", E 7° 35' 32.2656"
 
- (void)viewDidLoad
 {
	[super viewDidLoad];
 
	// Check if there is a location
	CLLocation *location = [[VXLocationManager sharedInstance] location];
	
 	// If no location then get one
	if(location == nil) {
		// Subscribe to notifications
		[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(locationAcquired:)
                                             name:kVXLocationAcquired
                                           object:nil];
		#if (TARGET_IPHONE_SIMULATOR)
		[[VXLocationManager sharedInstance].fakeLocation = YES;
		[[VXLocationManager sharedInstance].location = [[CLLocation alloc] initWithLatitude:52.502006 longitude:13.411668];
		#endif

		[[VXLocationManager sharedInstance] startUpdatingLocationWithDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
	} else {
		[self updateLocation:location];
	}
 
}
 
 - (void)locationAcquired:(NSNotification *)pNotification {
	NSDictionary* resultDictionary = [pNotification userInfo];
 
	if(resultDictionary != nil) {
		CLLocation *location = [resultDictionary objectForKey:kVXLocationUserInfoKey];
		[self updateLocation:location];
	}

 }
 - (void)updateLocation:(CLLocation *)pLocation {
	// do something with the location (check for nil)
 
 }
 
*/
@interface VXLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, strong) NSTimer* timeoutTimer;
@property (nonatomic, strong) NSMutableArray *locationMeasurements;
@property BOOL fakeLocation;

+ (VXLocationManager*)sharedInstance; // Singleton method
- (void)startUpdatingLocationWithDesiredAccuracy:(CLLocationAccuracy)pAccuracy;
@property (NS_NONATOMIC_IOSONLY, getter=getAddress, readonly, copy) NSString *address;
+(void)logRect:(MKMapRect)pMapRect withMessage:(NSString*)pString;

@end

