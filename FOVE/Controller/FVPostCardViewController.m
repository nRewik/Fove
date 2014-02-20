//
//  FVPostCardViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/20/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVPostCardViewController.h"
#import "FVPostCardPortraitView.h"

@interface FVPostCardViewController ()
@property (weak, nonatomic) IBOutlet FVPostCardPortraitView *postcardView;

@end

@implementation FVPostCardViewController

#pragma mark - view controller state
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.postcardView.postCard = self.postcard;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}



-(void)setPostcard:(FVPostCard *)postcard
{
    _postcard = postcard;
    self.postcardView.postCard = self.postcard;
}
@end
