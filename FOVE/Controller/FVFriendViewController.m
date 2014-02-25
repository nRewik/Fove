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

#import "FVAzureService.h"

@interface FVFriendViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *friendCollectionView;
@property (strong,nonatomic) FVUser *selectedUser;

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
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self.friendCollectionView reloadData];
                   });
                   
        }];
    }
    return _friends;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.friendCollectionView.dataSource = self;
    self.friendCollectionView.delegate = self;
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
    cell.profileNameLabel.text = user.name;
    cell.profileStatusLabel.text = user.status;
    cell.profileImageView.image = user.profileImage;


    return cell;
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor blueColor];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}

#pragma mark -

- (void)goToChat
{
    [self performSegueWithIdentifier:chatSegueID sender:self];
}

-(void)viewProfile:(UIGestureRecognizer *)gestureRecognizer
{
    self.selectedUser = [FVUser currentUser];
    [self performSegueWithIdentifier:@"viewProfile" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destination = segue.destinationViewController;
    if ( [destination isKindOfClass:[FVProfileViewController class]]) {
        if ([segue.identifier isEqualToString:@"viewProfile"]) {
            FVProfileViewController *pfvc = (FVProfileViewController *)destination;
            pfvc.user = self.selectedUser;
        }
    }
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
