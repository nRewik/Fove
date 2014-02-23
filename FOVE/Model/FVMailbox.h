//
//  FVMailbox.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/3/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FVUser.h"

@interface FVMailbox : NSObject

typedef NS_ENUM(NSInteger, FVMediaType) {
    FVMediaImageType,
    FVMediaVideoType
};

+(void)getMailboxFormID:(NSString *)mailboxID completion: (void (^)(FVMailbox *resultMailbox, NSError *error)) completion;
+(void)deleteMailboxWithID:(NSString *)mailboxID completion:(void (^)(id itemId, NSError *error)) completion;

-(instancetype)initWithMailboxDictionary:(NSDictionary *)dictionary;

@property (strong,nonatomic) NSString *mailbox_id;
@property (strong,nonatomic) FVUser *owner;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *message;

@property (strong,nonatomic) NSString *mediaURL;
@property (strong,nonatomic) NSData *mediaData;
@property (nonatomic) FVMediaType mediaType;

@property (nonatomic) NSUInteger fovecount;
@property (nonatomic) CLLocationCoordinate2D location;

@property (strong,nonatomic) NSDate *lastUpdate;


@end
