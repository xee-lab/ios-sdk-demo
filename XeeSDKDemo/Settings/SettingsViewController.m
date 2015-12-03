//
//  SettingsViewController.m
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 11/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//


#import "SettingsViewController.h"
#import <XeeSDK/XEESdk.h>
#import "Credential.h"
#import "Persist.h"
#import "XeeIntializer.h"
#import "globals.h"

@interface SettingsViewController()

@property (weak, nonatomic) IBOutlet UITextField *clientId;
@property (weak, nonatomic) IBOutlet UITextField *clientSecret;
@property (nonatomic, strong) NSArray * scopes;
@property (nonatomic, strong) Credential * cred;

@end

@implementation SettingsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.cred = [[Persist sharedInstance] credentials];
    self.scopes = [[Persist sharedInstance] scopesClient];
    if (self.cred.clientID != nil  && self.cred.clientSecret != nil) {
        self.clientId.text = self.cred.clientID;
        self.clientSecret.text = self.cred.clientSecret;
    }
}

- (IBAction) manageConnectionToXee:(id)sender {
    
    XEEClient * client =[[XEEClient alloc] init];
    client.clientId = self.clientId.text;;
    client.password = self.cred.clientSecret;
    client.scopes = self.scopes;
    
    if (client.clientId != nil && client.password != nil) {
        if (self.scopes != nil) {
            [XeeIntializer setupWithClient:client];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.tabBarController setSelectedIndex:0];
        }else{
            UIAlertView * alert = [[UIAlertView alloc]
                                   initWithTitle:NSLocalizedString(@"title_scopes_missing", nil)
                                   message:NSLocalizedString(@"scopes_missing", nil)
                                   delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"ok", nil];
            [alert show];
        }
    }else{
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:NSLocalizedString(@"title_credential_missing", nil)
                               message:NSLocalizedString(@"credential_missing", nil)
                               delegate:nil
                               cancelButtonTitle:nil
                               otherButtonTitles:@"ok", nil];
        [alert show];
    }
}

#pragma mark - UITextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //reset Token app
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:REFRESH_TOKEN]; 
    [[NSUserDefaults standardUserDefaults] synchronize];
    [textField resignFirstResponder]; 
    return YES;
}

//save app settings
-(void) viewWillDisappear:(BOOL)animated{
    [[Persist sharedInstance] saveCredential:self.clientId.text with:self.clientSecret.text];
}


@end
