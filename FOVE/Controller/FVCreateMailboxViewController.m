//
//  FVCreateMailboxViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/1/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVCreateMailboxViewController.h"

#import "FVMailboxViewController.h"
#import "FVUser.h"
#import "FVAppDelegate.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface FVCreateMailboxViewController () <UITextFieldDelegate>
{
    FVMailbox *_createdMailbox;
}

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@end

@implementation FVCreateMailboxViewController

- (IBAction)createMailbox
{
    //
    // connect to azure api
    //...
    NSDictionary *mailDict = @{
                                    @"owner_id": [[FVUser currentUser] user_id],
                                    @"title" : self.titleTextField.text,
                                    @"message" : self.messageTextField.text,
                                    @"latitude" : @(self.location.latitude),
                                    @"longitude" : @(self.location.longitude)
                                    };
    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *mailboxTable = [client tableWithName:@"mailbox"];
    [mailboxTable insert:mailDict completion:^(NSDictionary *item, NSError *error) {
        if(error)
        {
            NSLog(@"%@",error);
            //error happened
        }
        else
        {
            _createdMailbox = [[FVMailbox alloc] initWithMailboxDictionary:item];
            _createdMailbox.owner = [FVUser currentUser];
            [self performSegueWithIdentifier:@"viewCreatedMailbox" sender:self];
        }
    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewCreatedMailbox"]) {
        if([segue.destinationViewController isKindOfClass:[FVMailboxViewController class]])
        {
            FVMailboxViewController *mailboxVC = (FVMailboxViewController *)segue.destinationViewController;
            mailboxVC.mailbox = _createdMailbox;
        }
    
    }
}




- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.titleTextField.delegate = self;
    self.messageTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	
	return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
