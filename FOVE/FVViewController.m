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

@interface FVViewController ()
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@end

@implementation FVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    //self.loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    self.loginView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadDataFromAzure {
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    
    id<FBGraphUser> facebookUser = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] facebookUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"facebookid == %@",[facebookUser id]];
    
    [table readWithPredicate:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if (error) { NSLog(@"%@",error); return; }
        
        if([items count] <= 0) return;
        
        //first item from query
        //NSDictionary *data = items[0];
        //NSLog(@"%@",[data objectForKey:@"pagelikes"]);
    }];
    
    
    
}

#pragma mark - facebook_delegate

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    if ([[FVUser currentUser] facebook] == nil) {
        
        [[FVUser currentUser] setFacebook:user];
        [self loginWithFacebook];
        
        FVProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTabView"];
        [self presentViewController:profileVC animated:YES completion:nil];
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    //self.statusLabel.text = @"You're logged in as";
    self.loginView.hidden = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    //self.statusLabel.text= @"You're not logged in!";
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

-(void)loginWithFacebook
{
    id<FBGraphUser> facebookUser = [FVUser currentUser].facebook;
    
    if(facebookUser == nil){
        return;
    }
    
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"facebookid == %@",[facebookUser id]];
    [table readWithPredicate:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error)
     {
         if (error) { NSLog(@"%@",error); return; }
         
         if([items count] <= 0)
         {
             NSLog(@"register FB DB for %@",[facebookUser name]);
             
             // 0) insert fove userinfo
             MSTable *userInfoTable = [client tableWithName:@"userinfo"];
             
             
             ////age
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
             [dateFormat setDateFormat:@"MM/dd/yyyy"];
             NSDate *birthday = [dateFormat dateFromString:[facebookUser birthday]];
             
             NSDate* now = [NSDate date];
             NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                components:NSYearCalendarUnit
                                                fromDate:birthday
                                                toDate:now
                                                options:0];
             NSInteger age = [ageComponents year];
             
             NSDictionary *userItem = @{  @"name" : [facebookUser name],
                                          @"gender" : [facebookUser objectForKey:@"gender"],
                                          @"relationship" : [facebookUser objectForKey:@"relationship_status"],
                                          @"age" : @(age)
                                          };
             
             [userInfoTable insert:userItem completion:^(NSDictionary *item, NSError *error) {
                 
                 if(error){
                     NSLog(@"%@",error);
                     return;
                 }
                 
                 NSLog(@"registered fove userinfo");
                 
                 // 1) insert basic_info
                 NSDictionary *facebookItem = @{ @"facebookid" : [facebookUser id] ,
                                                 @"birthday" : [facebookUser birthday],
                                                 @"name" : [facebookUser name],
                                                 @"gender" : [facebookUser objectForKey:@"gender"],
                                                 @"user_id" : [item objectForKey:@"id"]
                                         };
                 [table insert:facebookItem completion:^(NSDictionary *item, NSError *error)
                  {
                      if (error) { NSLog(@"%@",error); return; }
                      else{ NSLog(@"register basic_info complete"); }
                      
                      NSString *itemId = [item objectForKey:@"id"];
                      
                      [self insertPagelikes:itemId];
                      [self insertMovies:itemId];
                      [self insertMusic:itemId];
                      [self insertCheckin:itemId];
                  }];
                 
             }];
         }
         else
         {
             //find user associated with facebook id
             
             MSTable *userTable = [client tableWithName:@"userinfo"];
             
             NSString *userID = [items[0] objectForKey:@"user_id"];
             [userTable readWithId:userID completion:^(NSDictionary *item, NSError *error) {
                 [[FVUser currentUser] setUserWithDictionary:item];
             }];
             NSLog(@"login with facebook !!");
         }
     }];
}


-(void)insertCheckin:(NSString *)itemId
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    [FBRequestConnection startWithGraphPath:@"/me?fields=checkins.fields(place)&limit=100" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error) { NSLog(@"%@",error); return; }
         
         NSDictionary *checkin= [[result objectForKey:@"checkins"] objectForKey:@"data"];
         
         if (checkin == nil) { return; }
         
         NSDictionary *item = @{ @"id" : itemId, @"checkin" : [checkin description] };
         
         [table update:item completion:^(NSDictionary *item, NSError *error) {
             if (error) { NSLog(@"%@",error); return; }
             else{ NSLog(@"registered checkin"); }
         }];
         
     }];
}
-(void)insertMusic:(NSString *)itemId
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    [FBRequestConnection startWithGraphPath:@"/me?fields=music.fields(id,name)&limit=100" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error) { NSLog(@"%@",error); return; }
         
         NSDictionary *music = [[result objectForKey:@"music"] objectForKey:@"data"];
         
         if(music == nil) { return; }
         
         NSDictionary *item = @{ @"id" : itemId, @"music" : [music description] };
         
         [table update:item completion:^(NSDictionary *item, NSError *error) {
             if (error) { NSLog(@"%@",error); return; }
             else{ NSLog(@"registered music"); }
         }];
         
     }];
}
-(void)insertMovies:(NSString *)itemId
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    [FBRequestConnection startWithGraphPath:@"/me?fields=movies&limit=100" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error) { NSLog(@"%@",error); return; }
         
         NSDictionary *movies= [[result objectForKey:@"movies"] objectForKey:@"data"];
         
         if(movies == nil){ return; }
         
         NSDictionary *item = @{ @"id" : itemId, @"movie" : [movies description] };
         
         [table update:item completion:^(NSDictionary *item, NSError *error) {
             if (error) { NSLog(@"%@",error); return; }
             else{ NSLog(@"registered movies"); }
             
         }];
         
     }];
}
-(void)insertPagelikes:(NSString *)itemId
{
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *table = [client tableWithName:@"Facebook"];
    [FBRequestConnection startWithGraphPath:@"/me/likes?fields=name&limit=200" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error) { NSLog(@"%@",error); return; }
         
         NSDictionary *myLikes = [result objectForKey:@"data"];
         
         if( myLikes == nil){ return; }
         
         NSDictionary *item = @{ @"id" : itemId, @"pagelike" : [myLikes description] };
         
         [table update:item completion:^(NSDictionary *item, NSError *error) {
             if (error) { NSLog(@"%@",error); return; }
             else{ NSLog(@"registered pagelike"); }
             
         }];
         
     }];
}
#pragma mark -





@end
