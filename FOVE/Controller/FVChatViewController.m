//
//  FVChatViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVChatViewController.h"
#import "FVPostCardView.h"

@interface FVChatViewController ()

@property (strong, nonatomic) IBOutlet FVPostCardView *postCardView;

@end

@implementation FVChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"< Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    [self randomNewImagePostCard];
}

-(void)randomNewImagePostCard
{
    NSInteger idx = arc4random() % 4;
    self.postCardView.frontImage = [UIImage imageNamed:[NSString stringWithFormat:@"test_postcard_front_%d",idx]];
    self.postCardView.backImage = [UIImage imageNamed:[NSString stringWithFormat:@"test_postcard_back_%d",idx]];
}

-(void)goBack
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
