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

#define PLAY_BUTTON_SIZE 60

@implementation FVMediaPlayerView
{
    UIImageView *_thumbnailMovieImageView;
    UIButton *_playButton;
    BOOL _hasMovie;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)addMoviePlayerControl
{
    CGRect buttonFrame = CGRectMake(0, 0, PLAY_BUTTON_SIZE,PLAY_BUTTON_SIZE);
    _playButton = [[UIButton alloc] initWithFrame:buttonFrame];
    _playButton.center = self.moviePlayerController.view.center;
    
    UIImage *buttonImage = [UIImage imageNamed:@"play_media_button"];
    [_playButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_playButton setContentMode:UIViewContentModeScaleAspectFill];
    _playButton.clipsToBounds = YES;
    
    [_playButton addTarget:self action:@selector(playMovie) forControlEvents:UIControlEventTouchUpInside];
    
    [self.moviePlayerController.view addSubview:_playButton];
}

-(void)playMovie
{
    _playButton.hidden = YES;
    if (_thumbnailMovieImageView != nil) {
        _thumbnailMovieImageView.hidden = YES;
    }
    [self.moviePlayerController play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishPlayMovie)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)finishPlayMovie
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    if (_thumbnailMovieImageView != nil) {
        _thumbnailMovieImageView.hidden = NO;
    }
    _playButton.hidden = NO;
}

-(void)handleThumbnailImageRequestFinishNotification:(NSNotification*)note
{
    NSDictionary *userinfo = [note userInfo];
    NSError* error = [userinfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    if (error){
        NSLog(@"Error: %@",error);
    }
    else
    {
        UIImage *thumbnailImage = [userinfo valueForKey:MPMoviePlayerThumbnailImageKey];
        _thumbnailMovieImageView = [[UIImageView alloc] initWithFrame:self.moviePlayerController.view.bounds];
        _thumbnailMovieImageView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbnailMovieImageView.clipsToBounds = YES;
        
        _thumbnailMovieImageView.image = thumbnailImage;
        [self.moviePlayerController.view insertSubview:_thumbnailMovieImageView belowSubview:_playButton];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                                  object:nil];
}


-(void)setupWithMovieUrl:(NSURL *)movieUrl
{
    [self clearMediaView];
    
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    self.moviePlayerController.shouldAutoplay = NO;
    self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
    
    self.moviePlayerController.view.frame = self.bounds;
    self.moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview: self.moviePlayerController.view];
    
    //thumbnail
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleThumbnailImageRequestFinishNotification:)
                                                 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                               object:nil];
    [self.moviePlayerController requestThumbnailImagesAtTimes:@[@(1.f)] timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    [self addMoviePlayerControl];
    _hasMovie = YES;
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
    
    _hasMovie = NO;
}

-(void)clearMediaView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.imageView removeFromSuperview];
    [self.moviePlayerController.view removeFromSuperview];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
