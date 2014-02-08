//
//  FVProfileViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 1/28/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FVAppDelegate.h"
#import "FVUser.h"

@interface FVProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@end

@implementation FVProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    FVUser *user = [FVUser currentUser];
    self.nameLabel.text = user.name;
    self.genderLabel.text = [NSString stringWithFormat:@"Gender : %@",user.gender];
    self.ageLabel.text = [NSString stringWithFormat:@"Age : %d",user.age];
    
    NSData *profileImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.profileImageUrl]];
    UIImage *image = [UIImage imageWithData:profileImageData];
    self.profileImageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
