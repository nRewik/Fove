//
//  FVChatViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVPostCardPortraitViewController.h"
#import "FVPostCardScrollViewPortrait.h"
#import "FVPostCard.h"

@interface FVPostCardPortraitViewController ()

@property (weak, nonatomic) IBOutlet FVPostCardScrollViewPortrait *postCardScrollView;

@end

@implementation FVPostCardPortraitViewController
{
    BOOL _isShowingLandscapeView;
}

- (void)awakeFromNib
{
    _isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !_isShowingLandscapeView){
        [self performSegueWithIdentifier:@"viewPostCardLandScape" sender:self];
        _isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) && _isShowingLandscapeView){
        [self dismissViewControllerAnimated:YES completion:nil];
        _isShowingLandscapeView = NO;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //todo
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"< Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    NSMutableArray *postCards = [[NSMutableArray alloc] init];
    for (int i=0; i<5; i++) {
        UIImage *frontImage = [self randomFronTImagePostCard];
        UIImage *backImage = [self randomBackImagePostCard];
        FVPostCard *postCard = [[FVPostCard alloc] initWithFrontImage:frontImage backImage:backImage];
        
        [postCards addObject:postCard];
    }
    self.postCardScrollView.postCards = postCards;
}

-(UIImage *)randomFronTImagePostCard
{
    NSInteger idx = arc4random() % 4;
    return [UIImage imageNamed:[NSString stringWithFormat:@"test_postcard_front_%d",idx]];
}
-(UIImage *)randomBackImagePostCard
{
    NSInteger idx = arc4random() % 4;
    return [UIImage imageNamed:[NSString stringWithFormat:@"test_postcard_back_%d",idx]];
}

-(void)goBack
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
