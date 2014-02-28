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

@interface FVMailboxViewController () <UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mailboxInfoView;

@property (strong,nonatomic) UIView *footerView;
@property (nonatomic) BOOL isReadPostcard;

@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *mailboxMassageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *foveCountLabel;
@property (strong, nonatomic) IBOutlet FVMediaPlayerView *mediaView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigateBar;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

//action
@property (weak, nonatomic) IBOutlet UIButton *sendPostCardButton;

//
@property (strong,nonatomic) NSMutableArray *postcards; // of FVPostcard;

@end

@implementation FVMailboxViewController

#define POSTCARD_HEIGHT 187
#define POSTCARD_HEIGHT_GAP 8
#define POSTCARD_WIDTH 300
#define PULL_THRESHOLD 80
#define FOOTER_HEIGHT 60

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
    MSClient *client = [FVAzureService sharedClient];
    NSDictionary *parameter = @{ @"id" : self.mailbox.mailbox_id };
    [client invokeAPI:@"mailbox/fove"
                 body:nil
           HTTPMethod:@"PUT"
           parameters:parameter
              headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                  if (error) {
                      NSLog(@"fove error \n %@",error);
                      return;
                  }
                  self.mailbox.fovecount += 1;
                  [self updateUI];
                  NSLog(@"fove complete");
                  
                  NSDictionary *notifyParameterInfo = @{ @"mailbox_id" : self.mailbox.mailbox_id };
                  NSData *notifyJsonData = [NSJSONSerialization dataWithJSONObject:notifyParameterInfo
                                                                    options:NSJSONWritingPrettyPrinted
                                                                      error:&error];
                  NSString *notifyJsonString = [[NSString alloc] initWithData:notifyJsonData encoding:NSUTF8StringEncoding];
                  
                  MSTable *notificationTable = [client tableWithName:@"notification"];
                  NSDictionary *notifyInfo = @{ @"sender_id" : [[FVUser currentUser] user_id],
                                                @"recipient_id" : self.mailbox.owner.user_id,
                                                @"notification_type" : @"fove",
                                                @"notification_message" : notifyJsonString
                                                };
                  
                  [notificationTable insert:notifyInfo completion:^(NSDictionary *item, NSError *error) {
                      if (error) {
                          NSLog(@"insert fove notification error \n %@",error);
                          return;
                      }
                      NSLog(@"insert fove notification complete");
                  }];
                  
              }
     ];
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

#pragma mark - ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
    [self updateMedia];
    
    [self ownerPictuerTapGestureSetup];
    
    [self.scrollView addSubview:self.footerView];
    self.scrollView.delegate = self;
}
-(void)viewDidLayoutSubviews
{
    CGFloat screenSizeWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat totalHeight = self.mailboxInfoView.bounds.size.height + self.footerView.bounds.size.height - PULL_THRESHOLD;
    self.scrollView.contentSize = CGSizeMake(screenSizeWidth, totalHeight);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Lazy Instantiation
-(UIView *)footerView
{
    if (!_footerView) {
        CGFloat screenSizeWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat footerHeight = FOOTER_HEIGHT + PULL_THRESHOLD;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.scrollView.bounds.size.height-FOOTER_HEIGHT,screenSizeWidth,footerHeight)];
        [_footerView setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *pullLabel = [[UILabel alloc] init];
        pullLabel.text = @"Pull To Read Postcard";
        [pullLabel sizeToFit];
        pullLabel.center = CGPointMake(_footerView.center.x, (_footerView.bounds.size.height-PULL_THRESHOLD)/2 );
        [_footerView addSubview:pullLabel];
    }
    return _footerView;
}

#pragma mark -

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
    self.scrollView.scrollEnabled = NO;
    
    int numberOfPostcard = [self.postcards count];
    for (int i=0; i<numberOfPostcard; i++) {

        CGFloat screenSizeWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat xPos = (screenSizeWidth - POSTCARD_WIDTH)/2;
        
        CGFloat yPos = self.mailboxInfoView.frame.size.height + (POSTCARD_HEIGHT * i) + (POSTCARD_HEIGHT_GAP * (i+1));

        CGRect frame = CGRectMake( xPos , yPos , POSTCARD_WIDTH, POSTCARD_HEIGHT);
        FVPostCardPortraitView *pcv = [[FVPostCardPortraitView alloc] initWithFrame:frame];
        pcv.postCard = self.postcards[i];
        
        [self.scrollView addSubview:pcv];
    }
    
    [self.footerView removeFromSuperview];
    
    CGFloat screenSizeWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat totalHeight = self.mailboxInfoView.bounds.size.height + (POSTCARD_HEIGHT+POSTCARD_HEIGHT_GAP) * numberOfPostcard;
    self.scrollView.contentSize = CGSizeMake(screenSizeWidth,totalHeight);
  
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, self.mailboxInfoView.bounds.size.height);
    } completion:^(BOOL finished) {
        self.scrollView.scrollEnabled = YES;
    }];
}

-(void)updateUI
{
    if(self.mailbox != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ownerNameLabel.text = self.mailbox.owner.name;
            self.ownerStatusLabel.text = self.mailbox.owner.status;
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
//                self.sendPostCardButton.hidden = YES;
            }
            else{
                //if not owner
                UINavigationItem *navItem =  (UINavigationItem *)self.navigateBar.items[0];
                navItem.rightBarButtonItem = nil;
            }
        });
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

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height + PULL_THRESHOLD)
    {
        if (!self.isReadPostcard)
        {
            self.isReadPostcard = YES;
            [self reloadPostcard];
            
        }
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && scrollView.contentOffset.y >= scrollView.frame.size.height)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height + PULL_THRESHOLD)
    {
        if (!self.isReadPostcard)
        {
            self.isReadPostcard = YES;
            [self reloadPostcard];
            
        }
    }
}

@end








