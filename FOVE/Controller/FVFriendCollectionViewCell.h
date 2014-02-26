//
//  FVFriendCollectionViewCell.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/21/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVUser.h"

@protocol FVFriendCollectionViewCellDelegate;

@interface FVFriendCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) FVUser *user;
@property (strong,nonatomic) id<FVFriendCollectionViewCellDelegate> delegate;

@end

@protocol FVFriendCollectionViewCellDelegate
@required
-(void)didSelectChatWithUser:(FVUser *)user;
@end