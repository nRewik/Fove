//
//  FVPostCardView.h
//  
//
//  Created by Nutchaphon Rewik on 2/15/14.
//
//

#import <UIKit/UIKit.h>
#import "FVPostCard.h"

@interface FVPostCardView : UIView

@property (strong,nonatomic) FVPostCard *postCard;
@property (strong,nonatomic,readonly) UIImageView *frontView;
@property (strong,nonatomic,readonly) UIImageView *backView;

-(UIView *)currentView;

@end
