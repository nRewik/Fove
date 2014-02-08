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


+(FVUser *)currentUser
{
    static FVUser *currentUser;
    @synchronized(self)
    {
        if (!currentUser){
            currentUser = [[FVUser alloc] init];
        }
        return currentUser;
    }
}

-(instancetype)initWithUserDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if( self ){
        _user_id = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
        _gender = [dictionary objectForKey:@"gender"];
        _status = [dictionary objectForKey:@"status"];
        _relationship = [dictionary objectForKey:@"relationship"];
        
        _profileImageUrl = [dictionary objectForKey:@"profileimage"];
        
        if( [dictionary objectForKey:@"age"] != [NSNull null]){
            _age = [[dictionary objectForKey:@"age"] integerValue];
        }
        if( [dictionary objectForKey:@"weight"] != [NSNull null]){
            _weight = [[dictionary objectForKey:@"weight"] integerValue];
        }
        if( [dictionary objectForKey:@"height"] != [NSNull null]){
            _height = [[dictionary objectForKey:@"height"] integerValue];

        }    }
    return self;
}

-(void)setUserWithDictionary:(NSDictionary *)dictionary
{
    self.user_id = [dictionary objectForKey:@"id"];
    self.name = [dictionary objectForKey:@"name"];
    self.gender = [dictionary objectForKey:@"gender"];
    self.status = [dictionary objectForKey:@"status"];
    self.relationship = [dictionary objectForKey:@"relationship"];
    
    self.profileImageUrl = [dictionary objectForKey:@"profileimage"];

    
    if( [dictionary objectForKey:@"age"] != [NSNull null] ){
        self.age = [[dictionary objectForKey:@"age"] integerValue];
    }
    if( [dictionary objectForKey:@"weight"] != [NSNull null]){
        self.weight = [[dictionary objectForKey:@"weight"] integerValue];
    }
    if( [dictionary objectForKey:@"height"] != [NSNull null]){
        self.height = [[dictionary objectForKey:@"height"] integerValue];
        
    }
}



@end
