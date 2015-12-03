//
//  SignalViewViewController.m
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 16/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//
//This class shows how to fetch car information from the Bluetooth

#import "SignalBTViewController.h"
#import "SignalTableViewCell.h"
#import "SettingsViewController.h"
#import "globals.h"
#import <XeeSDK/XeeSDK.h>




static NSArray *signalsToDisplay() {
    static NSArray *signals = NULL;
    if (signals == NULL) {
        signals = @[
        [XEECarLocation name],
        [XEECarAccelerometer name],
        [XEEAirCondSwitchSts name],
        [XEEAutoWiperSts name],
        [XEEBatteryVoltage name],
        [XEEBrakePedalPosition name],
        [XEEBrakePedalSts name],
        [XEEClutchPedalPosition name],
        [XEEClutchPedalSts name],
        [XEECoolantPressure name],
        [XEECruiseControlSts name],
        [XEEDippedBeamSts name],
        [XEEDriveMode name],
        [XEEEngineSpeed name],
        [XEEFrontFogLightSts name],
        [XEEFrontLeftDoorSts name],
        [XEEFrontLeftSeatBeltSts name],
        [XEEFrontLeftWheelSpeed name],
        [XEEFrontLeftWindowPosition name],
        [XEEFrontLeftWindowSts name],
        [XEEFrontRightDoorSts name],
        [XEEFrontRightSeatBelt name],
        [XEEFrontRightWheelSpeed name],
        [XEEFrontRightWindowPosition name],
        [XEEFrontRightWindowSts name],
        [XEEFuelCapSts name],
        [XEEFuelLevel name],
        [XEEGearPosition name],
        [XEEHandBrakeSts name],
        [XEEHazardSts name],
        [XEEHighSpeedWiperSts name],
        [XEEHoodSts name],
        [XEEIgnitionSts name],
        [XEEIndoorTemp name],
        [XEEInteriorLightSts name],
        [XEEIntermittentWiperSts name],
        [XEEKeySts name],
        [XEELeftIndicatorSts name],
        [XEELockSts name],
        [XEELowSpeedWiperSts name],
        [XEEMainBeamSts name],
        [XEEManualWiperSts name],
        [XEEOdometer name],
        [XEEOutdoorTemp name],
        [XEEParkingLightSts name],
        [XEEPassAirbagSts name],
        [XEERadioSts name],
        [XEERearFogLightSts name],
        [XEERearLeftDoorSts name],
        [XEERearLeftWheelSpeed name],
        [XEERearLeftWindowPosition name],
        [XEERearLeftWindowSts name],
        [XEERearRightDoorSts name],
        [XEERearRightWheelSpeed name],
        [XEERearRightWindowPosition name],
        [XEERearRightWindowSts name],
        [XEEReverseGearSts name],
        [XEERightIndicatorSts name],
        [XEESteeringWheelAngle name],
        [XEESteeringWheelSide name],
        [XEESunRoofSts name],
        [XEEThrottlePedalPosition name],
        [XEEThrottlePedalSts name],
        [XEETrunkSts name],
        [XEEVehicleSpeed name],
        [XEEVentilationSts name],
        [XEEWindowsLockSts name]];
    };
    return signals;
}

@interface SignalBTViewController ()
@property (strong, nonatomic) NSMutableDictionary *xeeSignals;;
@end

@implementation SignalBTViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newSignals:) name:kXEESignalNotificationName object:nil];
    
    self.xeeSignals = [NSMutableDictionary dictionary];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    
    [XEEBluetoothApi setupForXeeConnect:userId token:token];
}

- (void)viewWillAppear:(BOOL)animated {
    [XEEBluetoothApi registerForXEEConnectConnection];
    [XEEBluetoothApi setSignalFrequency:1];
}

- (void)viewDidDisappear:(BOOL)animated {
    [XEEBluetoothApi unregisterForXEEConnectConnection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [signalsToDisplay() count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = SIGNALS_CELL_ID; 
    SignalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSString *signalName = signalsToDisplay()[(NSUInteger) indexPath.row];
    
    id <XEECarSignal> signal = self.xeeSignals[signalName];
    if (signal != nil && ![signal isEqual:[NSNull null]]) {
        [cell.signalNameTextView setText:signalName];
        [cell.signalValueTextView setBackgroundColor:[UIColor greenColor]];
        [cell.signalValueTextView setText:[signal.value description]];
    } else {
        [cell.signalNameTextView setText:signalName];
        [cell.signalValueTextView setText:@""];
        [cell.signalValueTextView setBackgroundColor:[UIColor redColor]];
    }
    return cell;
    
}

- (void)newSignals:(NSNotification *)userInfo {
    NSDictionary *xeeSignal = [userInfo userInfo];
    [xeeSignal enumerateKeysAndObjectsUsingBlock:^(NSString *nameSignal, id <XEECarSignal> signal, BOOL *stop) {
        self.xeeSignals[nameSignal] = signal;
    }];
    [self.tableView reloadData]; 
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
