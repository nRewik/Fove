//
//  FVPostCardLandScapeView.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/15/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVPostCardLandScapeView.h"

#define flipDuration 1

@implementation FVPostCardLandScapeView
{
    BOOL _isLockToFlip;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self FVPostCardLandScapeViewSetup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self FVPostCardLandScapeViewSetup];
    }
    return self;
}

-(void)FVPostCardLandScapeViewSetup
{
    UISwipeGestureRecognizer *postCardSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flip:)];
    postCardSwipeLeft.direction = UISwipeGestureRecognizerDirectionDown;
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
                       options:UIViewAnimationOptionTransitionFlipFromBottom
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
