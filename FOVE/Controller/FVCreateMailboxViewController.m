//
//  FVCreateMailboxViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/1/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVCreateMailboxViewController.h"
#import "FVMailboxViewController.h"
#import "FVMediaPlayerView.h"

#import "FVMailbox.h"
#import "FVUser.h"
#import "FVAppDelegate.h"

#import "FVBlobStorageService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface FVCreateMailboxViewController () <UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) MPMoviePlayerController *moviewPlayerController;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UIImagePickerController *imagePicker;

@property (nonatomic) BOOL isSelectedMedia;
@property (strong,nonatomic) NSData *selectedMediaData;
@property (strong,nonatomic) NSString *selectedMediaExtension;
@property (nonatomic) FVMediaType selectedMediaType;

@property (strong,nonatomic) FVMailbox *createdMailbox;

@property (strong, nonatomic) IBOutlet FVMediaPlayerView *mediaView;
@property (strong, nonatomic) IBOutlet UITextView *messageTextArea;
@property (weak, nonatomic) IBOutlet UIButton *addMediaButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *createMailboxActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *createMailboxButton;

@property (strong,nonatomic) UIAlertView *noMessageAlert;
@property (strong,nonatomic) UIAlertView *noMediaAlert;


@end

#define MESSAGE_PLACE_HOLDER @"Type messsage here..."

@implementation FVCreateMailboxViewController

#pragma mark - view controller state

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.messageTextArea.delegate = self;
    self.createMailboxActivityIndicator.hidden = YES;

    self.noMessageAlert = [[UIAlertView alloc] initWithTitle:@"NO MESSAGE"
                                                           message:@"Please type a message"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil
                                 ];
    
    self.noMediaAlert = [[UIAlertView alloc] initWithTitle:@"NO PHOTO/VIDEO"
                                                         message:@"Please choose a photo or video"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil
                               ];

}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - azure

-(void)updateMediaToMailbox:(NSString *)mailboxID blobUrl:(NSString *)blobUrl mediaType:(FVMediaType)mediaType
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *mailboxTable = [client tableWithName:@"mailbox"];
    
    NSMutableDictionary *mailboxInfo = [[NSMutableDictionary alloc] init];
    mailboxInfo[@"id"] = mailboxID;
    mailboxInfo[@"media"] = blobUrl;
    if (mediaType == FVMediaVideoType) {
        mailboxInfo[@"media_type"] = @"video";
    }else if( mediaType == FVMediaImageType){
        mailboxInfo[@"media_type"] = @"image";
    }
    
    dispatch_async( dispatch_get_main_queue(), ^{
        [mailboxTable update:mailboxInfo completion:^(NSDictionary *item, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
            else{
                NSLog(@"3/3 update media to mailbox table complete");
                NSLog(@"create mailbox id = %@ complete",mailboxID);
                
                self.createdMailbox.mediaType = mediaType;
                self.createdMailbox.media = blobUrl;
                [self performSegueWithIdentifier:@"viewCreatedMailbox" sender:self];
            }
        }];
    });
   
}

-(void)uploadBlobMediaToMailboxContainer:(NSString *)mailboxID
{
    NSString *blobName = [NSString stringWithFormat:@"%@.%@",mailboxID,self.selectedMediaExtension];
    
    FVBlobStorageService *blobService = [FVBlobStorageService getInstance];
    [blobService getSasUrlForNewBlob:blobName forContainer:[FVBlobStorageService mailboxMediaContainer]
                      withCompletion:^(NSString *sasUrl, NSError *error) {
                          if (error) {
                              NSLog(@"%@",error);
                              return;
                          }
                          NSString *blobUrl = [NSString stringWithFormat:@"%@/%@/%@",
                                               [FVBlobStorageService blobUrl],
                                               [FVBlobStorageService mailboxMediaContainer],
                                               blobName
                                               ];
                          if (self.selectedMediaType == FVMediaVideoType) {
                              [blobService postBlobWithUrl:sasUrl NSData:self.selectedMediaData withCompletion:^(BOOL isSuccess) {
                                  NSLog(@"2/3 upload media (video) complete");
                                  [self updateMediaToMailbox:mailboxID blobUrl:blobUrl mediaType:self.selectedMediaType];
                              }];
                          }else if(self.selectedMediaType == FVMediaImageType){
                              [blobService postImageToBlobWithUrl:sasUrl NSData:self.selectedMediaData withCompletion:^(BOOL isSuccess) {
                                  NSLog(@"2/3 upload media (image) complete");
                                  [self updateMediaToMailbox:mailboxID blobUrl:blobUrl mediaType:self.selectedMediaType];
                              }];
                          }
                      }
     ];
}

