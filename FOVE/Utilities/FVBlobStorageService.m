//
//  FVBlobStorageService.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/8/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVBlobStorageService.h"

@interface FVBlobStorageService()

@property (nonatomic, strong)   MSTable *containersTable;
@property (nonatomic, strong)   MSTable *blobsTable;
@property (nonatomic)           NSInteger busyCount;

@end


@implementation FVBlobStorageService

static FVBlobStorageService *singletonInstance;
+ (FVBlobStorageService *)getInstance{
    if (singletonInstance == nil) {
        singletonInstance = [[self alloc] init];
    }
    return singletonInstance;
}

+(NSString *)blobUrl
{
    return blobUrl;
}
+(NSString *)profileImageContainer
{
    return profileImageContainer;
}

-(FVBlobStorageService *) init
{
    self = [super init];
    if (self)
    {
        _client = [MSClient clientWithApplicationURLString:mobileServiceUrl applicationKey:mobileServiceApplicationKey];
    }
    return self;
}

#pragma mark - containers

- (void) getContainersList:(void (^)(id, NSError *))completion
{
    [self.client invokeAPI:blobContainer
                      body:nil
                HTTPMethod:@"GET"
                parameters:nil
                   headers:nil
                completion:^(id result, NSHTTPURLResponse *response, NSError *error){
                    completion(result,error);
                }
     ];
}

-(void)createContainer:(NSString *)containerName withPublicSetting:(BOOL)isPublic withCompletion:(void (^)(id, NSError *))completion
{
    NSDictionary *parameters = @{
                                 @"containerName" : containerName,
                                 @"isPublic" : [NSNumber numberWithBool:isPublic]
                                 };
    
    [self.client invokeAPI:blobContainer
                      body:nil
                HTTPMethod:@"PUT"
                parameters:parameters
                   headers:nil
                completion:^(id result, NSHTTPURLResponse *response, NSError *error){
                    completion(result,error);
                }
     ];
}

-(void)deleteContainer:(NSString *)containerName withCompletion:(void (^)(id, NSError *))completion
{
    NSDictionary *parameters = @{ @"containerName" : containerName };
    [self.client invokeAPI:blobContainer
                      body:nil
                HTTPMethod:@"DELETE"
                parameters:parameters
                   headers:nil
                completion:^(id result, NSHTTPURLResponse *response, NSError *error){
                    completion(result,error);
                }
     ];
}


#pragma mark - blobs

-(void)getBlobsList:(NSString *)containerName withCompletion:(void (^)(id, NSError *))completion
{
    NSDictionary *parameters = @{ @"containerName" : containerName };
    [self.client invokeAPI:blobblobs
                      body:nil
                HTTPMethod:@"GET"
                parameters:parameters
                   headers:nil
                completion:^(id result, NSHTTPURLResponse *response, NSError *error){
                    completion(result,error);
                }
     ];
}

-(void)getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName withCompletion:(void (^)(NSString *, NSError *))completion
{
    NSDictionary *parameters = @{ @"containerName" : containerName, @"blobName" : blobName };
    [self.client invokeAPI:blobblobs
                      body:nil
                HTTPMethod:@"PUT"
                parameters:parameters
                   headers:nil
                completion:^(id result, NSHTTPURLResponse *response, NSError *error){
                    NSString *sasUrl = [result objectForKey:@"sasUrl"];
                    completion(sasUrl,error);
                }
     ];
}

-(void)deleteBlob:(NSString *)blobName fromContainer:(NSString *)containerName withCompletion:(void (^)(id, NSError *))completion
{
    NSDictionary *parameters = @{ @"containerName" : containerName, @"blobName" : blobName };
    [self.client invokeAPI:blobblobs
                      body:nil
                HTTPMethod:@"DELETE"
                parameters:parameters
                   headers:nil
                completion:^(id result, NSHTTPURLResponse *response, NSError *error){
                    completion(result,error);
                }
     ];
}

#pragma mark - upload blob


-(void)postImageToBlobWithUrl:(NSString *)sasUrl NSData:(NSData *)data withCompletion:(void (^)(BOOL))completion
{
    [self postBlobWithUrl:sasUrl NSData:data contentType:@"image/png" withCompletion:completion];
}

- (void)postBlobWithUrl:(NSString *)sasUrl NSData:(NSData *)data contentType:(NSString *)contentType withCompletion:(void (^)(BOOL))completion
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sasUrl]];
    [request setHTTPMethod:@"PUT"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc]init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (connectionError || httpResponse.statusCode != 201)
                               {
                                   completion(NO);
                               }
                               else
                               {
                                   completion(YES);
                               }
                           }
     ];
    
}






















@end
