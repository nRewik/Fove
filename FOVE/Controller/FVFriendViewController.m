//
//  FVFriendViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVFriendViewController.h"
#import "FVUser.h"
#import "FVProfileViewController.h"
#import "FVFriendCollectionViewCell.h"
#import "FVChatViewController.h"
#import "FVAzureService.h"

@interface FVFriendViewController () <UICollectionViewDataSource,FVFriendCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *friendCollectionView;

@property (strong,nonatomic) FVUser *selectedUser;
@property (strong,nonatomic) FVUser *selectedChatUser;

@property (strong,nonatomic) NSMutableArray *friends; //of FVUser;

@end

#define chatSegueID @"chat"

@implementation FVFriendViewController


-(NSMutableArray *)friends
{
    if (!_friends) {
        _friends = [[NSMutableArray alloc] init];
        
        MSClient *client = [FVAzureService sharedClient];
        
        NSDictionary *parameter = @{ @"user_id" : [[FVUser currentUser] user_id] };
        [client invokeAPI:@"friend"
                     body:nil
               HTTPMethod:@"GET"
               parameters:parameter
                  headers:nil
               completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                   
                   if (error){
                       NSLog(@"%@",error);
                       return;
                   }
                   for (NSUInteger i=0; i<[result count]; i++) {
                       FVUser *friend = [[FVUser alloc] initWithUserDictionary:result[i]];
                       [_friends addObject:friend];
                   }
                   
                   [self.friendCollectionView reloadData];
        }];
    }
    return _friends;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.friendCollectionView.dataSource = self;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.friends count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *friendViewCellidentifier = @"friendViewCell";
    
    FVUser *user = self.friends[indexPath.row];
    
    FVFriendCollectionViewCell * cell = [self.friendCollectionView dequeueReusableCellWithReuseIdentifier:friendViewCellidentifier forIndexPath:indexPath];
    cell.user = user;
    cell.delegate = self;

    return cell;
}

#pragma mark - FVFriendCollectionViewCellDelegate
-(void)didSelectChatWithUser:(FVUser *)user
{
    self.selectedChatUser = user;
    [self performSegueWithIdentifier:@"chat" sender:self];
}
#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destination = segue.destinationViewController;
    
    if ([destination isKindOfClass:[FVChatViewController class]]) {
        if ([segue.identifier isEqualToString:@"chat"]) {
            FVChatViewController *chatVC = (FVChatViewController *)destination;
            chatVC.user = [FVUser currentUser];
            chatVC.friend = self.selectedChatUser;
        }
    }
    if ( [destination isKindOfClass:[FVProfileViewController class]]) {
        if ([segue.identifier isEqualToString:@"viewProfile"]) {
            FVProfileViewController *pfvc = (FVProfileViewController *)destination;
            pfvc.user = self.selectedUser;
        }
    }
}
-(void)viewProfile:(UIGestureRecognizer *)gestureRecognizer
{
    self.selectedUser = [FVUser currentUser];
    [self performSegueWithIdentifier:@"viewProfile" sender:self];
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
