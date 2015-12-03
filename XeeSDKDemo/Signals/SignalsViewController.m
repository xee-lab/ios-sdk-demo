//
//  SignalsViewController.m
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 20/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//
/**
 * Fetch car information on the the API and show the first one.
 */

#import "SignalsViewController.h"
#import <XeeSDK/XeeSDK.h>
#import "CarSelection.h"
#import "globals.h"


@interface SignalsViewController () <CarSelectionDelegate>

@property (strong, nonatomic) NSString * accessToken, *carId;

@property(weak, nonatomic) IBOutlet UILabel *engineSpeedLabel;
@property(weak, nonatomic) IBOutlet IBOutlet UILabel *vehicleSpeedLabel;
@property(weak, nonatomic) IBOutlet IBOutlet UILabel *fuelLabel;
@property(weak, nonatomic) IBOutlet IBOutlet UILabel *odometerLabel;
@property(weak, nonatomic) IBOutlet IBOutlet UILabel *locationLabel;
@property(weak, nonatomic) IBOutlet IBOutlet UILabel *accelerometerLabel;

@end

@implementation SignalsViewController

@synthesize engineSpeedLabel;
@synthesize vehicleSpeedLabel;
@synthesize fuelLabel;
@synthesize odometerLabel;
@synthesize locationLabel;
@synthesize accelerometerLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    
    [CarSelection carWith:userId accessToken:self.accessToken with:self hostViewController:self];
}

-(void)carSelected:(XEECar *)car{
    self.carId = [[[NSUserDefaults standardUserDefaults] objectForKey:CAR_ID] stringValue];
}

//Fetch fuelLevel from the car status
- (IBAction)getFuelLevel:(id)sender {
    [XEESignalsApi signalsDictBySignals:nil carId:self.carId token:self.accessToken].then(^(NSDictionary * carStatusSignals){
        XEEFuelLevel * fuel = [carStatusSignals objectForKey:[XEEFuelLevel name]];
        self.fuelLabel.text = [NSString stringWithFormat:@"%@",fuel.value];
    }).catch(^(NSError * error){
        [self showError:error];
    });
}

-(void) showError:(NSError *) error{
    NSLog(@" Code error %i ",(int) error.code);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
    [alert show];
}

//Fetch vehicleSpeed from the car status
- (IBAction)getVehicleSpeed:(id)sender {
    [XEESignalsApi signalsDictBySignals:nil carId:self.carId token:self.accessToken].then(^(NSDictionary * carStatusSignals){
        XEEVehicleSpeed * speed;
        if ((speed = [carStatusSignals objectForKey:[XEEVehicleSpeed name]]) != nil) {
            self.vehicleSpeedLabel.text = [NSString stringWithFormat:@"%@",speed.value];
        }else{
            self.vehicleSpeedLabel.text = NSLocalizedString(@"speed_not_found", nil);
        }
    }).catch(^(NSError * error){
        [self showError:error];
    });
}

//Fetch EngineSpeed from the car status
- (IBAction)getEngineSpeed:(id)sender {
    [XEESignalsApi signalsDictBySignals:nil carId:self.carId token:self.accessToken].then(^(NSDictionary * carStatusSignals){
        XEEEngineSpeed * engine;
        if ((engine = [carStatusSignals objectForKey:[XEEEngineSpeed name]]) != nil) {
            self.engineSpeedLabel.text = [NSString stringWithFormat:@"%@",engine.value];
        }else{
            self.engineSpeedLabel.text = NSLocalizedString(@"engine_not_found", nil);
        }
    }).catch(^(NSError * error){
        [self showError:error];
    });
}

//Fetch odometer from the car status
- (IBAction)getOdometer:(id)sender {
    [XEESignalsApi signalsDictBySignals:nil carId:self.carId token:self.accessToken].then(^(NSDictionary * carStatusSignals){
        XEEOdometer * odometer;
        if ((odometer = [carStatusSignals objectForKey:[XEEOdometer name]]) != nil) {
            self.odometerLabel.text = [NSString stringWithFormat:@"%@ Km",odometer.value];
        }else{
            self.odometerLabel.text = NSLocalizedString(@"odometer_not_found", nil);
        }
    }).catch(^(NSError * error){
        [self showError:error];
    });
}

//Fetch last car location from the car status
- (IBAction)getLastLocation:(id)sender {
    [XEESignalsApi signalsDictBySignals:nil carId:self.carId token:self.accessToken].then(^(NSDictionary * carStatusSignals){
        XEECarLocation * location;
        if ((location = [carStatusSignals objectForKey:[XEECarLocation name]]) != nil) {
            [self.locationLabel setText:[NSString stringWithFormat:@" x: %@ - y: %@ ",location.value.longitude, location.value.latitude]];
        }else{
            self.locationLabel.text = NSLocalizedString(@"location_not_found", nil);
        }
    }).catch(^(NSError * error){
        [self showError:error];
    });
}

//Fetch last car accelerometer value from the car status
- (IBAction)getAccelerometer:(id)sender {
    [XEESignalsApi signalsDictBySignals:nil carId:self.carId token:self.accessToken].then(^(NSDictionary * carStatusSignals){
        XEECarAccelerometer * acc;
        if ((acc = [carStatusSignals objectForKey:[XEECarAccelerometer name]]) != nil) {
            [self.accelerometerLabel setText:[NSString stringWithFormat:@" x: %@ - y: %@ - z: %@", acc.value.x, acc.value.y, acc.value.z]];
        }else{
            self.accelerometerLabel.text = NSLocalizedString(@"accelerometer_not_found", nil);
        }
    }).catch(^(NSError * error){
        [self showError:error]; 
    });
}
@end
