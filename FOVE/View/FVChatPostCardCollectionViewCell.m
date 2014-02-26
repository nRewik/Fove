//
//  FVChatPostCardCollectionViewCell.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/26/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVChatPostCardCollectionViewCell.h"
#import "FVPostCardPortraitView.h"
#import "NSDate+NVTimeAgo.h"

@interface FVChatPostCardCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *senderImageView;
@property (weak, nonatomic) IBOutlet FVPostCardPortraitView *postcardPortraitView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation FVChatPostCardCollectionViewCell

-(void)awakeFromNib
{
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPostcard)];
    [self.postcardPortraitView addGestureRecognizer:tapGesture];
}
-(void)selectPostcard
{
    [self.delegate didSelectPostcard:self.postcard];
}

-(void)setSender:(FVUser *)sender
{
    _sender = sender;
    self.senderImageView.image = self.sender.profileImage;
}
-(void)setPostcard:(FVPostCard *)postcard
{
    _postcard = postcard;
    
    self.postcardPortraitView.postCard = self.postcard;
    self.senderImageView.image = self.postcard.sender.profileImage;
    self.timeLabel.text = [self.postcard.timestamp formattedAsTimeAgo];
}


@end
