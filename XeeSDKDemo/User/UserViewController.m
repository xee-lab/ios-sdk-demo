//
//  UserViewController.m
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 17/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//
//This class shows how to fetch user information from the API


#import "UserViewController.h"
#import <XeeSDK/XeeSDK.h>
#import "globals.h"

@interface UserViewController ()<XeeAuthDelegate>

@property (strong, nonatomic)  NSString * accessToken;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *birthDate;
@property (weak, nonatomic) IBOutlet UITextView *textViewAddress;
@property (weak, nonatomic) IBOutlet UITextView *textViewEmailAdress;

@end

@implementation UserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
   
    //Fetch the user from the API and show
    [XEEUserApi userWithToken:self.accessToken].then(^(XEEUser * xeeUser){
        self.firstName.text = xeeUser.firstName;
        self.lastName.text = xeeUser.lastName;
        if( xeeUser.nickname !=nil && ![xeeUser.nickname isKindOfClass:[NSNull class]] )
            self.nickName.text = xeeUser.nickname;
        if( xeeUser.birthDate !=nil && ![xeeUser.birthDate isKindOfClass:[NSNull class]])
            self.birthDate.text =[NSString stringWithFormat:@"%@", xeeUser.birthDate];
        
        //Fetch user addresses list
        [XEEUserApi addressWithUserId:xeeUser.id token:self.accessToken].then(^(NSArray<XEEAddress*> *xeeAddress){
            if (xeeAddress != nil) {
                XEEAddress * currentAddress = xeeAddress[0];
                self.textViewAddress.text = [NSString stringWithFormat:@" %@ %@ %@\n%@\n%@",currentAddress.name, currentAddress.mainLine, currentAddress.complementLine, currentAddress.zipCode, currentAddress.country];
            }
        }).catch(^(NSError * error){
            [self catchError:error];
        });
        
        //Fetch user emails list
        [XEEUserApi emailWithUserId:xeeUser.id token:self.accessToken].then(^(NSArray *xeeEmails) {
            XEEEmail * currentEmail = xeeEmails[0];
            self.textViewEmailAdress.text = currentEmail.emailAddress;
        }).catch(^(NSError * error){
            [self catchError:error];
        });
        
    }).catch(^(NSError * error){
        [self catchError:error];
    });
    
}

-(void) catchError:(NSError*) error{
    int code =(int)[error.userInfo[@"com.alamofire.serialization.response.error.response"] statusCode];
    if (code == 403) {
        NSString * refreshTokenApp = [[NSUserDefaults standardUserDefaults] objectForKey:REFRESH_TOKEN];
        [XEEAuthentication refreshToken:refreshTokenApp].then(^(XEEToken * token){
            [self saveToken:token];
        }).catch(^(NSError * error){
            [self showAlert:error];
        });
    }else{
        [self showAlert:error];
    }
}


//This method is triggered as soon as the authentication is done.
-(void)success:(XEEToken *)token{
    [self saveToken:token];
}

//Save token
-(void) saveToken:(XEEToken *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token.accessToken forKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:token.refreshToken forKey:REFRESH_TOKEN]; 
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//This method is triggered if the authentication fails.
-(void)error:(NSError *)error{
    [self showAlert:error];
} 

-(void) showAlert:(NSError *)error{
    NSLog(@" Code error %i ",(int) error.code);
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:NSLocalizedString(@"error", nil)
                           message:[NSString stringWithFormat:@"Error code %i",(int) error.code]
                           delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
    [alert show];
}

//Authentication cancel
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
