//
//  FVMailbox.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/3/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVMailbox.h"

#import "FVAppDelegate.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@implementation FVMailbox


+(void)deleteMailboxWithID:(NSString *)mailboxID completion:(void (^)(id, NSError *))completion
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *mailTable = [client tableWithName:@"mailbox"];
    [mailTable deleteWithId:mailboxID completion:^(id itemId, NSError *error) {
        completion(itemId,error);
    }];
}

+(void)getMailboxFormID:(NSString *)mailboxID completion:(void (^)(FVMailbox *, NSError *))completion
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *mailTable = [client tableWithName:@"mailbox"];
    
    [mailTable readWithId:mailboxID completion:^(NSDictionary *item, NSError *error) {
        FVMailbox *mailbox = nil;
        if (!error) {
            mailbox = [[FVMailbox alloc] initWithMailboxDictionary:item];
        }
        completion(mailbox,error);
    }];
}

-(instancetype)initWithMailboxDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if( self )
    {
        _owner = [[FVUser alloc] initWithUserDictionary:dictionary[@"owner"]];
        
        _mailbox_id = dictionary[@"id"] == [NSNull null]? nil : dictionary[@"id"];
        _title = dictionary[@"title"] == [NSNull null]? nil : dictionary[@"title"];
        _message = dictionary[@"message"] == [NSNull null]? nil : dictionary[@"message"];
        _media = dictionary[@"media"] == [NSNull null]? nil : dictionary[@"media"];
        
        if ( dictionary[@"media_type"] != [NSNull null] )
        {
            NSString *mediaType = dictionary[@"media_type"];
            
            if ( [mediaType isEqualToString:@"image"])
            {
                _mediaType = FVMediaImageType;
            }
            else if([mediaType isEqualToString:@"video"])
            {
                _mediaType = FVMediaVideoType;
            }
        }
        
        if ( dictionary[@"fovecount"] != [NSNull null]) {
            _fovecount = [dictionary[@"fovecount"] integerValue];
        }
        if( dictionary[@"latitude"] != [NSNull null]){
            _location.latitude = [dictionary[@"latitude"] doubleValue];
        }
        if ( dictionary[@"longitude"] != [NSNull null]) {
            _location.longitude = [dictionary[@"longitude"] doubleValue];
        }

        _lastUpdate = dictionary[@"__updatedAt"] == [NSNull null]? nil : dictionary[@"__updatedAt"];
    }
    return self;
}

@end
