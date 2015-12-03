//
//  XeeIntializer.m
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 25/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//

#import "XeeIntializer.h"
#import <XeeSDK/XeeSDK.h>
#import "Persist.h"
#import "Credential.h"

NSString * const kCallBackUri = @"http://localhost";

@implementation XeeIntializer

//initialise xee
+(void) setupWithClient:(XEEClient*) client{
    client.callbackUri = kCallBackUri;
    client.environment = XEEEnvironmentStaging;
    [XEE setup:client];
    [XEEBluetoothApi registerForXEEConnectConnection];
    [XEEBluetoothApi setSignalFrequency:1]; 
}

@end
