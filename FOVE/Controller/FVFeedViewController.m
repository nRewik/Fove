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

@interface FVFeedViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *notificationCollectionView;
@property (strong,nonatomic) NSMutableArray *notifications; // of FVNotifcation
@end

@implementation FVFeedViewController


-(NSMutableArray *)notifications
{
    if (!_notifications) {
        _notifications = [[NSMutableArray alloc] init];
        
        int numberOfNotifications = 25;
        
        for (int i=0; i<numberOfNotifications; i++) {
            FVNotification *xNoti = [[FVNotification alloc] init];
            FVUser *user = [[FVUser alloc] init];
            NSString *imageName = [NSString stringWithFormat:@"test_profile_%d",i%6];
            user.profileImage = [UIImage imageNamed:imageName];
            
            xNoti.sender = user;
            NSMutableString *message = [[NSMutableString alloc] init];
            for (int j=0; j<i; j++) {
                [message appendString:@"MMM "];
            }
            xNoti.message = message;
            
            [_notifications addObject:xNoti];
        }
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
