//
//  FVCreatePostCardViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVCreatePostCardViewController.h"
#import "FVCreatePostCardView.h"

@interface FVCreatePostCardViewController () <FVCreatePostCardViewDelegate>

@property (weak, nonatomic) IBOutlet FVCreatePostCardView *createPostCardView;

@end

@implementation FVCreatePostCardViewController


#pragma mark - view controller stuff
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.createPostCardView.delegate = self;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - FVCreatePostCardDelegate
-(void)didCancelCreatePostCard
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
