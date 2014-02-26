//
//  FVFriendCollectionViewCell.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/21/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVFriendCollectionViewCell.h"

@interface FVFriendCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileStatusLabel;

@end

@implementation FVFriendCollectionViewCell

- (IBAction)goToChat
{
    [self.delegate didSelectChatWithUser:self.user];
}

-(void)setUser:(FVUser *)user
{
    _user = user;
    self.profileImageView.image = self.user.profileImage;
    self.profileNameLabel.text = self.user.name;
    self.profileStatusLabel.text = self.user.status;
}

@end
