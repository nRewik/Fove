//
//  FVUser.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/2/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVUser.h"

#import "FVAppDelegate.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@implementation FVUser


+(void)getUserFromID:(NSString *)user_id completion:(void (^)(FVUser *, NSError *))completion
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *userTable = [client tableWithName:@"userinfo"];
    [userTable readWithId:user_id completion:^(NSDictionary *item, NSError *error) {
        FVUser *resultUser = nil;
        if (!error)
        {
            resultUser = [[FVUser alloc] initWithUserDictionary:item];
        }
        completion(resultUser,error);
    }];
}

static FVUser *currentUser;
+(FVUser *)currentUser
{
    return currentUser;
}
+(void)setCurrentUser:(FVUser *)user
{
    currentUser = user;
}



-(instancetype)initWithUserDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if( self ){
        _user_id = dictionary[@"id"];
        _name = dictionary[@"name"];
        _gender = dictionary[@"gender"];
        _status = dictionary[@"status"];
        _relationship = dictionary[@"relationship"];
        
        _profileImageUrl = dictionary[@"profileimage"];
        
        if( dictionary[@"age"] != [NSNull null]){
            _age = [dictionary[@"age"] integerValue];
        }
        if( dictionary[@"weight"] != [NSNull null]){
            _weight = [dictionary[@"weight"] integerValue];
        }
        if( dictionary[@"height"] != [NSNull null]){
            _height = [dictionary[@"height"] integerValue];

        }    }
    return self;
}

-(void)setUserWithDictionary:(NSDictionary *)dictionary
{
    self.user_id = dictionary[@"id"];
    self.name = dictionary[@"name"];
    self.gender = dictionary[@"gender"];
    self.status = dictionary[@"status"];
    self.relationship = dictionary[@"relationship"];
    
    self.profileImageUrl = dictionary[@"profileimage"];

    
    if( dictionary[@"age"] != [NSNull null] ){
        self.age = [dictionary[@"age"] integerValue];
    }
    if( dictionary[@"weight"] != [NSNull null]){
        self.weight = [dictionary[@"weight"] integerValue];
    }
    if( dictionary[@"height"] != [NSNull null]){
        self.height = [dictionary[@"height"] integerValue];
        
    }
}



@end
