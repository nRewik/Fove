//
//  FVNotification.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/24/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVNotification.h"

@implementation FVNotification


-(instancetype)initWithNotificaitonInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        
        _notification_id = info[@"id"];
            
        if (info[@"sender"] && info[@"sender"] != [NSNull null]) {
            _sender = [[FVUser alloc] initWithUserDictionary:info[@"sender"]];
        }
        if (info[@"recipient"] && info[@"recipient"] != [NSNull null]) {
            _recipient = [[FVUser alloc] initWithUserDictionary:info[@"recipient"]];
        }
        if (info[@"notification_message"] && info[@"notification_message"] != [NSNull null]) {
            _message = info[@"notification_message"];
        }
        if (info[@"__createdAt"] && info[@"__createdAt"] != [NSNull null]) {
            _timestamp = info[@"__createdAt"];
        }
        
        if (info[@"notification_type"] && info[@"notification_type"] != [NSNull null]) {
            NSString *notifyType = info[@"notification_type"];
            if ([notifyType isEqualToString:@"fove"]) {
                _type = FVNotifyFove;
            }
            else if([notifyType isEqualToString:@"send_postcard"])
            {
                _type = FVNotifySendPostcard;
            }
            else if([notifyType isEqualToString:@"create_mailbox"])
            {
                _type = FVNotifyCreateMailbox;
            }
        }
        
    }
    return self;
}

@end
