//
//  FVPostCardView.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/14/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FVPostCardView : UIView

@property (strong,nonatomic) UIImage *frontImage;
@property (strong,nonatomic) UIImage *backImage;

-(void)setWithFrontImage:(UIImage *)frontImage backImage:(UIImage *)backImage;

@end
