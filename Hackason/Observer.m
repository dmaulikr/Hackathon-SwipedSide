//
//  Observer.m
//  Hackason
//
//  Created by oohashi on 2015/07/08.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "Observer.h"

@implementation Observer
{
    AppData *appDara;
}
- (id)init
{
    FUNC();
    if(self = [super init]) {
    }
    return [self initWith:[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"00000000-48A4-1001-B000-001C4D175E4E"] identifier:@"observeDisplayRegion"]];
}

- (id)initWith: (CLBeaconRegion *)searchBeaconRegion
{
    FUNC();
    if(self = [super init]) {
        appDara = [AppData SharedManager];
        NSLog(@"- (id)initWith: (CLBeaconRegion *)searchBeaconRegion");
        self.observer = [CLLocationManager new];
        self.observer.delegate = self;
        self.searchBeaconRegion = searchBeaconRegion;
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    FUNC();
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"kCLAuthorizationStatusNotDetermined");
    } else if(status == kCLAuthorizationStatusAuthorizedAlways) {
        // if([CLLocationManager is ])
        [manager startMonitoringForRegion:  self.searchBeaconRegion];
        NSLog(@"startMonitoringForRegion");
    } else if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
        [manager startMonitoringForRegion:  self.searchBeaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    FUNC();
    [manager requestAlwaysAuthorization];
    [manager requestWhenInUseAuthorization];
    [manager requestStateForRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    FUNC();
    switch (state) {
        case CLRegionStateInside: {
            [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        } break;
        case CLRegionStateOutside: {
            
        } break;
        case CLRegionStateUnknown: {
            
        } break;
        default: {
            
        } break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    FUNC();
    [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    NSLog(@"didEnterRegion");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    FUNC();
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    NSLog(@"didEnterRegion");
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    //FUNC();
    CLBeaconRegion *nearestBeacon = beacons.firstObject;
    appDara.nearestBeacon.major = [nearestBeacon.major intValue];
    appDara.nearestBeacon.minor = [nearestBeacon.minor intValue];
}

- (void)startMonitoringRegion
{
    FUNC();
    [self.observer startMonitoringForRegion:self.searchBeaconRegion];
}

- (void)stopMonitoringRegion
{
    FUNC();
    [self.observer stopMonitoringForRegion:self.searchBeaconRegion];
}

@end
