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
#import "FVUser.h"
#import "FVAzureService.h"


@interface FVCreatePostCardViewController () <FVCreatePostCardViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet FVCreatePostCardView *createPostCardView;
@property (strong,nonatomic) FVPostCard *createdPostcard;

@property (strong,nonatomic) UIAlertView *waitingSendPostcardAlertView;
@property (strong,nonatomic) UIAlertView *finishSendPostcardAlertView;

@end

@implementation FVCreatePostCardViewController
{
    BOOL _isFinishUploadFrontImage;
    BOOL _isFinishUploadBackImage;
    NSError *_uploadImageError;
}
#define FVCREATEPOSTCARD_UPLOAD_NOTIFICATION @"FVCREATEPOSTCARD_UPLOAD_NOTIFICATION"

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

#pragma mark - Lazy Instantiation
-(UIAlertView *)waitingSendPostcardAlertView
{
    if (!_waitingSendPostcardAlertView) {
        _waitingSendPostcardAlertView = [[UIAlertView alloc] initWithTitle:@"Sending The Postcard..." message:@""
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:nil];
    }
    return _waitingSendPostcardAlertView;
}
-(UIAlertView *)finishSendPostcardAlertView
{
    if (!_finishSendPostcardAlertView) {
        _finishSendPostcardAlertView = [[UIAlertView alloc] initWithTitle:@"Send Postcard"
                                                                  message:@"Your postcard is sent."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        
    }
    return _finishSendPostcardAlertView;
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
    
    [self.waitingSendPostcardAlertView show];
    
    MSClient *client = [FVAzureService sharedClient];
    MSTable *table = [client tableWithName:@"postcard"];
    
    
    NSDictionary *postcardInfo = @{ @"sender" : [[FVUser currentUser] user_id],
                                    @"mailbox_id" : self.mailbox.mailbox_id,
                                    @"recipient" : self.mailbox.owner.user_id
                                    };
    [table insert:postcardInfo completion:^(NSDictionary *item, NSError *error) {
        NSString *itemID = item[@"id"];
        
        FVBlobStorageService *blobService = [FVBlobStorageService getInstance];

        NSString *frontImageName = [NSString stringWithFormat:@"%@_front.jpeg",itemID];
        NSString *backImageName = [NSString stringWithFormat:@"%@_back.jpeg",itemID];
        
        NSData *frontImageData = UIImageJPEGRepresentation(self.createdPostcard.frontImage, 0.8);
        NSData *backImageData = UIImageJPEGRepresentation(self.createdPostcard.backImage, 0.8);

        
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
                            NSLog(@"front");
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
        
        [self.waitingSendPostcardAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if( _isFinishUploadFrontImage && _isFinishUploadBackImage )
    {
        NSLog(@"create postcard complete");
        
        //insert friend
        MSClient *client = [FVAzureService sharedClient];
        MSTable *table = [client tableWithName:@"friend"];
        
        NSDictionary *friendInfo = @{ @"user_id" : [[FVUser currentUser] user_id] , @"friend_id" : self.mailbox.owner.user_id };
        [table insert:friendInfo completion:^(NSDictionary *item, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                [self.waitingSendPostcardAlertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            NSLog(@"insert friend complete --- %@ ",item[@"message"]);
        }];
        
        
        MSTable *notificationTable = [client tableWithName:@"notification"];
        NSDictionary *notifyInfo = @{ @"sender_id": [[FVUser currentUser] user_id] ,
                                      @"recipient_id" : self.mailbox.owner.user_id,
                                      @"notification_type" : @"send_postcard",
                                      @"notification_message" : @"sent postcard to"
                                      };
        [notificationTable insert:notifyInfo completion:^(NSDictionary *item, NSError *error) {
            if (error) {
                NSLog(@"FVCreatePostCardViewController insert notification table error \n\n %@",error);
                [self.waitingSendPostcardAlertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            NSLog(@"insert send postcard notification complete");
            
            [self.waitingSendPostcardAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [self.finishSendPostcardAlertView show];
        }];
        /////
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.finishSendPostcardAlertView) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - dealloc
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
