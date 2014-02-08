//
//  FVMailboxViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/2/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVMailboxViewController.h"
#import "FVCreateMailboxViewController.h"
#import "FVMapViewController.h"

@interface FVMailboxViewController ()


@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foveCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailboxMassageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigateBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editMailboxButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

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
        UITabBarController *indexTab = (UITabBarController *)self.presentingViewController.presentingViewController;
        FVMapViewController *mapView = (FVMapViewController *)indexTab.selectedViewController;
        [mapView addMailboxToMap:self.mailbox];
    
        [indexTab dismissViewControllerAnimated:YES completion:nil];
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
    if ( ! [[[FVUser currentUser] user_id] isEqualToString:self.mailbox.owner.user_id] )
    {
        UINavigationItem *navItem =  (UINavigationItem *)self.navigateBar.items[0];
        navItem.rightBarButtonItem = nil;
    }
    
    self.ownerNameLabel.text = self.mailbox.owner.name;
    self.foveCountLabel.text = [NSString stringWithFormat:@"❤️ %d",self.mailbox.fovecount];
    self.mailboxMassageLabel.text = self.mailbox.message;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"d LLLL yyyy";
    self.dateLabel.text = [dateFormat stringFromDate:self.mailbox.lastUpdate];
    
    NSData *profileImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.mailbox.owner.profileImageUrl]];
    UIImage *image = [UIImage imageWithData:profileImageData];
    self.ownerImageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
