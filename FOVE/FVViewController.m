//
//  FVViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 1/24/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVViewController.h"
#import "FVAppDelegate.h"
#import "FVProfileViewController.h"
#import "FVUser.h"
#import "FVBlobStorageService.h"

@interface FVViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicatorView;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@property BOOL isFetched;

@end

@implementation FVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.loginActivityIndicatorView stopAnimating];
    
    //fb login view setup
    NSArray *permission = @[@"user_about_me",
                                @"user_birthday",
                                @"user_likes",
                                @"user_checkins",
                                @"user_location",
                                @"user_actions.music",
                                @"user_activities",
                                @"user_interests",
                                @"user_relationships"
                            ];
    self.loginView.readPermissions = permission;
    self.loginView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToFove
{
    NSAssert( [FVUser currentUser] != nil, @"current user should not be nil before go to fove");
    
    [self.loginActivityIndicatorView stopAnimating];
    [self performSegueWithIdentifier:@"goToFove" sender:self];
}

-(void)setupCurrentUserAs:(FVUser *)user withFacebook:(id<FBGraphUser>)facebookUserData
{
    [FVUser setCurrentUser:user];
    [FVUser currentUser].facebookUserData = facebookUserData;
}

#pragma mark - facebook_delegate

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)facebookUserData {
    if ( self.isFetched == YES)
    {
        return;
    }
    self.isFetched = YES;
    if([FVUser currentUser] == nil)
    {
        [self loginWithFacebook:facebookUserData];
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    [self.loginActivityIndicatorView startAnimating];
    
    self.loginView.hidden = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.isFetched = NO;
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark - registerFacebookDatabase

-(void)loginWithFacebook:(id<FBGraphUser>)facebookUserData
{
    if(facebookUserData == nil){
        return;
    }
    
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    MSQuery *query = [table query];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"facebookid == %@",[facebookUserData id]];
    
    query.predicate = predicate;
    query.selectFields = @[ @"id" , @"user_id" ];
    
    [query readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error){
        
         if (error) { NSLog(@"%@",error); return; }
         
         if([items count] <= 0)
         {
             NSLog(@"register FB DB for %@",[facebookUserData name]);
             
             // 0) insert fove userinfo
             MSTable *userInfoTable = [client tableWithName:@"userinfo"];
             
             
             ////age
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
             [dateFormat setDateFormat:@"MM/dd/yyyy"];
             NSDate *birthday = [dateFormat dateFromString:[facebookUserData birthday]];
             
             NSDate* now = [NSDate date];
             NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                components:NSYearCalendarUnit
                                                fromDate:birthday
                                                toDate:now
                                                options:0];
             NSInteger age = [ageComponents year];
             
             NSDictionary *userItem = @{  @"name" : [facebookUserData name],
                                          @"gender" : [facebookUserData objectForKey:@"gender"],
                                          @"relationship" : [facebookUserData objectForKey:@"relationship_status"],
                                          @"age" : @(age)
                                          };
             
             [userInfoTable insert:userItem completion:^(NSDictionary *item, NSError *error) {
                 
                 if(error){
                     NSLog(@"%@",error);
                     return;
                 }
                 
                 NSLog(@"registered fove userinfo");
                 
                 // 1) insert basic_info
                 NSDictionary *facebookItem = @{ @"facebookid" : [facebookUserData id] ,
                                                 @"birthday" : [facebookUserData birthday],
                                                 @"name" : [facebookUserData name],
                                                 @"gender" : [facebookUserData objectForKey:@"gender"],
                                                 @"user_id" : item[@"id"]
                                         };
                 NSString *userID = item[@"id"];
                 [table insert:facebookItem completion:^(NSDictionary *item, NSError *error){
                      if (error) { NSLog(@"%@",error); return; }
                      else{ NSLog(@"register facebook basic_info complete"); }
                      
                      NSString *itemId = item[@"id"];
                     
                      [self updatePagelikes:itemId withCompletion:^{
                          [self updateMovies:itemId withCompletion:^{
                              [self updateMusic:itemId withCompletion:^{
                                  [self updateCheckin:itemId withCompletion:^{
                                      [self getUserProfileImage:userID withCompletion:^{
                                          [FVUser getUserFromID:userID completion:^(FVUser *resultUser, NSError *error) {
                                              
                                              [self setupCurrentUserAs:resultUser withFacebook:facebookUserData];
                                              [self goToFove];
                                              
                                              NSLog(@"registration complete");
                                              
                                          }];
                                      }];
                                  }];
                              }];
                          }];
                      }];
                  }];
                 
             }];
         }
         else
         {
             //find user associated with facebook id
             MSTable *userTable = [client tableWithName:@"userinfo"];
             
             NSString *userID = [items[0] objectForKey:@"user_id"];
             [userTable readWithId:userID completion:^(NSDictionary *item, NSError *error) {
                 
                 FVUser *loginUser = [[FVUser alloc] initWithUserDictionary:item];
                 [self setupCurrentUserAs:loginUser withFacebook:facebookUserData];
                 [self goToFove];
                 
                 NSLog(@"login with facebook !!");
             }];
         }
     }];
}

