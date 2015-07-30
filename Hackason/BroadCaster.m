//
//  BroadCaster.m
//  Hackason
//
//  Created by oohashi on 2015/07/07.
//  Copyright (c) 2015年 Yasuhiro.Hashimoto. All rights reserved.
//

#import "BroadCaster.h"

@implementation BroadCaster
{
    
}

+ (BroadCaster *)SharedManerger
{
    FUNC();
    static BroadCaster *Singleton;
    static dispatch_once_t once;
    
    dispatch_once( &once, ^{
        Singleton = [[BroadCaster alloc] init];
    });
    
    return Singleton;
}

- (void)setWithUUID: (NSString *)uuid
            major: (NSString *)major
            minor: (NSString *)minor
       identifier: (NSString *)identifier
{
    FUNC();
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid]
                                                                major:[major intValue]
                                                                minor:[minor intValue]
                                                           identifier:identifier];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    FUNC();
    NSString *message;
    
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOff:
            message = @"電源OFF";
            break;
        case CBPeripheralManagerStatePoweredOn:
            message = @"電源ON";
            break;
        case CBPeripheralManagerStateResetting:
            message = @"リセット";
            break;
        case CBPeripheralManagerStateUnauthorized:
            message = @"許可されていません";
            break;
        case CBPeripheralManagerStateUnknown:
            message = @"不明";
            break;
        case CBPeripheralManagerStateUnsupported:
            message = @"サポート対象外";
            break;
            
        default:
            break;
    }
    NSLog(@"%@", message);
}

- (void)startBroadCast
{
    FUNC();
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheralManager startAdvertising:[self.beaconRegion peripheralDataWithMeasuredPower:nil]];
        NSLog(@"startBroadCast");
    } else {
        NSLog(@"startBroadCast: ERROR");
        [self.peripheralManager startAdvertising:[self.beaconRegion peripheralDataWithMeasuredPower:nil]];

    }
}

- (void)stopBroadCast
{
    FUNC();
    [self.peripheralManager startAdvertising:[self.beaconRegion peripheralDataWithMeasuredPower:nil]];
    NSLog(@"stopBroadCast");
}

@end
