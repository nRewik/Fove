//
//  FVPostCardView.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/14/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVPostCardPortraitView.h"

#define flipDuration 1

@implementation FVPostCardPortraitView
{
    BOOL _isLockToFlip;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self FVPostCardPortraitViewSetup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self FVPostCardPortraitViewSetup];
    }
    return self;
}

-(void)FVPostCardPortraitViewSetup
{
    UISwipeGestureRecognizer *postCardSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flip:)];
    postCardSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:postCardSwipeLeft];
    self.userInteractionEnabled = YES;
}

-(void)flip:(UIGestureRecognizer *)gestureRecognizer
{
    if (_isLockToFlip) {
        return;
    }
    _isLockToFlip = YES;
    UIView *originView = self.postCard.isFlip ? self.backView: self.frontView;
    UIView *destinationView = self.postCard.isFlip ? self.frontView : self.backView;
    
    [UIView transitionFromView:originView
                        toView:destinationView
                      duration:flipDuration
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished)
                        {
                            self.postCard.isFlip = !self.postCard.isFlip;
                        }
                        _isLockToFlip = NO;
                    }
     ];
}

@end
