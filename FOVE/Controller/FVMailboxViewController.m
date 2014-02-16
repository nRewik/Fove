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
#import "FVMediaPlayerView.h"
#import "FVProfileViewController.h"

@interface FVMailboxViewController () <UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailboxMassageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *foveCountLabel;
@property (strong, nonatomic) IBOutlet FVMediaPlayerView *mediaView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigateBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editMailboxButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end





@implementation FVMailboxViewController


- (IBAction)editMailbox:(id)sender
{
    //todo
    //.. go to editView
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destination = segue.destinationViewController;
    if ([destination isKindOfClass:[FVProfileViewController class]]) {
        if ([segue.identifier isEqualToString:@"viewProfile"]) {
            FVProfileViewController *pvc = (FVProfileViewController *)destination;
            pvc.user = self.mailbox.owner;
        }
    }
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
    
    [self updateUI];
    [self updateMedia];
    
    [self ownerPictuerTapGestureSetup];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)ownerPictuerTapGestureSetup
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewOwnerProfile:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.ownerImageView addGestureRecognizer:tap];
    self.ownerImageView.userInteractionEnabled = YES;
}
-(void)viewOwnerProfile:(UIGestureRecognizer *)gestureRecognizer
{
    [self performSegueWithIdentifier:@"viewProfile" sender:self];
}


-(void)updateUI
{
    if(self.mailbox != nil)
    {
        self.ownerNameLabel.text = self.mailbox.owner.name;
        self.foveCountLabel.text = [NSString stringWithFormat:@"%d",self.mailbox.fovecount];
        
        self.mailboxMassageLabel.text = self.mailbox.message;
        [self.mailboxMassageLabel sizeToFit];
        [self.mailboxMassageLabel layoutIfNeeded];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"d LLLL yyyy";
        self.dateLabel.text = [dateFormat stringFromDate:self.mailbox.lastUpdate];
        
        //profile image
        NSData *profileImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.mailbox.owner.profileImageUrl]];
        UIImage *image = [UIImage imageWithData:profileImageData];
        self.ownerImageView.image = image;
        
        if ([self.mailbox.owner.gender isEqualToString:@"male"]) {
            self.sexImageView.image = [UIImage imageNamed:@"gender_male_sign"];
        }
        else if ([self.mailbox.owner.gender isEqualToString:@"female"])
        {
            self.sexImageView.image = [UIImage imageNamed:@"gender_female_sign"];
        }
        
        //hide edit button if not owner
        if ( ! [[[FVUser currentUser] user_id] isEqualToString:self.mailbox.owner.user_id] )
        {
            UINavigationItem *navItem =  (UINavigationItem *)self.navigateBar.items[0];
            navItem.rightBarButtonItem = nil;
        }
    }
}

-(void)updateMedia
{
    if (self.mailbox.mediaType == FVMediaImageType) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.mailbox.media]];
        UIImage *image = [UIImage imageWithData:imageData];
        [self.mediaView setupWithImage:image];
    }
    else if( self.mailbox.mediaType == FVMediaVideoType){
        NSURL *movieUrl = [NSURL URLWithString:self.mailbox.media];
        [self.mediaView setupWithMovieUrl:movieUrl];
    }
}

@end








