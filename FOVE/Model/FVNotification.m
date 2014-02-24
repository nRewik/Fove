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
        
        if (info[@"id"] != [NSNull null]) {
            _notification_id = info[@"id"];
        }
        if (info[@"sender"] != [NSNull null]) {
            _sender = [[FVUser alloc] initWithUserDictionary:info[@"sender"]];
        }
        if (info[@"recipient"] != [NSNull null]) {
            _recipient = [[FVUser alloc] initWithUserDictionary:info[@"recipient"]];
        }
        if (info[@"notification_message"] != [NSNull null]) {
            _message = info[@"notification_message"];
        }
        if (info[@"timestamp"] != [NSNull null]) {
            _timestamp = info[@"timestamp"];
        }
    }
    return self;
}

@end
