//
//  FVCreatePostCardViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVCreatePostCardViewController.h"
#import "FVCreatePostCardView.h"

@interface FVCreatePostCardViewController ()
@property (weak, nonatomic) IBOutlet FVCreatePostCardView *createPostCardView;
@end

@implementation FVCreatePostCardViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
