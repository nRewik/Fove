//
//  FVFriendViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVFriendViewController.h"
#import "FVUser.h"
#import "FVProfileViewController.h"

@interface FVFriendViewController ()

@property (weak, nonatomic) IBOutlet UILabel *harryPotterLabel; //mock up

@property (strong,nonatomic) FVUser *selectedUser;
@end

#define chatSegueID @"chat"

@implementation FVFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //mock up
    UIGestureRecognizer *tabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToChat)];
    [self.harryPotterLabel addGestureRecognizer:tabGesture];
    self.harryPotterLabel.userInteractionEnabled = YES;
    //
}
- (void)goToChat
{
    [self performSegueWithIdentifier:chatSegueID sender:self];
}

-(void)viewProfile:(UIGestureRecognizer *)gestureRecognizer
{
    self.selectedUser = [FVUser currentUser];
    [self performSegueWithIdentifier:@"viewProfile" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destination = segue.destinationViewController;
    if ( [destination isKindOfClass:[FVProfileViewController class]]) {
        if ([segue.identifier isEqualToString:@"viewProfile"]) {
            FVProfileViewController *pfvc = (FVProfileViewController *)destination;
            pfvc.user = self.selectedUser;
        }
    }
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
