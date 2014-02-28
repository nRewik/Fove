//
//  FVSettingViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 1/28/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVSettingViewController.h"
#import "FVViewController.h"
#import "FVUser.h"
#import "FVMatchingMailbox.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FVProfileViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "FVAzureService.h"

@interface FVSettingViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *myMailboxCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *LogoutCell;
@property (strong,nonatomic) UIAlertView *logoutAlertView;

@end

@implementation FVSettingViewController


#pragma mark - viewController State
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Lazy Instantiation
-(UIAlertView *)logoutAlertView
{
    if (!_logoutAlertView) {
        _logoutAlertView = [[UIAlertView alloc] initWithTitle:@"Do you want to logout ?"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    }
    return _logoutAlertView;
}
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destination = segue.destinationViewController;
    if ([destination isKindOfClass:[FVProfileViewController class]]) {
        if ([segue.identifier isEqualToString:@"viewProfile"]) {
            FVProfileViewController *pvc = (FVProfileViewController *)destination;
            pvc.user = [FVUser currentUser];
        }
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.logoutAlertView && buttonIndex != 0) {
        [self logout];
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == self.myMailboxCell)
    {
        
        MSClient *client = [FVAzureService sharedClient];
        MSTable *mailboxTable = [client tableWithName:@"mailbox"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner_id == %@",[[FVUser currentUser] user_id]];
        [mailboxTable readWithPredicate:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
            
            NSMutableArray *mailboxs = [[NSMutableArray alloc] init];
            for (int i=0; i<[items count]; i++) {
                FVMatchingMailbox *newMailbox = [[FVMatchingMailbox alloc] initWithMailboxDictionary:items[i]];
                [mailboxs addObject:newMailbox];
            }
            [self.tabBarController setSelectedIndex:0];
            [self.delegate didSelectViewMyMailboxes:mailboxs];
        }];
    }
    if (cell == self.LogoutCell) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.logoutAlertView show];
    }
}
#pragma mark - Action
-(void)logout
{
    FBSession *session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [FVUser setCurrentUser:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"logout");
}


@end
