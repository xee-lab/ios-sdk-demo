//
//  SignalTableViewCell.h
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 30/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *signalValueTextView;
@property (weak, nonatomic) IBOutlet UITextView *signalNameTextView; 

@end
