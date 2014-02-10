//
//  FVMediaPlayerView.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/10/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVMediaPlayerView.h"
#import "FVMailbox.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FVMediaPlayerView()

@property (strong,nonatomic) MPMoviePlayerController *moviePlayerController;
@property (strong,nonatomic) UIImageView *imageView;

@end

@implementation FVMediaPlayerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setupWithMovieUrl:(NSURL *)movieUrl
{
    [self clearMediaView];
    
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    self.moviePlayerController.view.frame = self.bounds;
    
    self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
    
    self.moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview: self.moviePlayerController.view];
    
    [self.moviePlayerController play];
}

-(void)setupWithImage:(UIImage *)image
{
    [self clearMediaView];

    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = self.bounds;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    [self addSubview:self.imageView];
    
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)clearMediaView
{
    [self.imageView removeFromSuperview];
    [self.moviePlayerController.view removeFromSuperview];
    
    self.imageView = nil;
    self.moviePlayerController = nil;
}

@end
