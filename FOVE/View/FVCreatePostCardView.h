//
//  FVCreatePostCardView.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FVCreatePostCardViewDelegate;

@interface FVCreatePostCardView : UIView
@property (strong,nonatomic) id<FVCreatePostCardViewDelegate> delegate;
@end

@protocol FVCreatePostCardViewDelegate <NSObject>
-(void)didCancelCreatePostCard;
@end
