//
//  FVUser.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/2/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVUser.h"

#import "FVAzureService.h"

@implementation FVUser


+(void)getUserFromID:(NSString *)user_id completion:(void (^)(FVUser *, NSError *))completion
{
    MSClient *client = [FVAzureService sharedClient];
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
        _user_id = dictionary[@"id"] == [NSNull null] ? nil : dictionary[@"id"] ;
        _name = dictionary[@"name"] == [NSNull null] ? nil : dictionary[@"name"] ;
        _gender = dictionary[@"gender"] == [NSNull null] ? nil : dictionary[@"gender"] ;
        _status = dictionary[@"status"] == [NSNull null] ? nil : dictionary[@"status"] ;
        _relationship = dictionary[@"relationship"] == [NSNull null] ? nil : dictionary[@"relationship"] ;
        
        _profileImageUrl = dictionary[@"profileimage"] == [NSNull null] ? nil : dictionary[@"profileimage"] ;
        
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
    self.user_id = dictionary[@"id"] == [NSNull null] ? nil : dictionary[@"id"] ;
    self.name = dictionary[@"name"] == [NSNull null] ? nil : dictionary[@"name"] ;
    self.gender = dictionary[@"gender"] == [NSNull null] ? nil : dictionary[@"gender"] ;
    self.status = dictionary[@"status"] == [NSNull null] ? nil : dictionary[@"status"] ;
    self.relationship = dictionary[@"relationship"] == [NSNull null] ? nil : dictionary[@"relationship"] ;
    
    self.profileImageUrl = dictionary[@"profileimage"] == [NSNull null] ? nil : dictionary[@"profileimage"] ;

    
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

-(UIImage *)profileImage
{
    if (!_profileImage) {
        NSURL *imageURL = [NSURL URLWithString:self.profileImageUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        _profileImage = image;
    }
    return _profileImage;
}


@end
