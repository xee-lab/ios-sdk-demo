//
//  CarViewController.m
//
//
//  Created by ruben BOBOTI on 16/09/2015.
//
//
//This controller shows car information from the API


#import "CarViewController.h"
#import <XeeSDK/XeeSDK.h>
#import "CarSelection.h"
#import "globals.h"

@interface CarViewController () <UIActionSheetDelegate, CarSelectionDelegate>

@property (strong, nonatomic) NSString * accessToken, * userId;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *plateNumberLabel;

@end

@implementation CarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    
    //Fetch the cars list from the API and select car you need
    [CarSelection carWith:self.userId accessToken:self.accessToken with:self hostViewController:self];
}

#pragma mark- car config delegate
//Show the car information on the screen
-(void)carSelected:(XEECar *)car{
    self.nameLabel.text =  car.name;
    self.brandLabel.text = car.brand;
    self.modelLabel.text = car.model;
    self.yearLabel.text = [NSString stringWithFormat:@" %@", car.year];
    self.plateNumberLabel.text = car.plateNumber;
}
@end
