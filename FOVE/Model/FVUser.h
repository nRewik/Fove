//
//  FVUser.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/2/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FVUser : NSObject

//singleton object
+(FVUser *)currentUser;
+(void)setCurrentUser:(FVUser *)user;

//public method
+(void)getUserFromID:(NSString *)user_id completion: (void (^)(FVUser *resultUser, NSError *error)) completion;

//init
-(instancetype)initWithUserDictionary:(NSDictionary *)dictionary;

//method
-(void)setUserWithDictionary:(NSDictionary *)dictionary;


//fove
@property (strong,nonatomic) NSString *user_id; //identifier
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *gender;
@property (strong,nonatomic) NSString *status;
@property (strong,nonatomic) NSString *relationship;
@property (nonatomic) NSInteger age;
@property (nonatomic) NSInteger weight;
@property (nonatomic) NSInteger height;

@property (strong,nonatomic) NSString *profileImageUrl;
@property (strong,nonatomic) UIImage *profileImage;

//social
@property (strong,nonatomic) id<FBGraphUser> facebookUserData;

@end
