//
//  XeeDemosPersist.m
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 14/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//

#import "Persist.h"
#import "AppDelegate.h"
#import "Credential.h" 
#import "globals.h"


@implementation Persist

+ (Persist *) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init ];
    });
    return sharedInstance;
}

//Save user credential
-(void) saveCredential:(NSString*) clientID with:(NSString*) clientSecret{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:clientID forKey:CLIENT_ID];
    [defaults setObject:clientSecret forKey:CLIENT_SECRET];
    [defaults synchronize]; 
}

//Save scope
-(void) saveScopeClient:(NSArray*) scopes{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:scopes forKey:SCOPES];
    [defaults synchronize]; 
}

//Return scope
-(NSArray*) scopesClient{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:SCOPES];      
}

//Return credentials
-(Credential*) credentials{
     NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    Credential * credential = [[Credential alloc] init];
    credential.clientID = [defaults objectForKey:CLIENT_ID];
    credential.clientSecret = [defaults objectForKey:CLIENT_SECRET];
    credential.scopes = [defaults objectForKey:SCOPES];
    return credential;
}

@end
