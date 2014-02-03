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

- (IBAction)getMailboxFromId
{
    [FVMailbox getMailboxFormID:@"B79871F6-098B-4BFA-894E-4204715DCCD2" completion:^(FVMailbox *resultMailbox, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else
        {
            NSLog(@"%@",resultMailbox.title);
        }
    }];
}

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

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    
    [FVUser currentUser].facebook = nil;
    
    FVViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"indexView"];
    [self presentViewController:fvc animated:YES completion:nil];
    //[[[[UIApplication sharedApplication] delegate] window] setRootViewController:fvc];
    
}


@end
