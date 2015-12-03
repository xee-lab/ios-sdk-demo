//
//  XeeDemosPersist.h
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 14/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Credential;

@interface Persist : NSObject
 
+ (Persist *) sharedInstance;

-(void) saveCredential:(NSString *) clientID with:(NSString*) clientSecret;
-(Credential*) credentials;
-(void) saveScopeClient:(NSArray*) scopes;
-(NSArray*) scopesClient;


@end
