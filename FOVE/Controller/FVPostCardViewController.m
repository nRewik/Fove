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
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)setPostcard:(FVPostCard *)postcard
{
    _postcard = postcard;
    self.postcardView.postCard = self.postcard;
}

#pragma mark - Action
- (IBAction)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)share:(id)sender
{
    UIImage *shareImage = [(UIImageView *)self.postcardView.currentView image];
    NSArray *activitiesItems = @[shareImage];
    UIActivityViewController *acticityView = [[UIActivityViewController alloc] initWithActivityItems:activitiesItems applicationActivities:nil];
    acticityView.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard];
    [self presentViewController:acticityView animated:YES completion:nil];
}
@end
