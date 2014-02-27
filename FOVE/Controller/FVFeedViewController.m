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
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (strong,nonatomic) NSMutableArray *notifications; // of FVNotifcation
@end

@implementation FVFeedViewController


-(NSMutableArray *)notifications
{
    if (!_notifications) {
        _notifications = [[NSMutableArray alloc] init];
    }
    return _notifications;
}
-(void)fetchNotifications
{
    [self.refreshControl beginRefreshing];
    
    NSDictionary *parameter = @{@"user_id": [[FVUser currentUser] user_id]};
    MSClient *client = [FVAzureService sharedClient];
    [client invokeAPI:@"notification"
                 body:nil
           HTTPMethod:@"GET"
           parameters:parameter
              headers:nil
           completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
               
               [self.refreshControl endRefreshing];
               
               NSUInteger numberOfNotifications = [result count];
               for (int i=numberOfNotifications-1; i>=0; i--)
               {
                   FVNotification *xNoti = [[FVNotification alloc] initWithNotificaitonInfo:result[i]];
                   
                   if ([self isNotificationExists:xNoti] == NO)
                   {
                       [_notifications insertObject:xNoti atIndex:0];
                   }
               }
               [self.notificationCollectionView reloadData];
           }
     ];
}

-(BOOL)isNotificationExists:(FVNotification *)notification
{
    for (int i=0; i<[self.notifications count]; i++) {
        FVNotification *xNotification = self.notifications[i];
        if ([xNotification.notification_id isEqualToString:notification.notification_id]) {
            return YES;
        }
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.notificationCollectionView.dataSource = self;
    [self.notificationCollectionView addSubview:self.refreshControl];
    
    [self fetchNotifications];
}

#pragma mark - Lazy Instantiation
-(UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(startRefresh:)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}
#pragma mark - refresh selector
-(void)startRefresh:(UIRefreshControl *)refreshControl
{
    [self fetchNotifications];
    NSLog(@"refresh");
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
