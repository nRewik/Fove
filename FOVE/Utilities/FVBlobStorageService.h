//
//  FVBlobStorageService.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/8/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

#pragma mark - Settings
static NSString * const mobileServiceUrl = @"https://fove.azure-mobile.net";
static NSString * const mobileServiceApplicationKey = @"sgsdrHNSdIGQQzYmKrNkFlkcCIwmEY95";

static NSString * const blobUrl = @"http://fovestorage.blob.core.windows.net";

static NSString * const blobContainer = @"blobcontainers";
static NSString * const blobblobs = @"blobblobs";

static NSString * const profileImageContainer = @"profileimage";
static NSString * const mailboxMediaContainer = @"mailboxmedia";
static NSString * const postcardContainer = @"postcard";

#pragma mark -


@interface FVBlobStorageService : NSObject

@property (nonatomic, strong)   MSClient *client;

+(FVBlobStorageService *) getInstance;
+(NSString *)blobUrl;

#pragma mark - container
+(NSString *)profileImageContainer;
+(NSString *)mailboxMediaContainer;
+(NSString *)postcardContainer;
#pragma mark -

- (void) getContainersList:(void (^)(id result, NSError *error)) completion;
- (void) createContainer:(NSString *)containerName withPublicSetting:(BOOL)isPublic withCompletion:(void (^)(id result, NSError *error)) completion;
- (void) deleteContainer:(NSString *)containerName withCompletion:(void (^)(id result, NSError *error)) completion;
- (void) getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName withCompletion:(void (^)(NSString *sasUrl, NSError *error))completion;
- (void) deleteBlob:(NSString *)blobName fromContainer:(NSString *)containerName withCompletion:(void (^)(id result, NSError *error))completion;

- (void) postImageToBlobWithUrl:(NSString *)sasUrl NSData:(NSData *)data withCompletion:(void (^)(BOOL isSuccess))completion;
- (void) postBlobWithUrl:(NSString *)sasUrl NSData:(NSData *)data withCompletion:(void (^)(BOOL))completion;
- (void) postBlobWithUrl:(NSString *)sasUrl NSData:(NSData *)data contentType:(NSString *)contentType withCompletion:(void (^)(BOOL))completion;


@end
