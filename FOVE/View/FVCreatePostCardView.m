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
    
    UIButton *_backButton;
    
    NSArray *toolBarButtons;
}

#define TOOLBAR_WIDTH 56
#define IMAGE_RATIO 1.6

#define FLIP_DUTATION 1.0

#define BUTTON_WIDTH 56
#define BUTTON_HEIGHT 40

#define BUTTON_ADD_STICKER_NAME @"add_sticker_button"
#define BUTTON_ADD_TEXT_NAME @"add_text_button"
#define BUTTON_LOAD_POSTCARD_TEMPLATE_NAME @"load_postcard_button"
#define BUTTON_FLIP_POSTCARD_NAME @"click_flip_button"
#define BUTTON_BACKBUTTON_NAME @"click_back_button"
#define BUTTON_OK_BUTTON_NAME @"click_done_button"



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
    
    CGFloat postCardWidth = phoneHeight * IMAGE_RATIO;
    CGFloat postCardHeight = phoneHeight;
    
    CGRect postCardFrame = CGRectMake(TOOLBAR_WIDTH, 0, postCardWidth, postCardHeight);
    _postCardView = [[FVPostCardView alloc] initWithFrame:postCardFrame];
    
    _isFlip = NO;
    
    _toolBarDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TOOLBAR_WIDTH, phoneHeight)];
    
    [self setupToolBarButtons];
    
    [self addSubview:_postCardView];
    [self addSubview:_toolBarDetailView];
    [self addSubview:_toolBarView];
    
    //mock up
    _toolBarView.backgroundColor = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1.000];
    _toolBarDetailView.backgroundColor = [UIColor grayColor];
    
    UIImage *frontImage = [UIImage imageNamed:@"postcard_back_template"];
    UIImage *backImage = [UIImage imageNamed:@"test_postcard_front_2"];
    FVPostCard *postCard = [[FVPostCard alloc] initWithFrontImage:frontImage backImage:backImage];
    _postCardView.postCard = postCard;
}

#pragma mark - add toolbar buttons
-(void)setupToolBarButtons
{
    NSArray *buttonImageNames = @[BUTTON_ADD_STICKER_NAME,
                                  BUTTON_ADD_TEXT_NAME,
                                  BUTTON_LOAD_POSTCARD_TEMPLATE_NAME,
                                  BUTTON_FLIP_POSTCARD_NAME,
                                  BUTTON_OK_BUTTON_NAME
                                  ];
    
    [buttonImageNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addToolBarButton:buttonImageNames[idx] order:idx+1];
    }];
    
    [self addBackButton];
}
-(void)addToolBarButton:(NSString *)buttonImageName order:(NSUInteger)order
{
    //toolbar button
    CGRect frame = CGRectMake( 0 , BUTTON_HEIGHT * (order - 1), BUTTON_WIDTH, BUTTON_HEIGHT);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    UIImage *buttonImage = [UIImage imageNamed:buttonImageName];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_toolBarView addSubview:button];
    ////
    
    //set button reference
    if ([buttonImageName isEqualToString:BUTTON_FLIP_POSTCARD_NAME]){
        _flipButton = button;
        [self setupFlipButton];
    }
    else if ([buttonImageName isEqualToString:BUTTON_ADD_STICKER_NAME]){
        _addStickerButton = button;
        [self setupAddStickerButton];
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

#pragma mark - back button
-(void)addBackButton
{
    CGRect frame = CGRectMake(0,self.frame.size.height-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
    _backButton = [[UIButton alloc] initWithFrame:frame];
    UIImage *backButtonImage = [UIImage imageNamed:BUTTON_BACKBUTTON_NAME];
    [_backButton setImage:backButtonImage forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolBarView addSubview:_backButton];
}
-(void)goBack
{
    [self.delegate didCancelCreatePostCard];
}




























@end