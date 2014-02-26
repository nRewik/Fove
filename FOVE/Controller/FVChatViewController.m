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

@interface FVChatViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationItem *chatNavigationItem;
@property (weak, nonatomic) IBOutlet UICollectionView *chatCollectionView;

@property (strong,nonatomic) NSMutableArray *postcards; //of FVPostcard

@end

@implementation FVChatViewController

-(NSMutableArray *)postcards
{
    if (!_postcards) {
        _postcards = [[NSMutableArray alloc] init];
        
        int numberOfPostcards = 10;
        for (int i=0; i<numberOfPostcards; i++) {
            
            UIImage *frontImage = [UIImage imageNamed:@"test_postcard_front_1"];
            UIImage *backImage = [UIImage imageNamed:@"test_postcard_back_1"];
            
            FVPostCard *newPostcard = [[FVPostCard alloc] initWithFrontImage:frontImage backImage:backImage];
            newPostcard.timestamp = [NSDate dateWithTimeIntervalSinceNow:(-25 * i)];
            
            
            newPostcard.sender = [FVUser currentUser];
            
            [_postcards addObject:newPostcard];
        }
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
    NSIndexPath *path = [NSIndexPath indexPathForItem:[self.postcards count]-1 inSection:0];
    [self.chatCollectionView scrollToItemAtIndexPath:path
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:NO];
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










