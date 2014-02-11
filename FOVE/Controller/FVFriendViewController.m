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
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileStatusLabel;
@property (strong,nonatomic) FVUser *selectedUser;

@end

@implementation FVFriendViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMyProfile:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.profileImageView addGestureRecognizer:tap];
    self.profileImageView.userInteractionEnabled = YES;
    
    //set profile Image
    NSURL *imageUrl = [NSURL URLWithString:[[FVUser currentUser] profileImageUrl]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *image = [UIImage imageWithData:imageData];
    self.profileImageView.image = image;
}

-(void)viewMyProfile:(UIGestureRecognizer *)gestureRecognizer
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