- (IBAction)createMailbox
{
    //if don't type a message
    NSCharacterSet *charset = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *message =  [self.messageTextArea.text stringByTrimmingCharactersInSet:charset];
    if( self.messageTextArea.tag == 0 || [message isEqualToString:@""] )
    {
        [self.noMessageAlert show];
        return;
    }
    //if don't select any media
    if ( ! self.isSelectedMedia ) {
        [self.noMediaAlert show];
        return;
    }
    
    
    self.createMailboxActivityIndicator.hidden = NO;
    [self.createMailboxActivityIndicator startAnimating];
    self.createMailboxButton.enabled = NO;
    
    NSDictionary *mailboxInfo = @{
                               @"owner_id": [[FVUser currentUser] user_id],
                               @"message" : message,
                               @"latitude" : @(self.location.latitude),
                               @"longitude" : @(self.location.longitude)
                               };
    
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *mailboxTable = [client tableWithName:@"mailbox"];
    [mailboxTable insert:mailboxInfo completion:^(NSDictionary *item, NSError *error) {
        if(error)
        {
            NSLog(@"%@",error);
        }
        else
        {
            NSLog(@"1/3 insert mailbox info");
            
            self.createdMailbox = [[FVMailbox alloc] initWithMailboxDictionary:item];
            self.createdMailbox.owner = [FVUser currentUser];
            
            if ( self.isSelectedMedia )
            {
                [self uploadBlobMediaToMailboxContainer:self.createdMailbox.mailbox_id];
            }
        }
    }];
}

#pragma mark - view controller eventhandler

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewCreatedMailbox"]) {
        if([segue.destinationViewController isKindOfClass:[FVMailboxViewController class]])
        {
            FVMailboxViewController *mailboxVC = (FVMailboxViewController *)segue.destinationViewController;
            mailboxVC.mailbox = self.createdMailbox;
        }
        
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.noMessageAlert) {
        self.messageTextArea.text = @"";
        [self.messageTextArea becomeFirstResponder];
    }
}

#pragma mark - textview delegate

//place holder workaround
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        textView.text = MESSAGE_PLACE_HOLDER;
        textView.textColor = [UIColor lightGrayColor];
        textView.tag = 0;
    }
}
/////place holder workaround

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - media control logic

- (IBAction)addMedia
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[ (NSString *)kUTTypeMovie , (NSString *)kUTTypeImage ];
    self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        NSURL *movieUrl = [info valueForKey:UIImagePickerControllerMediaURL];
        [self.mediaView setupWithMovieUrl:movieUrl];
        
        self.selectedMediaExtension = [movieUrl pathExtension];
        self.selectedMediaData = [NSData dataWithContentsOfURL:movieUrl];
        self.selectedMediaType = FVMediaVideoType;
    }
    else if( [mediaType isEqualToString:(NSString *)kUTTypeImage] )
    {
        UIImage *selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        [self.mediaView setupWithImage:selectedImage];
        
        self.selectedMediaExtension = @"jpg";
        self.selectedMediaData = UIImageJPEGRepresentation( selectedImage , 0.15 );
        self.selectedMediaType = FVMediaImageType;
    }
    
    self.isSelectedMedia = YES;
    
    [self.addMediaButton removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end





