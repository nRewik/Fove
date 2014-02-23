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

@interface FVGalleryViewController ()

@property (strong,nonatomic) NSMutableArray *postcards; // of FVPostcard

@end

@implementation FVGalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(NSMutableArray *)postcards
{
    if (!_postcards) {
        _postcards = [[NSMutableArray alloc] init];
        
        int numberOFpostCards = 20;
        
        for (int i=0; i<numberOFpostCards; i++) {
            NSString *imageName = [NSString stringWithFormat:@"test_postcard_front_%d",i%4];
            UIImage *frontImage = [UIImage imageNamed:imageName];
            FVPostCard *postcard = [[FVPostCard alloc] initWithFrontImage:frontImage backImage:nil];
            
            [self.postcards addObject:postcard];
        }
        
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
















