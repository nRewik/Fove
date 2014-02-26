//
//  FVChatPostCardCollectionViewCell.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/26/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVUser.h"
#import "FVPostCard.h"

@protocol FVChatPostcardCollectionViewCellDelegate;

@interface FVChatPostCardCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) FVUser *sender;
@property (strong,nonatomic) FVPostCard *postcard;

@property (strong,nonatomic) id<FVChatPostcardCollectionViewCellDelegate> delegate;

@end


@protocol FVChatPostcardCollectionViewCellDelegate
@required
-(void)didSelectPostcard:(FVPostCard *)postcard;
@end
