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

@interface FVProfileViewController ()

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
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
    
    
    id<FBGraphUser> facebookUser = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] facebookUser];

    
    self.profilePicture.profileID = [facebookUser id];
    self.nameLabel.text = [facebookUser name];
    self.genderLabel.text = [NSString stringWithFormat:@"Gender : %@",[facebookUser objectForKey:@"gender"]];
    
    //age
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDate *birthday = [dateFormat dateFromString:[facebookUser birthday]];

    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    
    self.ageLabel.text = [NSString stringWithFormat:@"Age : %d",age];
    
    //bio
    //self.bioTextView.text = [facebookUser objectForKey:@"bio"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
