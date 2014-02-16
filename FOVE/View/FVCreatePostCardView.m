//
//  FVCreatePostCardView.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVCreatePostCardView.h"
#import "FVPostCardView.h"

@interface FVCreatePostCardView () <UIScrollViewDelegate>
@end

@implementation FVCreatePostCardView
{
    UIScrollView *_scrollView;
    UIView *_toolBarView;
    
    FVPostCardView *_postCardView;
    FVPostCard *_postCard;
}

#define toolbarWidth 100
#define imageRatio 1.6

-(void)awakeFromNib
{
    [self FVCreatePostCardViewSetup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self FVCreatePostCardViewSetup];
    }
    return self;
}

-(void)FVCreatePostCardViewSetup
{
    [_scrollView removeFromSuperview];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.opaque = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    CGFloat phoneHeight = self.bounds.size.height;
    
    CGRect toolbarFrame = CGRectMake(0,0, toolbarWidth,phoneHeight);
    _toolBarView = [[UIView alloc] initWithFrame:toolbarFrame];
    
    
    CGFloat postCardWidth = phoneHeight * imageRatio;
    CGFloat postCardHeight = phoneHeight;
//    if ( imageWidth  > self.frame.size.width )
//    {
//        imageWidth = self.frame.size.width;
//        imageHeight = self.frame.size.width / imageRatio;
//    }
    CGRect postCardFrame = CGRectMake(toolbarWidth, 0, postCardWidth, postCardHeight);
    _postCardView = [[FVPostCardView alloc] initWithFrame:postCardFrame];
    
    _scrollView.contentSize = CGSizeMake( toolbarWidth + postCardWidth , phoneHeight);
    [_scrollView addSubview:_toolBarView];
    [_scrollView addSubview:_postCardView];
    
    [self addSubview:_scrollView];
    
    
    //mock up
    _toolBarView.backgroundColor = [UIColor redColor];
    
    UIImage *frontImage = [UIImage imageNamed:@"test_postcard_back_2"];
    UIImage *backImage = [UIImage imageNamed:@"test_postcard_front_2"];
    FVPostCard *postCard = [[FVPostCard alloc] initWithFrontImage:frontImage backImage:backImage];
    _postCardView.postCard = postCard;
    //
    
    [self zoomToPostCard];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat maxOffset = scrollView.contentSize.width - self.bounds.size.width;
    CGFloat imageOffset = maxOffset - scrollView.contentOffset.x;
    
    CGFloat imageWidth = _postCardView.bounds.size.width;
    CGFloat imageScaleWidth = imageWidth - imageOffset*2;
    CGFloat scale = imageScaleWidth / imageWidth;
    
    CGAffineTransform scaleTransfrom = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    CGAffineTransform translate = CGAffineTransformMakeTranslation( -imageOffset/2 , 0);
    _postCardView.transform = CGAffineTransformConcat(scaleTransfrom, translate);
}

-(void)zoomToPostCard
{
    [_scrollView setContentOffset:CGPointMake( _scrollView.contentSize.width - self.bounds.size.width  , 0) animated:YES];
}


@end
