//
//  FVNotification.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/24/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FVUser.h"

@interface FVNotification : NSObject

typedef NS_ENUM(NSInteger, FVNotifyType) {
    FVNotifyFove,
    FVNotifyCreateMailbox,
    FVNotifySendPostcard
};

@property (strong,nonatomic) NSString *notification_id;
@property (nonatomic) FVNotifyType type;
@property (strong,nonatomic) FVUser *sender;
@property (strong,nonatomic) FVUser *recipient;
@property (strong,nonatomic) NSString *message;
@property (strong,nonatomic) NSDate *timestamp;



-(instancetype)initWithNotificaitonInfo:(NSDictionary *)info;

@end
