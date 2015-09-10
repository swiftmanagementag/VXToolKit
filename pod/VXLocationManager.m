//
//  VXLocationManager.m
//  spacefact
//
//  Created by Graham Lancashire on 03.07.12.
//  Copyright (c) 2012 Swift Management AG, Basel. All rights reserved.
//

#import "VXLocationManager.h"


@implementation VXLocationManager

- (instancetype)init
{
 	self = [super init];
	if (self != nil) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])	{
			NSUInteger code = [CLLocationManager authorizationStatus];
			if (code == kCLAuthorizationStatusNotDetermined ) {
				[self.locationManager requestWhenInUseAuthorization];
			}
		}
		// initialise
		self.fakeLocation = NO;
		self.location = nil;
		self.locationMeasurements = [NSMutableArray array];
	}
	return self;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager*)manager
	didUpdateToLocation:(CLLocation*)newLocation
		   fromLocation:(CLLocation*)oldLocation
{
	// store all of the measurements, just so we can see what kind of data we might receive
    [self.locationMeasurements addObject:newLocation];
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
	
    if (locationAge > 5.0) return;
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (self.location == nil || self.location.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.location = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:kVXLocationStateAcquired];
			
        }
    }

}

- (void)startUpdatingLocationWithDesiredAccuracy:(CLLocationAccuracy)pAccuracy {
	// This is the most important property to set for the manager. It ultimately determines how the manager will
	// attempt to acquire location and thus, the amount of power that will be consumed.

	if(self.fakeLocation == YES && self.location != nil) {
		[self performSelector:@selector(stopUpdatingLocation:) withObject:kVXLocationStateAcquired afterDelay:0.1f];
	} else if (self.timeoutTimer == nil) {
		self.locationManager.desiredAccuracy = pAccuracy; // kCLLocationAccuracyThreeKilometers;
		self.locationManager.distanceFilter = kVXLocationDistanceFilter;

		// Once configured, the location manager must be "started".
		[self.locationManager startUpdatingLocation];
		self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kVXLocationTimeout target:self selector:@selector(stopUpdatingLocation:) userInfo:nil repeats:NO];

		NSLog(@"Self before: %@",self); 
	}
}

- (void)locationManager:(CLLocationManager*)manager
	   didFailWithError:(NSError*)error
{
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
	
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:kVXLocationStateError];
    }
	
}
- (void)stopUpdatingLocation:(NSString *)pState {
	NSLog(@"Self after: %@",self); 
    
	// we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
	if(self.timeoutTimer != nil) {
		[self.timeoutTimer invalidate];
		self.timeoutTimer = nil;
	}

    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
	
    // update the display with the new location data
	if(pState == nil || ![pState isKindOfClass:[NSString class]] || [pState isEqualToString:kVXLocationStateTimeout] || [pState isEqualToString:kVXLocationStateError]) {
		if(pState == nil || ![pState isKindOfClass:[NSString class]]) {
			pState = kVXLocationStateTimeout;
		}
		self.location = [pState isEqualToString:kVXLocationStateTimeout] ? self.location : nil ;
	}

	NSDictionary *resultDictionary = @{};
		
	if(self.location) {
		resultDictionary = @{kVXLocationKeyLocation: self.location, kVXLocationKeyState: pState};
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:kVXLocationAcquired
														object:self
													  userInfo:resultDictionary];

}

#define kGeoCodingString @"http://maps.google.com/maps/geo?q=%f,%f&output=csv" //define this at top

-(NSString *)getAddress {
	NSString *locationString = @"";
	
	if(self.location != nil) {
		NSString *urlString = [NSString stringWithFormat:kGeoCodingString,self.location.coordinate.latitude,self.location.coordinate.longitude];
		NSError* error;
		locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
		locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		locationString =  [locationString substringFromIndex:6];
	}
	return locationString;
	
}
+(void)logRect:(MKMapRect)pMapRect withMessage:(NSString*)pString{
#ifdef DEBUG_MODE
	MKMapPoint upperRightMapPoint = MKMapPointMake(MKMapRectGetMaxX(pMapRect), pMapRect.origin.y);
	MKMapPoint lowerLeftMapPoint = MKMapPointMake(pMapRect.origin.x, MKMapRectGetMaxY(pMapRect));
    
	CLLocationCoordinate2D upperRightCoordinate = MKCoordinateForMapPoint(upperRightMapPoint);
	CLLocationCoordinate2D lowerLeftCoordinate = MKCoordinateForMapPoint(lowerLeftMapPoint);
    
	DebugLog(@"%@ UR %f, %f LL %f, %f", pString, upperRightCoordinate.latitude, upperRightCoordinate.longitude, lowerLeftCoordinate.latitude, lowerLeftCoordinate.longitude);
#endif
}
- (void)locationManager:(CLLocationManager*) manager didChangeAuthorizationStatus:(CLAuthorizationStatus) status {
	if (status == kCLAuthorizationStatusAuthorized) {
		[self startUpdatingLocationWithDesiredAccuracy:self.locationManager.desiredAccuracy];
	}
}

#pragma mark -
#pragma mark - Singleton implementation in ARC
+ (VXLocationManager *)sharedInstance
{
	static VXLocationManager *sharedLocationControllerInstance = nil;
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
		sharedLocationControllerInstance = [[self alloc] init];
	});
	return sharedLocationControllerInstance;
}

@end
