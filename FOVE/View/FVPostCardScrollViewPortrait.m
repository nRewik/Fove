//
//  FVPostCardScrollViewPortrait.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/15/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVPostCardScrollViewPortrait.h"
#import "FVPostCardView.h"

#define postCardViewWidth 300
#define postCardViewHeight 188
#define postCardGap 10

@implementation FVPostCardScrollViewPortrait
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
    _scrollView.contentInset = UIEdgeInsetsMake(10,0, 0, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    CGFloat eachPostCardHeight = postCardViewHeight + postCardGap;
    int numberOfPostcard = [self.postCards count];
    
    _scrollView.contentSize = CGSizeMake(postCardViewWidth, eachPostCardHeight*numberOfPostcard);
    
    for (int i=0; i<numberOfPostcard; i++) {
        CGFloat yPosition = i * eachPostCardHeight;
        CGRect xFrame = CGRectMake(0, yPosition, postCardViewWidth, postCardViewHeight);
        FVPostCardView *postCardView = [[FVPostCardView alloc] initWithFrame:xFrame];
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
