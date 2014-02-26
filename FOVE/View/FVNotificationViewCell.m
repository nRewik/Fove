//
//  FVNotificationViewCell.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/25/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVNotificationViewCell.h"
#import "NSDate+NVTimeAgo.h"


@interface FVNotificationViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *notifyIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *notificationMessageLabel;
@end

@implementation FVNotificationViewCell


-(void)setNotification:(FVNotification *)notification
{
    _notification = notification;
    if (self.notification.sender != nil) {
        [self updateUI];
    }
}


-(void)updateUI
{
    self.profileImageView.image = self.notification.sender.profileImage;
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] init];
    
    //name
    NSDictionary *senderNameAttributedInfo = @{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] };
    NSMutableAttributedString *senderName = [[NSMutableAttributedString alloc] initWithString:self.notification.sender.name];
    [senderName setAttributes:senderNameAttributedInfo range:NSMakeRange(0,senderName.mutableString.length)];
    //
    [message appendAttributedString:senderName];
    
    //message body
    switch (self.notification.type) {
        case FVNotifyFove:
            {
                NSAttributedString *foveMessage = [[NSAttributedString alloc] initWithString:@" foved your mailbox." attributes:nil];
                [message appendAttributedString:foveMessage];
                
                self.notifyIconImageView.image = [UIImage imageNamed:@"notification_fove"];
            }
            break;
        case FVNotifySendPostcard:
            {
                NSAttributedString *sendPostcardMessage = [[NSAttributedString alloc] initWithString:@" sent postcard to you." attributes:nil];
                [message appendAttributedString:sendPostcardMessage];
                
                self.notifyIconImageView.image = [UIImage imageNamed:@"notification_postcard"];

            }
            break;
        case FVNotifyCreateMailbox:
            {
                self.notifyIconImageView.image = [UIImage imageNamed:@"notification_mailbox"];
            }
            break;
    }
    self.notificationMessageLabel.attributedText = message;
    
    //time label
    self.timeLabel.text = [self.notification.timestamp formattedAsTimeAgo];
    
}


@end