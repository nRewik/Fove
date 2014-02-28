//
//  FVCreatePostCardView.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVCreatePostCardView.h"
#import "FVPostCardView.h"

@interface FVCreatePostCardView () <UIAlertViewDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) FVPostCardView *postCardView;

@property (strong,nonatomic) UIButton *addStickerButton;
@property (strong,nonatomic) UIActionSheet *stickerActionSheet;


@end

@implementation FVCreatePostCardView
{
    UIView *_toolBarView;
    UIView *_toolBarDetailView;
    
    BOOL _isFlip;
    
    //add text
    UIButton *_addTextButton;
    UIAlertView *_addTextAlertView;
    
    UIButton *_setPostcardImageButton;
    UIButton *_flipButton;
    UIButton *_doneButton;
    UIButton *_backButton;
    
    NSArray *toolBarButtons;
}

#define DEGREE_TO_RADIAN(degree) ((degree) / 180.0 * M_PI)
#define RADIAN_TO_DEGREE(radian) ((radian) * 180.0 / M_PI)

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
    
    _postCardView.userInteractionEnabled = YES;
    _postCardView.backView.userInteractionEnabled = YES;
    _postCardView.frontView.userInteractionEnabled = YES;
    
    //mock up
    _toolBarView.backgroundColor = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1.000];
    _toolBarDetailView.backgroundColor = [UIColor grayColor];
    
    UIImage *frontImage = [UIImage imageNamed:@"postcard_back_template"];
    UIImage *backImage = [UIImage imageNamed:@"test_postcard_front_2"];
    FVPostCard *postCard = [[FVPostCard alloc] initWithFrontImage:frontImage backImage:backImage];
    _postCardView.postCard = postCard;
}

-(void)setImageOfCurrentView:(UIImage *)image
{
    if (image != nil) {
        UIImageView *currentImageView = (UIImageView *)_postCardView.currentView;
        currentImageView.image = image;
    }
}

