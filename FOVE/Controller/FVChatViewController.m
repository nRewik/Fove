//
//  FVChatViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVChatViewController.h"
#import "FVPostCard.h"
#import "FVChatPostCardCollectionViewCell.h"
#import "FVAzureService.h"
#import "FVPostCardViewController.h"

@interface FVChatViewController () <UICollectionViewDataSource,FVChatPostcardCollectionViewCellDelegate>

+(dispatch_queue_t)readPostcardQueue;

@property (weak, nonatomic) IBOutlet UINavigationItem *chatNavigationItem;
@property (weak, nonatomic) IBOutlet UICollectionView *chatCollectionView;

@property (strong,nonatomic) NSMutableArray *postcards; //of FVPostcard
@property (strong,nonatomic) FVPostCard *selectedPostcard;

@end

@implementation FVChatViewController

static dispatch_queue_t _readPostcardQueue;
+(dispatch_queue_t)readPostcardQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _readPostcardQueue = dispatch_queue_create("readPostcardQueue", NULL);
    });
    return _readPostcardQueue;
}

#pragma mark - ViewControllerState
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.chatNavigationItem.title = self.friend.name;
    self.chatCollectionView.dataSource = self;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destination = segue.destinationViewController;
    if([destination isKindOfClass:[FVPostCardViewController class]])
    {
        if ([segue.identifier isEqualToString:@"viewPostcard"]) {
            FVPostCardViewController *postcardVC = (FVPostCardViewController *)destination;
            postcardVC.postcard = self.selectedPostcard;
        }
    }
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)goBack:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableArray *)postcards
{
    if (!_postcards) {
        _postcards = [[NSMutableArray alloc] init];
        
        MSClient *client = [FVAzureService sharedClient];
        
        NSDictionary *parameter = @{ @"user_id" : self.user.user_id , @"friend_id" : self.friend.user_id };
        [client invokeAPI:@"chat"
                     body:nil
               HTTPMethod:@"GET"
               parameters:parameter
                  headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                      
                      if ([result count] == 0) {
                          return;
                      }
                      
                      for (int i=[result count]-1; i>=0; i--){
                          id obj = result[i];
                          FVPostCard *newPostcard = [[FVPostCard alloc] initWithPostcardInfo:obj];
                          newPostcard.sender = [obj[@"sender"] isEqualToString:self.user.user_id] ? self.user : self.friend;
                          [_postcards addObject:newPostcard];
                          
                          [self.chatCollectionView reloadData];
                      }
                      
                      NSInteger section = [self numberOfSectionsInCollectionView:self.chatCollectionView] - 1;
                      NSInteger item = [self collectionView:self.chatCollectionView numberOfItemsInSection:section]-1;
                      NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                      
                      [self.chatCollectionView scrollToItemAtIndexPath:lastIndexPath
                                                      atScrollPosition:UICollectionViewScrollPositionBottom
                                                              animated:NO];

                  }
         ];
    }
    return _postcards;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.postcards count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * chatPostcardViewCellIdentifier = @"chatPostcardViewCell";
    FVChatPostCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:chatPostcardViewCellIdentifier
                                                                                       forIndexPath:indexPath];
    cell.postcard = self.postcards[indexPath.item];
    cell.delegate = self;
    
    return cell;
}
#pragma mark - FVChatPostcardCollectionViewCellDelegate
-(void)didSelectPostcard:(FVPostCard *)postcard
{
    self.selectedPostcard = postcard;
    [self performSegueWithIdentifier:@"viewPostcard" sender:self];
}

@end










