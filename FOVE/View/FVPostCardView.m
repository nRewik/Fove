//
//  FVPostCardView.m
//  
//
//  Created by Nutchaphon Rewik on 2/15/14.
//
//

#import "FVPostCardView.h"

@implementation FVPostCardView

-(void)awakeFromNib
{
    [self FVPostCardViewSetup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self FVPostCardViewSetup];
    }
    return self;
}

-(void)FVPostCardViewSetup
{
    _frontView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    _frontView.contentMode = UIViewContentModeScaleAspectFill;
    _backView.contentMode = UIViewContentModeScaleAspectFill;
    
    _frontView.clipsToBounds = YES;
    _backView.clipsToBounds = YES;
    
    [self addSubview:_frontView];
}

-(void)setPostCard:(FVPostCard *)postCard
{
    _postCard = postCard;
    self.frontView.image = self.postCard.frontImage;
    self.backView.image = self.postCard.backImage;
}

-(UIView *)currentView
{
    return self.postCard.isFlip ? self.backView : self.frontView;
}


@end
