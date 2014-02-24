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

@property (strong,nonatomic) NSString *notification_id;
@property (strong,nonatomic) FVUser *sender;
@property (strong,nonatomic) FVUser *recipient;
@property (strong,nonatomic) NSString *message;
@property (strong,nonatomic) NSDate *timestamp;


-(instancetype)initWithNotificaitonInfo:(NSDictionary *)info;

@end
