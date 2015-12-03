//
//  AppDelegate.m
//  XeeSDKDemo
//
//  Created by Vincent Masselis on 02/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//

#import "AppDelegate.h"
#import <XeeSDK/XeeSDK.h>
#import "Persist.h"
#import "Credential.h"
#import "XeeIntializer.h"
#import "SettingsViewController.h"
#import "SignalBTViewController.h"
#import "MainViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //Check app credentials and go on
    Credential * cred = [[Persist sharedInstance] credentials];
    XEEClient * client =[[XEEClient alloc] init];
    
    client.clientId = cred.clientID;
    client.password = cred.clientSecret;
    client.scopes = cred.scopes;
    
    //itinialise Xee
    [XeeIntializer setupWithClient:client];
    
    UINavigationController * nav = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"startNav"];
    SignalBTViewController *secondViewController = [[UIStoryboard storyboardWithName:@"BT" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"startBT"];
    UINavigationController * navSettings = [[UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"settingNav"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[nav,
                                           secondViewController,
                                           navSettings
                                           ]];
    [[tabBarController.tabBar.items objectAtIndex:0] setTitle:@"API"];
    [[tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Bluetooth"];
    [[tabBarController.tabBar.items objectAtIndex:2] setTitle:@"Settings"];
    self.window.rootViewController = tabBarController;
    return YES;
}



@end
