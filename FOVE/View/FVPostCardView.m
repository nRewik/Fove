//
//  FVPostCardView.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/14/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVPostCardView.h"

@implementation FVPostCardView
{
    UIImageView *_frontView;
    UIImageView *_backView;
    BOOL _isFlip;
    BOOL _isLockToFlip;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
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
    _frontView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    _frontView.contentMode = UIViewContentModeScaleAspectFill;
    _backView.contentMode = UIViewContentModeScaleAspectFill;
    
    _frontView.clipsToBounds = YES;
    _backView.clipsToBounds = YES;
    
    [self addSubview:_frontView];
    
    _isFlip = NO;
    _isLockToFlip = NO;
    
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
    UIView *originView = _isFlip ? _backView: _frontView;
    UIView *destinationView = _isFlip ? _frontView : _backView;
    
    [UIView transitionFromView:originView
                        toView:destinationView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished)
                        {
                            _isFlip = !_isFlip;
                        }
                        _isLockToFlip = NO;
                    }
     ];
}

-(void)setWithFrontImage:(UIImage *)frontImage backImage:(UIImage *)backImage
{
    self.frontImage = frontImage;
    self.backImage = backImage;
}

-(void)setFrontImage:(UIImage *)frontImage
{
    _frontImage = frontImage;
    _frontView.image = self.frontImage;
}
-(void)setBackImage:(UIImage *)backImage
{
    _backImage = backImage;
    _backView.image = self.backImage;
}

@end
