//
//  FVPostCardScrollViewLandScape.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/15/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVPostCardScrollViewLandScape.h"
#import "FVPostCardLandScapeView.h"

#define postCardViewWidth 480
#define postCardViewHeight 300
#define postCardGap 10

@implementation FVPostCardScrollViewLandScape
{
    UIScrollView *_scrollView;
}

-(void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    [_scrollView removeFromSuperview];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    //_scrollView.contentInset = UIEdgeInsetsMake(10,0, 0, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    CGFloat eachPostCardWidth = postCardViewWidth + postCardGap;
    int numberOfPostcard = [self.postCards count];
    
    _scrollView.contentSize = CGSizeMake( eachPostCardWidth * numberOfPostcard, postCardViewHeight);
    
    for (int i=0; i<numberOfPostcard; i++) {
        CGFloat xPosition = i * eachPostCardWidth;
        CGRect xFrame = CGRectMake( xPosition, 0, postCardViewWidth, postCardViewHeight);
        FVPostCardLandScapeView *postCardView = [[FVPostCardLandScapeView alloc] initWithFrame:xFrame];
        postCardView.postCard = self.postCards[i];
        
        [_scrollView addSubview:postCardView];
    }
    
    [self addSubview:_scrollView];
}

-(void)setPostCards:(NSArray *)postCards
{
    _postCards = postCards;
    [self setup];
}

@end
