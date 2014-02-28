//
//  FVProfileViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 1/28/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVProfileViewController.h"
#import "FVUser.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "FVAzureService.h"

@interface FVProfileViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editProfileButton;
@property (strong,nonatomic) UIBarButtonItem *doneEditProfileButton;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (strong,nonatomic) UIActionSheet *sexActionSheet;
@property (strong,nonatomic) UIActionSheet *relationShipActionSheet;

@property (strong,nonatomic) UIAlertView *statusAlertView;

@property (strong,nonatomic) NSMutableArray *details; // or NSString;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *photos;


@end

@implementation FVProfileViewController


- (void)viewDidLoad
{
    NSAssert( self.user != nil , @"self.user should not be nil !!");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.statusButton.enabled = NO;
    self.detailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self updateUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.detailTableView reloadData];
}

#pragma mark - lazy instantiation
-(NSMutableArray *)details
{
    if (!_details) {
        _details = [[NSMutableArray alloc] init];
        
        [_details addObject:self.user.gender]; //gender
        [_details addObject:[NSString stringWithFormat:@"%d",self.user.age]]; //age
        [_details addObject:self.user.relationship];
//        [_details addObject:self.user.interestedGender];
//        [_details addObject:self.user.hobby];
        
    }
    return _details;
}
-(UIBarButtonItem *)doneEditProfileButton
{
    if (!_doneEditProfileButton) {
        _doneEditProfileButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(finishEditing)];
    }
    return _doneEditProfileButton;
}
-(UIActionSheet *)sexActionSheet
{
    if (!_sexActionSheet) {
        _sexActionSheet = [[UIActionSheet alloc] initWithTitle:@"Gender"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Male",@"Female",@"Other",nil];
    }
    return _sexActionSheet;
}
-(UIActionSheet *)relationShipActionSheet
{
    if (!_relationShipActionSheet) {
        _relationShipActionSheet = [[UIActionSheet alloc] initWithTitle:@"Relationship"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Single",@"Married",@"Complicate",nil];
    }
    return _relationShipActionSheet;
}
-(UIAlertView *)statusAlertView
{
    if (!_statusAlertView) {
        _statusAlertView = [[UIAlertView alloc] initWithTitle:@"Edit Status"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        _statusAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    return _statusAlertView;
}

#pragma mark - action
- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)editProfile:(id)sender
{
    [self setRightBarButtonItem:self.doneEditProfileButton];
    [self.detailTableView setEditing:YES animated:YES];
    
    if (self.statusLabel.text == nil) {
        self.statusLabel.text = @"Edit Status Here...";
        [self.statusLabel sizeToFit];
    }
    self.statusButton.enabled = YES;
}
-(void)finishEditing
{
    [self setRightBarButtonItem:self.editProfileButton];
    [self.detailTableView setEditing:NO animated:YES];
    self.statusButton.enabled = NO;

    
    MSClient *client = [FVAzureService sharedClient];
    MSTable *userTable = [client tableWithName:@"userinfo"];
    
    NSDictionary *parameter = @{ @"id" : self.user.user_id,
                                 @"status" : self.user.status,
                                 @"relationship" : self.user.relationship,
                                 @"gender" : self.user.gender
                                 };
    
    [userTable update:parameter completion:^(NSDictionary *item, NSError *error) {
        NSLog(@"Update Complete");
    }];
}
- (IBAction)editStatus
{
    [self.statusAlertView show];
}

#pragma mark - UI
-(void)updateUI
{
    self.details = nil;
    
    self.nameLabel.text = self.user.name;
    self.statusLabel.text = self.user.status;
    
    [self.statusLabel sizeToFit];
    
    self.profileImageView.image = self.user.profileImage;
    
    for (UIImageView *imv in self.photos) {
        imv.image = self.user.profileImage;
    }
    
    if (self.user != [FVUser currentUser]) {
        [self setRightBarButtonItem:nil];
    }
    
    [self.detailTableView reloadData];
}
-(void)setRightBarButtonItem:(UIBarButtonItem *)button
{
    button.tintColor = [UIColor whiteColor];
    
    UINavigationItem *item =  self.navigationBar.items[0];
    item.rightBarButtonItem = button;
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.details count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *profileCellIdentifier = @"profileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.details[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    if (row == 0) {
        [self.sexActionSheet showInView:self.view];
    }
    else if(row == 2)
    {
        [self.relationShipActionSheet showInView:self.view];
    }

}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.sexActionSheet && buttonIndex != self.sexActionSheet.numberOfButtons-1) {
        self.user.gender = [self.sexActionSheet buttonTitleAtIndex:buttonIndex];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.detailTableView deselectRowAtIndexPath:path animated:YES];
        
        [self updateUI];
    }
    else if(actionSheet == self.relationShipActionSheet && buttonIndex != self.relationShipActionSheet.numberOfButtons-1) {
        self.user.relationship = [self.relationShipActionSheet buttonTitleAtIndex:buttonIndex];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.detailTableView deselectRowAtIndexPath:path animated:YES];
        
        [self updateUI];
    }
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.statusAlertView && buttonIndex != 0) {
        
        NSString *text = [[self.statusAlertView textFieldAtIndex:0] text];
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ( ! [text isEqualToString:@""] ) {
            self.user.status = text;
            [self updateUI];
        }
    }
}
@end








