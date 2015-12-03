//
//  XEEcarConfig.h
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 26/11/2015.
//  Copyright © 2015 Eliocity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XEECar;

@protocol  CarSelectionDelegate <NSObject>
@required
- (void) carSelected:(XEECar*) car;

@end

@interface CarSelection : NSObject
+(void) carWith:(NSString*)userId accessToken:(NSString*)accessToken with:(id<CarSelectionDelegate>) delegate hostViewController:(UIViewController*) viewController;

@end
