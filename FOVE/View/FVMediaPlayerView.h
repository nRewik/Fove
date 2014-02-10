//
//  FVMediaPlayerView.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/10/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FVMediaPlayerView : UIView

-(void)setupWithMovieUrl:(NSURL *)movieUrl;
-(void)setupWithImage:(UIImage *)image;


@end
