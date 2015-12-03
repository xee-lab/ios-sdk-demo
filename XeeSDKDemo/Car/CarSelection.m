//
//  XEEcarConfig.m
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 26/11/2015.
//  Copyright © 2015 Eliocity. All rights reserved.
//
// This class shows how to fetch car information from the API


#import "CarSelection.h"
#import <UIKit/UIKit.h>
#import <XeeSDK/XeeSDK.h>
#import "globals.h"

@implementation CarSelection


+(void) carWith:(NSString*)userId accessToken:(NSString*)accessToken with:(id<CarSelectionDelegate>) delegate hostViewController:(UIViewController*) viewController{
    
    // Fetch the cars for the user from the API and continue
    [XEECarApi carsWithUserId:userId token:accessToken].then(^(NSArray * xeeCar){
        UIAlertController * view = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"car_list", nil) message:NSLocalizedString(@"car_choice", nil) preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (XEECar * car in xeeCar) {
            UIAlertAction* actionAlert = [UIAlertAction actionWithTitle:car.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [[NSUserDefaults standardUserDefaults] setInteger:car.id.integerValue forKey:CAR_ID]; 
                [[NSUserDefaults standardUserDefaults] synchronize];
                [delegate carSelected:car];
            }];
            [view addAction:actionAlert];
        }
        [viewController presentViewController:view animated:YES completion:nil]; 
    }).catch(^(NSError * error){
        [self catchError:error];
    });
}

+(void) catchError:(NSError*) error{
    int code =(int)[error.userInfo[@"com.alamofire.serialization.response.error.response"] statusCode];
    if (code == 403) {
        NSString * refreshTokenApp = [[NSUserDefaults standardUserDefaults] objectForKey:REFRESH_TOKEN];
        [XEEAuthentication refreshToken:refreshTokenApp].then(^(XEEToken * token){
            [[NSUserDefaults standardUserDefaults] setObject:token.accessToken forKey:ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:token.refreshToken forKey:REFRESH_TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }).catch(^(NSError * error){
            [self showError:error];
        });
    }else{
        [self showError:error];
    }
}

+(void) showError:(NSError *) error{
    NSLog(@" Code error %i ",(int) error.code);
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:NSLocalizedString(@"error", nil)
                           message:[NSString stringWithFormat:@"%@", error]
                           delegate:nil cancelButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
    [alert show];
}


@end
