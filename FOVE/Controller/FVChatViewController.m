//
//  FVChatViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVChatViewController.h"
#import "FVPostCard.h"
#import "FVPostCardPortraitView.h"

@interface FVChatViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *chatNavigationItem;
@property (weak, nonatomic) IBOutlet FVPostCardPortraitView *postCardViewGirl;
@property (weak, nonatomic) IBOutlet FVPostCardPortraitView *postCardViewBoy;

@end

@implementation FVChatViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //todo
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.chatNavigationItem.title = self.friend.name;
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"< Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    FVPostCard *postCardBoy = [[FVPostCard alloc] initWithFrontImage:[self randomFronTImagePostCard] backImage:[self randomBackImagePostCard]];
    FVPostCard *postCardGirl = [[FVPostCard alloc] initWithFrontImage:[self randomFronTImagePostCard] backImage:[self randomBackImagePostCard]];

    self.postCardViewBoy.postCard = postCardBoy;
    self.postCardViewGirl.postCard = postCardGirl;
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
- (IBAction)goBack:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
