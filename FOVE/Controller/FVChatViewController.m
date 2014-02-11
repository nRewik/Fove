//
//  FVChatViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVChatViewController.h"

@interface FVChatViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *artImageView;
@property (weak, nonatomic) IBOutlet UIImageView *catImageView;

@property (weak, nonatomic) IBOutlet UIView *postCardView;
@property (strong, nonatomic) UIImageView *postCardFrontView;
@property (strong, nonatomic) UIImageView *postCardBackView;
@property (weak, nonatomic) IBOutlet UIView *postCardContainer;

@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong,nonatomic) UIView *previousView;
@property (strong,nonatomic) UIView *nextView;

@property (nonatomic) BOOL isFlip;
@property (nonatomic) BOOL isLockPostcardChange;
@property (nonatomic) NSInteger count;

@end

@implementation FVChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"< Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    self.artImageView.image = [UIImage imageNamed:@"test_art.png"];
    self.catImageView.image = [UIImage imageNamed:@"test_cat.png"];
    
    self.postCardFrontView = [[UIImageView alloc] initWithFrame:self.postCardView.bounds];
    self.postCardBackView = [[UIImageView alloc] initWithFrame:self.postCardView.bounds];
    
    [self randomNewImagePostCard];
    
    [self.postCardView addSubview:self.postCardFrontView];
    
    UISwipeGestureRecognizer *postCardSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flip:)];
    postCardSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.postCardView addGestureRecognizer:postCardSwipeLeft];
    self.postCardView.userInteractionEnabled = YES;

    self.count = 0;
    self.nextButton.hidden = YES;
}

-(void)randomNewImagePostCard
{
    NSInteger idx = arc4random() % 4;
    self.postCardFrontView.image = [UIImage imageNamed:[NSString stringWithFormat:@"test_postcard_front_%d",idx]];
    self.postCardBackView.image = [UIImage imageNamed:[NSString stringWithFormat:@"test_postcard_back_%d",idx]];

}
-(UIView *)getNewPostCard
{
    UIView *newPostCard = [[UIView alloc] initWithFrame:self.postCardView.frame];
    
    [newPostCard addSubview:self.postCardBackView];
    [newPostCard addSubview:self.postCardFrontView];
    
    [self randomNewImagePostCard];
    
    [newPostCard addGestureRecognizer:[[self.postCardView gestureRecognizers] firstObject]];
    return newPostCard;

}

- (IBAction)previous
{
    if ( ! self.isLockPostcardChange )
    {
        self.isLockPostcardChange = YES;
        
        UIView *newPostCard = [self getNewPostCard];

        [UIView transitionFromView:self.postCardView
                            toView:newPostCard
                          duration:1
                           options:UIViewAnimationOptionTransitionCurlDown
                        completion:^(BOOL finished) {
                            self.postCardView = newPostCard;
                            self.isFlip = NO;
                            self.count = self.count - 1;
                            self.nextButton.hidden = self.count == 0;
                            self.isLockPostcardChange = NO;
                        }];
    }
    
}
- (IBAction)next
{
    if ( ! self.isLockPostcardChange)
    {
        self.isLockPostcardChange = YES;

        UIView *newPostCard = [self getNewPostCard];
        
        [UIView transitionFromView:self.postCardView
                            toView:newPostCard
                          duration:1
                           options:UIViewAnimationOptionTransitionCurlUp
                        completion:^(BOOL finished) {
                            self.postCardView = newPostCard;
                            self.isFlip = NO;
                            self.count = self.count + 1;
                            self.nextButton.hidden = self.count == 0;
                            self.isLockPostcardChange = NO;
                        }];
        
    }
}

-(void)flip:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *originView = self.isFlip ? self.postCardBackView : self.postCardFrontView;
    UIView *destinationView = self.isFlip ? self.postCardFrontView : self.postCardBackView;

    [UIView transitionFromView:originView
                        toView:destinationView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished)
                        {
                            self.isFlip = !self.isFlip;
                        }
                    }
     ];
}

-(void)goBack
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
