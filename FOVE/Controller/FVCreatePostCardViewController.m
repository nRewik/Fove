//
//  FVCreatePostCardViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVCreatePostCardViewController.h"
#import "FVCreatePostCardView.h"
#import "FVPostCardViewController.h"

@interface FVCreatePostCardViewController () <FVCreatePostCardViewDelegate>

@property (weak, nonatomic) IBOutlet FVCreatePostCardView *createPostCardView;

@property (strong,nonatomic) FVPostCard *createdPostcard;

@end

@implementation FVCreatePostCardViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewPostcard"]) {
        UIViewController *vc = segue.destinationViewController;
        if ([vc isKindOfClass:[FVPostCardViewController class]]) {
            FVPostCardViewController *pcvc = (FVPostCardViewController *)vc;
            pcvc.postcard = self.createdPostcard;
        }
    }
}
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
-(void)didFinishCreatePostCard:(FVPostCard *)postCard
{
    self.createdPostcard = postCard;
    [self performSegueWithIdentifier:@"viewPostcard" sender:self];
}


@end
