//
//  FVChatViewController.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVUser.h"

@interface FVChatViewController : UIViewController

@property (strong,nonatomic) FVUser *user;
@property (strong,nonatomic) FVUser *friend;

@end
