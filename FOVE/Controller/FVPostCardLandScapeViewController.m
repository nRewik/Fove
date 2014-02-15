//
//  FVPostCardLandScapeViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/15/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVPostCardLandScapeViewController.h"
#import "FVPostCardScrollViewLandScape.h"
#import "FVPostCard.h"

@interface FVPostCardLandScapeViewController ()

@property (weak, nonatomic) IBOutlet FVPostCardScrollViewLandScape *postCardScrollView;

@end

@implementation FVPostCardLandScapeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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


@end
