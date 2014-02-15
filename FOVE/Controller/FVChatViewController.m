//
//  FVChatViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVChatViewController.h"
#import "FVPostCardScrollViewPortrait.h"
#import "FVPostCard.h"

@interface FVChatViewController ()

@property (weak, nonatomic) IBOutlet FVPostCardScrollViewPortrait *postCardScrollView;

@end

@implementation FVChatViewController

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
