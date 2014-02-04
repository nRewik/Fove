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
        _owner = [[FVUser alloc] initWithUserDictionary:[dictionary objectForKey:@"owner"]];
        
        _mailbox_id = [dictionary objectForKey:@"id"];
        
        _title = [dictionary objectForKey:@"title"];
        _message = [dictionary objectForKey:@"message"];
        _media = [dictionary objectForKey:@"media"];
        
        if ( [dictionary objectForKey:@"media_type"] != [NSNull null] )
        {
            NSString *mediaType = [dictionary objectForKey:@"media_type"];
            
            if ( [mediaType isEqualToString:@"image"])
            {
                _mediaType = FVMediaImageType;
            }
            else if([mediaType isEqualToString:@"video"])
            {
                _mediaType = FVMediaVideo;
            }
        }
        
        if ( [dictionary objectForKey:@"fovecount"] != [NSNull null]) {
            _fovecount = [[dictionary objectForKey:@"fovecount"] integerValue];
        }
        if( [dictionary objectForKey:@"latitude"] != [NSNull null]){
            _location.latitude = [[dictionary objectForKey:@"latitude"] doubleValue];
        }
        if ( [dictionary objectForKey:@"longitude"] != [NSNull null]) {
            _location.longitude = [[dictionary objectForKey:@"longitude"] doubleValue];
        }

        _lastUpdate = [dictionary objectForKey:@"__updatedAt"];
    }
    return self;
}

@end
