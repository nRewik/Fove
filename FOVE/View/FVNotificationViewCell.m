//
//  FVNotificationViewCell.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/25/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVNotificationViewCell.h"


@interface FVNotificationViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *notificationMessageLabel;
@end

@implementation FVNotificationViewCell


-(void)setNotification:(FVNotification *)notification
{
    _notification = notification;
    
    self.profileImageView.image = self.notification.sender.profileImage;
    self.notificationMessageLabel.text = self.notification.message;
}

@end
