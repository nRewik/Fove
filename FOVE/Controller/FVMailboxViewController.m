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
#import "FVCreatePostCardViewController.h"
#import "FVAzureService.h"
#import "FVPostCard.h"
#import "FVPostCardPortraitView.h"

@interface FVMailboxViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mailboxInfoView;

@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailboxMassageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *foveCountLabel;
@property (strong, nonatomic) IBOutlet FVMediaPlayerView *mediaView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigateBar;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

//action
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editMailboxButton;
@property (weak, nonatomic) IBOutlet UIButton *sendPostCardButton;

//
@property (strong,nonatomic) NSMutableArray *postcards; // of FVPostcard;

@end

@implementation FVMailboxViewController

#define POSTCARD_HEIGHT 187
#define POSTCARD_HEIGHT_GAP 8
#define POSTCARD_WIDTH 300

-(NSMutableArray *)postcards
{
    if (!_postcards) {
        _postcards = [[NSMutableArray alloc] init];
        
        NSString *imageName = @"test_postcard_back_1";
        UIImage *image = [UIImage imageNamed:imageName];
        
        int numberOfPostcard = 10;
        for (int i=0; i<numberOfPostcard; i++) {
            FVPostCard *postcard = [[FVPostCard alloc] initWithFrontImage:image backImage:image];
            [_postcards addObject:postcard];
        }
    }
    return _postcards;
}

- (IBAction)editMailbox:(id)sender
{
    //todo
    //.. go to editView
}
- (IBAction)foveMailbox
{
    self.mailbox.fovecount += 1;
    [self updateUI];
//    MSClient *client = [FVAzureService sharedClient];
//    MSTable *mailboxTable = [client tableWithName:@"mailbox"];
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
    if ([destination isKindOfClass:[FVCreatePostCardViewController class]]) {
        FVCreatePostCardViewController *cpcv = (FVCreatePostCardViewController *)destination;
        cpcv.mailbox = self.mailbox;
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
    
    [self reloadPostcard];
}
-(void)viewDidLayoutSubviews
{
    int numberOfPostcard = [self.postcards count];
    CGFloat screenSizeWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat totalHeight = self.mailboxInfoView.bounds.size.height + (POSTCARD_HEIGHT+POSTCARD_HEIGHT_GAP) * numberOfPostcard;
    self.scrollView.contentSize = CGSizeMake(screenSizeWidth,totalHeight);
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
-(void)reloadPostcard
{
    int numberOfPostcard = [self.postcards count];
    for (int i=0; i<numberOfPostcard; i++) {

        CGFloat screenSizeWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat xPos = (screenSizeWidth - POSTCARD_WIDTH)/2;
        
        CGFloat eachPCVHeight = POSTCARD_HEIGHT+POSTCARD_HEIGHT_GAP;
        CGFloat yPos = self.mailboxInfoView.frame.size.height + eachPCVHeight*i;

        CGRect frame = CGRectMake( xPos , yPos , POSTCARD_WIDTH, POSTCARD_HEIGHT);
        FVPostCardPortraitView *pcv = [[FVPostCardPortraitView alloc] initWithFrame:frame];
        pcv.postCard = self.postcards[i];
        
        [self.scrollView addSubview:pcv];
    }
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

        self.ownerImageView.image = self.mailbox.owner.profileImage;
        
        if ([self.mailbox.owner.gender isEqualToString:@"male"]) {
            self.sexImageView.image = [UIImage imageNamed:@"gender_male_sign"];
        }
        else if ([self.mailbox.owner.gender isEqualToString:@"female"])
        {
            self.sexImageView.image = [UIImage imageNamed:@"gender_female_sign"];
        }
        
        if ( [[[FVUser currentUser] user_id] isEqualToString:self.mailbox.owner.user_id]){
            //if owner
            self.sendPostCardButton.hidden = YES;
        }
        else{
            //if not owner
            UINavigationItem *navItem =  (UINavigationItem *)self.navigateBar.items[0];
            navItem.rightBarButtonItem = nil;
        }
    }
}

-(void)updateMedia
{
    if (self.mailbox.mediaType == FVMediaImageType) {
        UIImage *image = [UIImage imageWithData:self.mailbox.mediaData];
        [self.mediaView setupWithImage:image];
    }
    else if( self.mailbox.mediaType == FVMediaVideoType){
        NSURL *movieUrl = [NSURL URLWithString:self.mailbox.mediaURL];
        [self.mediaView setupWithMovieUrl:movieUrl];
    }
}

@end








