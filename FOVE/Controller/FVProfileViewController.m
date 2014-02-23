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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *relationshipLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestedGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *hobbyLabel;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *photos;


@end

@implementation FVProfileViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad
{
    NSAssert( self.user != nil , @"self.user should not be nil !!");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self updateUI];
}
- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateUI
{
    if( self.user != nil)
    {
        self.nameLabel.text = self.user.name;
        self.statusLabel.text = self.user.status;
        
//        self.aboutMeLabel.text = self.user.aboutMe;
        [self.aboutMeLabel sizeToFit];
        
        self.genderLabel.text = self.user.gender;
        self.ageLabel.text = [NSString stringWithFormat:@"%d",self.user.age];
        self.relationshipLabel.text = self.user.relationship;
//        self.interestedGenderLabel.text = self.user.interestedGender;
//        self.hobbyLabel.text = self.user.hobby;
        
        self.profileImageView.image = self.user.profileImage;
        
        for (UIImageView *imv in self.photos) {
            imv.image = self.user.profileImage;
        }
        
    }
}

@end
