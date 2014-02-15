//
//  FVPostCard.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/15/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVPostCard.h"

@implementation FVPostCard

-(id)initWithFrontImage:(UIImage *)frontImage backImage:(UIImage *)backImage
{
    self = [super init];
    if (self) {
        _frontImage = frontImage;
        _backImage = backImage;
    }
    return self;
}

@end
