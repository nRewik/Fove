//
//  FVFriendViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVFriendSegmentedViewController.h"
#import "FVUser.h"
#import "FVProfileViewController.h"

@interface FVFriendSegmentedViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sengmentedControl;
@property (strong, nonatomic) IBOutlet UIViewController *currentViewController;

@property (strong,nonatomic) UIViewController *firstVC;
@property (strong,nonatomic) UIViewController *secondVC;


@end

#define friendStoryboardID @"friendViewController"
#define galleryStoryboardID @"galleryViewController"

@implementation FVFriendSegmentedViewController

#pragma mark - Segmendted VC
-(UIViewController *)firstVC
{
    if (!_firstVC) {
        _firstVC = [self.storyboard instantiateViewControllerWithIdentifier:friendStoryboardID];
    }
    return _firstVC;
}
-(UIViewController *)secondVC
{
    if (!_secondVC) {
        _secondVC = [self.storyboard instantiateViewControllerWithIdentifier:galleryStoryboardID];
    }
    return _secondVC;
}
#pragma mark - 

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIViewController *vc = [self viewControllerForSegmentIndex:self.sengmentedControl.selectedSegmentIndex];
    [self addChildViewController:vc];
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    self.currentViewController = vc;
}


- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    UIViewController *vc = [self viewControllerForSegmentIndex:sender.selectedSegmentIndex];
    [self addChildViewController:vc];
    [self transitionFromViewController:self.currentViewController toViewController:vc duration:0.0 options:0 animations:^{
        [self.currentViewController.view removeFromSuperview];
        vc.view.frame = self.contentView.bounds;
        [self.contentView addSubview:vc.view];
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = vc;
    }];
    self.navigationItem.title = vc.title;
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index)
    {
        case 0:
            vc = self.firstVC;
            break;
        case 1:
            vc = self.secondVC;
            break;
    }
    return vc;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



@end
