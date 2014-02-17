//
//  FVCreatePostCardView.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVCreatePostCardView.h"
#import "FVPostCardView.h"

@interface FVCreatePostCardView ()
@end

@implementation FVCreatePostCardView
{
    UIView *_toolBarView;
    UIView *_toolBarDetailView;
    
    FVPostCardView *_postCardView;
    BOOL _isFlip;
    
    UIButton *_addStickerButton;
    UIButton *_addPhotoButton;
    UIButton *_flipButton;
    
    NSArray *toolBarButtons;
}

#define TOOLBAR_WIDTH 56
#define imageRatio 1.6

#define FLIP_DUTATION 1.0

#define BUTTON_WIDTH 56
#define BUTTON_HEIGHT 56

#define LINEBREAK_HEIGHT 2
#define LINEBREAK_WIDTH 50

#define BUTTON_ADD_STICKER_NAME @"add_sticker_button_2"
#define BUTTON_ADD_TEXT_NAME @"add_text_button"
#define BUTTON_ADD_PHOTO_NAME @"add_picture_button"
#define BUTTON_LOAD_POSTCARD_TEMPLATE_NAME @"load_postcard_button"
#define BUTTON_FLIP_POSTCARD_NAME @"flip_postcard_button"
#define BUTTON_BACKBUTTON @"back_button"
#define BUTTON_OK_BUTTON_NAME @"end_button"



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
    self.backgroundColor = [UIColor blackColor];
    
    CGFloat phoneHeight = self.bounds.size.height;
    
    CGRect toolbarFrame = CGRectMake(0,0, TOOLBAR_WIDTH,phoneHeight);
    _toolBarView = [[UIView alloc] initWithFrame:toolbarFrame];
    
    CGFloat postCardWidth = phoneHeight * imageRatio;
    CGFloat postCardHeight = phoneHeight;
    
    CGRect postCardFrame = CGRectMake(TOOLBAR_WIDTH, 0, postCardWidth, postCardHeight);
    _postCardView = [[FVPostCardView alloc] initWithFrame:postCardFrame];
    
    _isFlip = NO;
    
    _toolBarDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TOOLBAR_WIDTH, phoneHeight)];
    
    [self setupButton];
    
    [self addSubview:_postCardView];
    [self addSubview:_toolBarDetailView];
    [self addSubview:_toolBarView];
    
    //mock up
    _toolBarView.backgroundColor = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1.000];
    _toolBarDetailView.backgroundColor = [UIColor grayColor];
    
    UIImage *frontImage = [UIImage imageNamed:@"test_postcard_back_2"];
    UIImage *backImage = [UIImage imageNamed:@"test_postcard_front_2"];
    FVPostCard *postCard = [[FVPostCard alloc] initWithFrontImage:frontImage backImage:backImage];
    _postCardView.postCard = postCard;
}

#pragma mark - add button
-(void)setupButton
{
    NSArray *buttonImageNames = @[BUTTON_ADD_STICKER_NAME,
                                  BUTTON_ADD_TEXT_NAME,
                                  BUTTON_ADD_PHOTO_NAME,
                                  BUTTON_LOAD_POSTCARD_TEMPLATE_NAME,
                                  BUTTON_FLIP_POSTCARD_NAME ];
    
    for (int i=0; i<[buttonImageNames count]; i++) {
        [self addButton:buttonImageNames[i] order:i+1];
    }
    
    [self setupFlipButton];
    [self setupAddStickerButton];
}

-(void)addButton:(NSString *)buttonImageName order:(NSUInteger)order
{
    CGRect frame = CGRectMake( 0 , (BUTTON_HEIGHT+LINEBREAK_HEIGHT) * (order - 1), BUTTON_WIDTH, BUTTON_HEIGHT);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    UIImage *buttonImage = [UIImage imageNamed:buttonImageName];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    CGRect lineBreakFrame = CGRectMake(  TOOLBAR_WIDTH/2 - LINEBREAK_WIDTH/2,
                                       (BUTTON_HEIGHT+LINEBREAK_HEIGHT) * (order - 1) + BUTTON_HEIGHT,
                                       LINEBREAK_WIDTH,
                                       LINEBREAK_HEIGHT
                                       );
    UIView *lineBreak = [[UIView alloc] initWithFrame:lineBreakFrame];
    lineBreak.backgroundColor = [UIColor whiteColor];
    [_toolBarView addSubview:lineBreak];
    
    [_toolBarView addSubview:button];
    
    if ([buttonImageName isEqualToString:BUTTON_FLIP_POSTCARD_NAME]){
        _flipButton = button;
    }
    else if ([buttonImageName isEqualToString:BUTTON_ADD_STICKER_NAME]){
        _addStickerButton = button;
    }
}


#pragma mark - add sticker button
-(void)setupAddStickerButton
{
    [_addStickerButton addTarget:self action:@selector(addSticker) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addSticker
{
    //mockup animation
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint newCenter = CGPointMake( _toolBarView.center.x + TOOLBAR_WIDTH , _toolBarView.center.y);
        _toolBarDetailView.center = newCenter;
    }];
}


#pragma mark - flip button
-(void)setupFlipButton
{
    [_flipButton addTarget:self action:@selector(flipPostCard) forControlEvents:UIControlEventTouchUpInside];
}
-(void)flipPostCard
{
    UIView *originView = _postCardView.postCard.isFlip ? _postCardView.backView: _postCardView.frontView;
    UIView *destinationView = _postCardView.postCard.isFlip ? _postCardView.frontView : _postCardView.backView;
    [UIView transitionFromView:originView
                        toView:destinationView
                      duration:FLIP_DUTATION
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished)
                        {
                            _postCardView.postCard.isFlip  = !_postCardView.postCard.isFlip ;
                        }
                    }
     ];
}





























@end