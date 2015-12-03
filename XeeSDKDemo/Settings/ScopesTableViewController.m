//
//  ScopesTableViewController.m
//  XeeSDKDemo
//
//  Created by ruben BOBOTI on 28/09/2015.
//  Copyright (c) 2015 Eliocity. All rights reserved.
//
//This class manages scopes

#import "ScopesTableViewController.h"
#import "Persist.h"
#import "globals.h"

static NSArray *scopes() {
    static NSArray *scopes = NULL;
    scopes =
    @[@"user_get",
      @"car_get",
      @"email_get",
      @"data_get",
      @"location_get",
      @"address_all",
      @"accelerometer_get"];
    return scopes;
}

@interface ScopesTableViewController ()
@property (strong, nonatomic) NSArray<NSIndexPath*> * selectedScopes;
@property (strong, nonatomic) NSMutableArray<NSString*> * scopesChose;
@property (strong, nonatomic) NSArray * scopesSaving;
@end

@implementation ScopesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES];
    self.scopesSaving = [[Persist sharedInstance] scopesClient];
    self.scopesChose = [[NSMutableArray alloc] init];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [scopes() count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellID = SCOPES_CELL_ID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    cell.textLabel.text = scopes()[indexPath.row];
    
    if ([self.scopesSaving containsObject:scopes()[indexPath.row]]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self saveSelectedScopeAtIndex:indexPath];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self chooseScopeWithRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self chooseScopeWithRowAtIndexPath:indexPath];
}

-(void) chooseScopeWithRowAtIndexPath:(NSIndexPath*) indexPath{
    self.scopesChose = [[NSMutableArray alloc] init];
    self.selectedScopes = [self.tableView indexPathsForSelectedRows];
    for (indexPath in self.selectedScopes) {
        [self saveSelectedScopeAtIndex:indexPath];
    }
}

-(void) saveSelectedScopeAtIndex:(NSIndexPath*) indexPath{
    [self.scopesChose addObject:scopes()[indexPath.row]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //save scopes
    [[Persist sharedInstance] saveScopeClient:self.scopesChose];
}

@end
