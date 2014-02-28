//
//  FVSettingViewController.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 1/28/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FVSettingViewControllerDelegate;

@interface FVSettingViewController : UITableViewController

@property (strong,nonatomic) id<FVSettingViewControllerDelegate> delegate;

@end

@protocol FVSettingViewControllerDelegate <NSObject>
-(void)didSelectViewMyMailboxes:(NSArray *)myMatchingMailboxs;
@end