#pragma mark - Lazy Instantiation
-(UIActionSheet *)stickerActionSheet
{
    if (!_stickerActionSheet) {
        _stickerActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Sticker"
                                                          delegate:self
                                                 cancelButtonTitle:@"cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"USA",@"Cupcake",@"Heart", nil];
    }
    return _stickerActionSheet;
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
        self.addStickerButton = button;
        [self setupAddStickerButton];
    }
    else if( [buttonImageName isEqualToString:BUTTON_ADD_TEXT_NAME]){
        _addTextButton = button;
        [self setUpAddTextButton];
    }
    else if( [buttonImageName isEqualToString:BUTTON_OK_BUTTON_NAME]){
        _doneButton = button;
        [self setupDoneButton];
    }
    else if( [buttonImageName isEqualToString:BUTTON_LOAD_POSTCARD_TEMPLATE_NAME])
    {
        _setPostcardImageButton = button;
        [self setupSetPostcardImageButton];
    }
}
#pragma mark - SetPostcardImage Button
-(void)setupSetPostcardImageButton
{
    [_setPostcardImageButton addTarget:self action:@selector(setPostcardImage) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setPostcardImage
{
    [self.delegate didSelectSetImageButton];
}


#pragma mark - add Text Button
-(void)setUpAddTextButton
{
    [_addTextButton addTarget:self action:@selector(addText) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addText
{
    _addTextAlertView = [[UIAlertView alloc] initWithTitle:@"Add Text"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Add", nil];
    _addTextAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [_addTextAlertView show];
}

#pragma mark - add sticker button
-(void)setupAddStickerButton
{
    [self.addStickerButton addTarget:self action:@selector(addSticker) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addSticker
{
    [self.stickerActionSheet showInView:self];
}


#pragma mark - flip button
-(void)setupFlipButton
{
    [_flipButton addTarget:self action:@selector(flipPostCard) forControlEvents:UIControlEventTouchUpInside];
}
-(void)flipPostCard
{
    UIView *originView = self.postCardView.postCard.isFlip ? self.postCardView.backView: self.postCardView.frontView;
    UIView *destinationView = self.postCardView.postCard.isFlip ? self.postCardView.frontView : self.postCardView.backView;
    [UIView transitionFromView:originView
                        toView:destinationView
                      duration:FLIP_DUTATION
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished)
                        {
                            self.postCardView.postCard.isFlip  = !self.postCardView.postCard.isFlip ;
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


#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == self.stickerActionSheet)
    {
        if (buttonIndex != self.stickerActionSheet.numberOfButtons-1) {
            NSString *stickerName = [NSString stringWithFormat:@"sticker_%d",buttonIndex];
            UIImage *stickerImage = [UIImage imageNamed:stickerName];
            UIImageView *stickImageView = [[UIImageView alloc] initWithImage:stickerImage];
            
            CGFloat xPos = self.postCardView.bounds.size.width/2;
            CGFloat yPos = self.postCardView.bounds.size.height/2;
            stickImageView.center = CGPointMake(xPos, yPos);
            [self.postCardView.currentView addSubview:stickImageView];
            
            [self addGestureToPostcardComponent:stickImageView];
        }
    }
    NSLog(@"%d",buttonIndex);
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //add button
    if (alertView == _addTextAlertView && buttonIndex == 1)
    {
        UILabel *Textlabel = [[UILabel alloc] init];
        Textlabel.textColor = [UIColor blackColor];
        Textlabel.backgroundColor = [UIColor clearColor];
        Textlabel.font = [UIFont systemFontOfSize:30.0f];
        Textlabel.textAlignment = NSTextAlignmentCenter;

        Textlabel.adjustsFontSizeToFitWidth = YES;
        Textlabel.minimumScaleFactor = 8./14.;
        Textlabel.numberOfLines = 1;
        
        Textlabel.text = [[alertView textFieldAtIndex:0] text];
        [Textlabel sizeToFit];
        
        CGFloat xPos = self.postCardView.bounds.size.width/2;
        CGFloat yPos = self.postCardView.bounds.size.height/2;
        Textlabel.center = CGPointMake(xPos, yPos);
        
        [self.postCardView.currentView addSubview:Textlabel];
        
        [self addGestureToPostcardComponent:Textlabel];
    }
}

#pragma mark - Gesture Selector

-(void)addGestureToPostcardComponent:(UIView *)view
{
    UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAccessory:)];
    [view addGestureRecognizer:panGesture];
    
    UIGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleAccessory:)];
    [view addGestureRecognizer:pinchGesture];
    
    UIGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateAccessory:)];
    [view addGestureRecognizer:rotationGesture];
    
    view.userInteractionEnabled = YES;
}



-(void)moveAccessory:(UIPanGestureRecognizer *)panRecognizer
{
    if (panRecognizer.numberOfTouches != 1){
        return;
    }
    
    UIView *accView = panRecognizer.view;
    CGPoint translation = [panRecognizer translationInView:accView];
    accView.center = CGPointMake(panRecognizer.view.center.x+translation.x, panRecognizer.view.center.y + translation.y);
    
    [panRecognizer setTranslation:CGPointMake(0, 0) inView:accView];
}
-(void)scaleAccessory:(UIPinchGestureRecognizer *)pinchRecognizer
{
    UIView *accView = pinchRecognizer.view;
    
    if ([accView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)accView;
        CGPoint oldCenter = label.center;
        
        CGFloat pinchScale = pinchRecognizer.scale;
        label.font = [UIFont fontWithName:label.font.fontName size:(label.font.pointSize*pinchScale)];
        
        [label sizeToFit];
        label.center = oldCenter;
        
    }
    else
    {
        CGRect frame = accView.frame;
        frame.size.width = frame.size.width * pinchRecognizer.scale;
        frame.size.height = frame.size.height * pinchRecognizer.scale;
        accView.frame = frame;
    }
    pinchRecognizer.scale = 1.0;
}
-(void)rotateAccessory:(UIRotationGestureRecognizer *)rotationGesture
{
    UIView *accView = rotationGesture.view;
    accView.transform = CGAffineTransformMakeRotation(rotationGesture.rotation);
}


#pragma mark - done button
-(void)setupDoneButton
{
    [_doneButton addTarget:self action:@selector(finishCreatePostCard) forControlEvents:UIControlEventTouchUpInside];
}
-(void)finishCreatePostCard
{
    UIImage *frontImage = [self snapshot:self.postCardView.frontView];
    UIImage *backImage = [self snapshot:self.postCardView.backView];
    FVPostCard *newPostCard = [[FVPostCard alloc] initWithFrontImage:frontImage backImage:backImage];
    [self.delegate didFinishCreatePostCard:newPostCard];
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}









@end