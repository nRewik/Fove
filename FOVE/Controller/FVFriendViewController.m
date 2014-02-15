//
//  FVFriendViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVFriendViewController.h"
#import "FVUser.h"
#import "FVProfileViewController.h"

@interface FVFriendViewController () <UIGestureRecognizerDelegate>

//mock up
@property (weak, nonatomic) IBOutlet UIImageView *chatchatImageView;
@property (weak, nonatomic) IBOutlet UILabel *goToChatTab;

@property (strong,nonatomic) FVUser *selectedUser;

@end

@implementation FVFriendViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //mock up
    UITapGestureRecognizer *tapChatChat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewChatChatProfile)];
    tapChatChat.cancelsTouchesInView = YES;
    tapChatChat.numberOfTapsRequired = 1;
    [self.chatchatImageView addGestureRecognizer:tapChatChat];
    self.chatchatImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapNerd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToChat)];
    tapNerd.cancelsTouchesInView = YES;
    tapNerd.numberOfTapsRequired = 1;
    [self.goToChatTab addGestureRecognizer:tapNerd];
    self.goToChatTab.userInteractionEnabled = YES;
    
//    //set profile Image
//    NSURL *imageUrl = [NSURL URLWithString:[[FVUser currentUser] profileImageUrl]];
//    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
//    UIImage *image = [UIImage imageWithData:imageData];
//    self.profileImageView.image = image;
//    
//    for (int i=1; i<=6; i++) {
//        UIImageView *imv = (UIImageView *)self.profileImages[i-1];
//        imv.image = [UIImage imageNamed:[NSString stringWithFormat:@"test_profile_%d",i]];
//    }
}

-(void)goToChat
{
    [self performSegueWithIdentifier:@"chat" sender:self];
    
}

//mock up
-(void)viewChatChatProfile
{
    FVUser *user = [[FVUser alloc] init];
    user.name = @"Chatchat Sitthiphan";
    user.status = @"I'm strongest persion in the un.";
    user.profileImageUrl = @"http://news.mthai.com/wp-content/uploads/2014/02/1502401_593529397362530_66696691_o-500x281.jpg";
    user.age = 99;
    user.gender = @"male";
    user.relationship = @"Single";
    
    self.selectedUser = user;

    [self performSegueWithIdentifier:@"viewProfile" sender:self];
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



@end
