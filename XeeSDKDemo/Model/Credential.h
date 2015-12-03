//
//  Credential.h
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 25/11/2015.
//  Copyright © 2015 Eliocity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Credential : NSObject

@property (nonatomic, strong) NSString * clientID;
@property (nonatomic, strong) NSString * clientSecret;
@property (nonatomic, strong) NSArray<NSString*> * scopes;
@end
