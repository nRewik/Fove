//
//  FVCreatePostCardViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/16/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVCreatePostCardViewController.h"
#import "FVCreatePostCardView.h"
#import "FVPostCardViewController.h"

#import "FVBlobStorageService.h"
#import "FVAppDelegate.h"
#import "FVUser.h"


@interface FVCreatePostCardViewController () <FVCreatePostCardViewDelegate>

@property (weak, nonatomic) IBOutlet FVCreatePostCardView *createPostCardView;
@property (strong,nonatomic) FVPostCard *createdPostcard;

@end

@implementation FVCreatePostCardViewController
{
    BOOL _isFinishUploadFrontImage;
    BOOL _isFinishUploadBackImage;
    NSError *_uploadImageError;
}
#define FVCREATEPOSTCARD_UPLOAD_NOTIFICATION @"FVCREATEPOSTCARD_UPLOAD_NOTIFICATION"

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewPostcard"]) {
        UIViewController *vc = segue.destinationViewController;
        if ([vc isKindOfClass:[FVPostCardViewController class]]) {
            FVPostCardViewController *pcvc = (FVPostCardViewController *)vc;
            pcvc.postcard = self.createdPostcard;
        }
    }
}
#pragma mark - view controller stuff
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.createPostCardView.delegate = self;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - FVCreatePostCardDelegate
-(void)didCancelCreatePostCard
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)didFinishCreatePostCard:(FVPostCard *)postCard
{
    self.createdPostcard = postCard;
    
    //init notify
    _isFinishUploadFrontImage = NO;
    _isFinishUploadBackImage = NO;
    _uploadImageError = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUploadImageProgress) name:FVCREATEPOSTCARD_UPLOAD_NOTIFICATION object:nil];
    //
    
    
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"postcard"];
    
    
    NSDictionary *postcardInfo = @{ @"sender" : [[FVUser currentUser] user_id]};
    [table insert:postcardInfo completion:^(NSDictionary *item, NSError *error) {
        NSString *itemID = item[@"id"];
        
        FVBlobStorageService *blobService = [FVBlobStorageService getInstance];

        NSString *frontImageName = [NSString stringWithFormat:@"%@_front.png",itemID];
        NSString *backImageName = [NSString stringWithFormat:@"%@_back.png",itemID];
        
        NSData *frontImageData = UIImagePNGRepresentation(self.createdPostcard.frontImage);
        NSData *backImageData = UIImagePNGRepresentation(self.createdPostcard.backImage);

        
        [blobService getSasUrlForNewBlob:frontImageName forContainer:[FVBlobStorageService postcardContainer] withCompletion:^(NSString *sasUrl, NSError *error)
        {
            if (error) {
                _uploadImageError = error;
                [[NSNotificationCenter defaultCenter] postNotificationName:FVCREATEPOSTCARD_UPLOAD_NOTIFICATION object:nil];
                return;
            }
            [blobService postImageToBlobWithUrl:sasUrl NSData:frontImageData withCompletion:^(BOOL isSuccess)
            {
                if ( isSuccess )
                {
                    NSString *frontImageURL = [NSString stringWithFormat:@"%@/%@/%@",
                                               [FVBlobStorageService blobUrl],
                                               [FVBlobStorageService postcardContainer],
                                               frontImageName];
                    NSDictionary *postcardFrontImageInfo = @{ @"id":itemID , @"front_image": frontImageURL};
                    
                    dispatch_async( dispatch_get_main_queue(), ^{
                        [table update:postcardFrontImageInfo completion:^(NSDictionary *item, NSError *error)
                        {
                            NSLog(@"font");
                            _isFinishUploadFrontImage = YES;
                            [[NSNotificationCenter defaultCenter] postNotificationName:FVCREATEPOSTCARD_UPLOAD_NOTIFICATION object:nil];
                        }];
                    });
                    
                }
            }];
        }];
        
        [blobService getSasUrlForNewBlob:backImageName forContainer:[FVBlobStorageService postcardContainer] withCompletion:^(NSString *sasUrl, NSError *error)
         {
             if (error) {
                 _uploadImageError = error;
                 [[NSNotificationCenter defaultCenter] postNotificationName:FVCREATEPOSTCARD_UPLOAD_NOTIFICATION object:nil];
                 return;
             }
             [blobService postImageToBlobWithUrl:sasUrl NSData:backImageData withCompletion:^(BOOL isSuccess)
              {
                  if ( isSuccess )
                  {
                      NSString *backImageURL = [NSString stringWithFormat:@"%@/%@/%@",
                                                [FVBlobStorageService blobUrl],
                                                [FVBlobStorageService postcardContainer],
                                                backImageName];
                      dispatch_async( dispatch_get_main_queue() , ^{
                          NSDictionary *postcardBackImageInfo = @{ @"id":itemID , @"back_image": backImageURL};
                          [table update:postcardBackImageInfo completion:^(NSDictionary *item, NSError *error)
                          {
                              NSLog(@"back");
                              _isFinishUploadBackImage = YES;
                              [[NSNotificationCenter defaultCenter] postNotificationName:FVCREATEPOSTCARD_UPLOAD_NOTIFICATION object:nil];
                          }];
                      });
                  }
              }];
         }];
    }];
}

-(void)getUploadImageProgress
{
    if (_uploadImageError) {
        NSLog(@"%@",_uploadImageError);
    }
    else if( _isFinishUploadFrontImage && _isFinishUploadBackImage )
    {
        NSLog(@"create postcard complete");
    }
}

#pragma mark - dealloc
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
