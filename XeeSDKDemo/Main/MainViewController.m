//
//  MainViewController.m
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 15/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//

#import "MainViewController.h"
#import "Persist.h"
#import <XeeSDK/XEESdk.h>
#import "SettingsViewController.h"
#import "globals.h"
#import "Credential.h"


@interface MainViewController ()<XEEAuthDelegate>

@end

@implementation MainViewController

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //Get user credentials
    Credential * cred = [[Persist sharedInstance] credentials];
    if (cred.clientID == nil || [cred.clientID isEqualToString:@""] || [cred.clientSecret isEqualToString:@""] || cred.clientSecret == nil ){
        UINavigationController * nav = (UINavigationController*)[[UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"settingNav"];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        if([[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN] == nil){
            //Authenticte user
            [XEEAuthentication authenticateWithHostViewController:self andDelegate:self];
        }
    }
}


#pragma mark - XEE Delegate Methods
-(void)success:(XEEToken *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token.accessToken forKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:token.refreshToken forKey:REFRESH_TOKEN];
    // GET User
    [XEEUserApi userWithToken:token.accessToken].then(^(XEEUser * xeeUser){
        [[NSUserDefaults standardUserDefaults] setInteger:xeeUser.id.integerValue forKey:USER_ID];
    });
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) error:(NSError *)error{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:NSLocalizedString(@"error", nil)
                           message:[NSString stringWithFormat:@"Code error %i",(int) error.code]
                           delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
    [alert show];
}

-(void)cancel{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:NSLocalizedString(@"error", nil)
                           message:NSLocalizedString(@"connection_cancel", nil)
                           delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
    [alert show];
}

@end
