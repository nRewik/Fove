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

@interface FVChatViewController () <UICollectionViewDataSource>

+(dispatch_queue_t)readPostcardQueue;

@property (weak, nonatomic) IBOutlet UINavigationItem *chatNavigationItem;
@property (weak, nonatomic) IBOutlet UICollectionView *chatCollectionView;

@property (strong,nonatomic) NSMutableArray *postcards; //of FVPostcard

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
            }];
        }];
    }
    return _postcards;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.chatNavigationItem.title = self.friend.name;
    self.chatCollectionView.dataSource = self;
}
-(void)viewDidLayoutSubviews
{
//    NSIndexPath *path = [NSIndexPath indexPathForItem:[self.postcards count]-1 inSection:0];
//    [self.chatCollectionView scrollToItemAtIndexPath:path
//                                    atScrollPosition:UICollectionViewScrollPositionBottom
//                                            animated:NO];
}
- (IBAction)goBack:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
    
    return cell;
}

@end










