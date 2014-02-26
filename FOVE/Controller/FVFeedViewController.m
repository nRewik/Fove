//
//  FVFeedViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/8/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVFeedViewController.h"
#import "FVNotification.h"
#import "FVNotificationViewCell.h"
#import "FVAzureService.h"

@interface FVFeedViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *notificationCollectionView;
@property (strong,nonatomic) NSMutableArray *notifications; // of FVNotifcation
@end

@implementation FVFeedViewController


-(NSMutableArray *)notifications
{
    if (!_notifications) {
        
        _notifications = [[NSMutableArray alloc] init];
        
        NSDictionary *parameter = @{@"user_id": [[FVUser currentUser] user_id]};
        MSClient *client = [FVAzureService sharedClient];
        [client invokeAPI:@"notification"
                     body:nil
               HTTPMethod:@"GET"
               parameters:parameter
                  headers:nil
               completion:^(id result, NSHTTPURLResponse *response, NSError *error) {

                   NSUInteger numberOfNotifications = [result count];
                   for (int i=0; i<numberOfNotifications; i++)
                   {
                       /* result[i] format
                        "notification_message" = "fove your mailbox";
                        "notification_type" = "fove";
                        "recipient_id" = "<null>";
                        "sender_id" = 5;
                        */
                       
                       FVNotification *xNoti = [[FVNotification alloc] init];
                       xNoti.message = result[i][@"notification_message"];
                       
                       [FVUser getUserFromID:result[i][@"sender_id"] completion:^(FVUser *resultUser, NSError *error) {
                           xNoti.sender = resultUser;
                           [self.notificationCollectionView reloadData];
                       }];
                       
                       [_notifications addObject:xNoti];
                   }
                   
                   [self.notificationCollectionView reloadData];
               }
         ];
    }
    return _notifications;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.notificationCollectionView.dataSource = self;
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.notifications count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *notificationViewCellidentifier = @"notificationViewCell";
    
    FVNotificationViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:notificationViewCellidentifier forIndexPath:indexPath];
    cell.notification = self.notifications[indexPath.row];
    
    return cell;
}




@end
