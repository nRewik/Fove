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
#import "FVMailbox.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FVProfileViewController.h"

@interface FVSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *myMailboxCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *LogoutCell;
@end

@implementation FVSettingViewController


#pragma mark - viewController State
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Lazy Instantiation

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


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == self.myMailboxCell) {
        NSLog(@"mailbox");
    }
    if (cell == self.LogoutCell) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self logout];
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
