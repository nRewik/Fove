//
//  FVAzureService.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/25/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface FVAzureService : NSObject

+(MSClient *)sharedClient;

@end
