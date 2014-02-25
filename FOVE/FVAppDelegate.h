//
//  FVAppDelegate.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 1/24/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id <FBGraphUser> facebookUser;

@end
