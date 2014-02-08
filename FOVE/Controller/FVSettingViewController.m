//
//  FVSettingViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 1/28/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVSettingViewController.h"
#import "FVViewController.h"
#import "FVUser.h"
#import "FVMailbox.h"

@interface FVSettingViewController ()

@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;

@end

@implementation FVSettingViewController

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
    self.fbLoginView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{    
    [FVUser setCurrentUser:nil];
    [self performSegueWithIdentifier:@"logout" sender:self];
}


@end
