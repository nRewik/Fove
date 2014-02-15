//
//  FVPostCard.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/15/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FVPostCard : NSObject

@property (strong,nonatomic) UIImage *frontImage;
@property (strong,nonatomic) UIImage *backImage;

-(id)initWithFrontImage:(UIImage *)frontImage backImage:(UIImage *)backImage;
@end
