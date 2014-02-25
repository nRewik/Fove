//
//  FVGalleryViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/23/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVGalleryViewController.h"
#import "FVPostCard.h"
#import "FVGalleryViewCell.h"

#import "FVUser.h"
#import "FVAzureService.h"

@interface FVGalleryViewController ()

@property (strong,nonatomic) NSMutableArray *postcards; // of FVPostcard

@end

@implementation FVGalleryViewController
{
    dispatch_queue_t downloadImageQueue;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    downloadImageQueue = dispatch_queue_create("downloadImageQueue", NULL);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(NSMutableArray *)postcards
{
    if (!_postcards) {
        _postcards = [[NSMutableArray alloc] init];
        
        
        MSClient *client = [FVAzureService sharedClient];
        MSTable *table = [client tableWithName:@"postcard"];
        
        NSString *user_id = [[FVUser currentUser] user_id];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sender = %@ or recipient = %@",user_id,user_id];
        [table readWithPredicate:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
            if (error) {
                NSLog(@"error - FVGalleryViewController postcard table read \n %@",error);
                return;
            }
            [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                dispatch_async( downloadImageQueue, ^{
                    UIImage *frontImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj[@"front_image"]]]];
                    UIImage *backImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj[@"back_image"]]]];
                    
                    FVPostCard *newPostcard = [[FVPostCard alloc] initWithFrontImage:frontImage backImage:backImage];
                    [self.postcards addObject:newPostcard];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                });
            }];
        }];
    }
    return _postcards;
}

#pragma mark - UIViewCollectionDataSource
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
    static NSString *identifier = @"galleryViewCell";
    
    FVGalleryViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.postcard = self.postcards[indexPath.row];
    return cell;
}




@end
















