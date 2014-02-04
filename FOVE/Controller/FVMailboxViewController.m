//
//  FVMailboxViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/2/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVMailboxViewController.h"
#import "FVCreateMailboxViewController.h"

@interface FVMailboxViewController ()


@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foveCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailboxMassageLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigateBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editMailboxButton;

@end





@implementation FVMailboxViewController


- (IBAction)editMailbox:(id)sender
{
    //todo
    //.. go to editView
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)back:(id)sender
{
    if( [self.presentingViewController isKindOfClass:[FVCreateMailboxViewController class]])
    {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%@ \n%@",[FVUser currentUser].user_id,self.mailbox.owner.user_id);
    if ( ! [[[FVUser currentUser] user_id] isEqualToString:self.mailbox.owner.user_id] )
    {
        UINavigationItem *navItem =  (UINavigationItem *)self.navigateBar.items[0];
        navItem.rightBarButtonItem = nil;
    }
    
    self.ownerNameLabel.text = self.mailbox.owner.name;
    self.foveCountLabel.text = [NSString stringWithFormat:@"❤️ %d",self.mailbox.fovecount];
    self.mailboxMassageLabel.text = self.mailbox.message;
    
    self.profilePictureView.profileID = [self.mailbox.owner.facebook id];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