-(void)getUserProfileImage:(NSString *)userID withCompletion:(void (^)() )completion
{
    
    [FBRequestConnection startWithGraphPath:@"/me?fields=picture.type(large)" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
        if(error)
        {
            NSLog(@"%@",error);
        }
        else
        {
            //get image from facebook "getImageFromFacebookqueue"
            NSString *fbImageUrl = result[@"picture"][@"data"][@"url"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fbImageUrl]];

            NSString *blobName = [NSString stringWithFormat:@"%@.png",userID];
            FVBlobStorageService *blobStorage = [FVBlobStorageService getInstance];
            
            [blobStorage getSasUrlForNewBlob:blobName forContainer:[FVBlobStorageService profileImageContainer] withCompletion:^(NSString *sasUrl, NSError *error)
             {
                 [blobStorage postImageToBlobWithUrl:sasUrl NSData:imageData withCompletion:^(BOOL isSuccess)
                  {
                      NSLog(@"upload facebook photo = %@",isSuccess?@"YES":@"NO");
                      NSString *foveImageUrl = [NSString stringWithFormat:@"%@/%@/%@",
                                                [FVBlobStorageService blobUrl],
                                                [FVBlobStorageService profileImageContainer],
                                                blobName
                                                ];
                      
                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                          [self updateImageURL:foveImageUrl toUserInfo:userID withCompletion:completion];
                      }];
                  }];
             }];
        }
    }];
}

-(void)updateImageURL:(NSString *)imageUrl toUserInfo:(NSString *)userId withCompletion:(void (^)() )completion
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"userinfo"];
    
    NSDictionary *item = @{ @"id" : userId , @"profileimage" : imageUrl };
    [table update:item completion:^(NSDictionary *item, NSError *error)
    {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else
        {
            NSLog(@"insert image url complete");
            completion();
        }
    }];
}


-(void)updateCheckin:(NSString *)itemId withCompletion:(void (^)() )completion
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    [FBRequestConnection startWithGraphPath:@"/me?fields=checkins.fields(place)&limit=100" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error) { NSLog(@"%@",error); return; }
         
         NSDictionary *checkin= result[@"checkins"][@"data"];
         
         if (checkin == nil)
         {
             completion();
         }
         else
         {
             NSDictionary *item = @{ @"id" : itemId, @"checkin" : [checkin description] };
             
             [table update:item completion:^(NSDictionary *item, NSError *error) {
                 if (error) { NSLog(@"%@",error); return; }
                 else
                 {
                     NSLog(@"registered facebook checkin");
                     completion();
                 }
             }];
         }
         
     }];
}
-(void)updateMusic:(NSString *)itemId withCompletion:(void (^)() )completion
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    [FBRequestConnection startWithGraphPath:@"/me?fields=music.fields(id,name)&limit=100" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error) { NSLog(@"%@",error); return; }
         
         NSDictionary *music = result[@"music"][@"data"];
         
         if(music == nil)
         {
             completion();
         }
         else
         {
             NSDictionary *item = @{ @"id" : itemId, @"music" : [music description] };
             
             [table update:item completion:^(NSDictionary *item, NSError *error) {
                 if (error) { NSLog(@"%@",error); return; }
                 else
                 {
                     NSLog(@"registered facebook music");
                     completion();
                 }
             }];
         }
     }];
}
-(void)updateMovies:(NSString *)itemId withCompletion:(void (^)() )completion
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    [FBRequestConnection startWithGraphPath:@"/me?fields=movies&limit=100" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error) { NSLog(@"%@",error); return; }
         
         NSDictionary *movies= result[@"movies"][@"data"];
         
         if(movies == nil)
         {
             completion();
         }
         else
         {
             NSDictionary *item = @{ @"id" : itemId, @"movie" : [movies description] };
             
             [table update:item completion:^(NSDictionary *item, NSError *error) {
                 if (error) { NSLog(@"%@",error); return; }
                 else
                 {
                     NSLog(@"registered facebook movies");
                     completion();
                 }
                 
             }];
         }
         
     }];
}
-(void)updatePagelikes:(NSString *)itemId withCompletion:(void (^)() )completion
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    [FBRequestConnection startWithGraphPath:@"/me/likes?fields=name&limit=200" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error) { NSLog(@"%@",error); return; }
         
         NSDictionary *myLikes = result[@"data"];
         
         if( myLikes == nil)
         {
             completion();
         }
         else
         {
             NSDictionary *item = @{ @"id" : itemId, @"pagelike" : [myLikes description] };
             [table update:item completion:^(NSDictionary *item, NSError *error) {
                 if (error) { NSLog(@"%@",error); return; }
                 else
                 {
                     NSLog(@"registered facebook pagelike");
                     completion();
                 }
                 
             }];
         }
         
     }];
}
#pragma mark -





@end
