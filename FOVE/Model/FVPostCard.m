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
        
        _isFlip = NO;
    }
    return self;
}

-(id)initWithPostcardInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _isFlip = NO;
        _frontImageURL = info[@"front_image"];
        _backImageURL = info[@"back_image"];
        _timestamp = info[@"__createdAt"];
    }
    return self;
}

-(UIImage *)frontImage
{
    if (!_frontImage) {
        NSURL *frontImageURL = [NSURL URLWithString:self.frontImageURL];
        NSData *frontImageData = [NSData dataWithContentsOfURL:frontImageURL];
        _frontImage = [UIImage imageWithData:frontImageData];
    }
    return _frontImage;
}
-(UIImage *)backImage
{
    if (!_backImage) {
        NSURL *backImageURL = [NSURL URLWithString:self.backImageURL];
        NSData *backImageData = [NSData dataWithContentsOfURL:backImageURL];
        _backImage = [UIImage imageWithData:backImageData];
    }
    return _backImage;
}

-(void)getFrontImageAndBackImageWithCompletionBlock:(void (^)(UIImage *, UIImage *))completion
{
    dispatch_async( dispatch_queue_create("downloadQueue", NULL), ^{
        UIImage *frontImage = self.frontImage;
        UIImage *backImage = self.backImage;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(frontImage,backImage);
        });
    });
}
@end







