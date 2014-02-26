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

- (IBAction)goBack:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableArray *)postcards
{
    if (!_postcards) {
        _postcards = [[NSMutableArray alloc] init];
        
        MSClient *client = [FVAzureService sharedClient];
        MSTable *postcardTable = [client tableWithName:@"postcard"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sender == %@ and recipient == %@) or (recipient == %@ and sender == %@)",
                                  self.user.user_id,
                                  self.friend.user_id,
                                  self.user.user_id,
                                  self.friend.user_id
                                  ];
        postcardTable.query.orderBy = @[@"__createdAt"];
        [postcardTable readWithPredicate:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
            [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                FVPostCard *newPostcard = [[FVPostCard alloc] initWithPostcardInfo:obj];
                newPostcard.sender = [obj[@"sender"] isEqualToString:self.user.user_id] ? self.user : self.friend;
                [_postcards addObject:newPostcard];
                
                [self.chatCollectionView reloadData];
                
                //if load all of chat scroll to bottom
                if ([_postcards count] == [items count])
                {
                    NSInteger section = [self numberOfSectionsInCollectionView:self.chatCollectionView] - 1;
                    NSInteger item = [self collectionView:self.chatCollectionView numberOfItemsInSection:section]-1;
                    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                    
                    [self.chatCollectionView scrollToItemAtIndexPath:lastIndexPath
                                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                                            animated:NO];
                }
            }];
        }];
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










