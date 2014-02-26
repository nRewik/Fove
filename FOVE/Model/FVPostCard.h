//
//  FVPostCard.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/15/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FVUser.h"

@interface FVPostCard : NSObject

@property (strong,nonatomic) FVUser *sender;
@property (strong,nonatomic) FVUser *recipient;
@property (strong,nonatomic) NSString *frontImageURL;
@property (strong,nonatomic) NSString *backImageURL;
@property (strong,nonatomic) NSDate *timestamp;

@property (strong,nonatomic) UIImage *frontImage;
@property (strong,nonatomic) UIImage *backImage;
@property (nonatomic) BOOL isFlip;

-(void)getFrontImageAndBackImageWithCompletionBlock:(void(^)(UIImage *frontImage,UIImage *backImage))completion;

-(id)initWithFrontImage:(UIImage *)frontImage backImage:(UIImage *)backImage;
-(id)initWithPostcardInfo:(NSDictionary *)info;

@end
