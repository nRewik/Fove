//
//  FVAzureService.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/25/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVAzureService.h"

@implementation FVAzureService


static MSClient *sharedClient = NULL;
+(MSClient *)sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedClient == nil) {
            sharedClient = [MSClient clientWithApplicationURLString:@"https://fove.azure-mobile.net/" applicationKey:@"sgsdrHNSdIGQQzYmKrNkFlkcCIwmEY95"];
        }
    });
    return sharedClient;
}


@end
