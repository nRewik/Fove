//
//  FVGalleryViewCell.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/23/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVGalleryViewCell.h"
#import "FVPostCardView.h"

@interface FVGalleryViewCell ()
@property (weak, nonatomic) IBOutlet FVPostCardView *postcardView;
@end

@implementation FVGalleryViewCell

-(void)setPostcard:(FVPostCard *)postcard
{
    _postcard = postcard;
    self.postcardView.postCard = self.postcard;
}

@end
