//
//  FVFriendCollectionViewCell.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/21/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FVFriendCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileStatusLabel;
@end
