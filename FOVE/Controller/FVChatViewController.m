//
//  FVChatViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/11/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVChatViewController.h"

@interface FVChatViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *artImageView;
@property (weak, nonatomic) IBOutlet UIImageView *catImageView;

@end

@implementation FVChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"< Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    self.artImageView.image = [UIImage imageNamed:@"test_art.png"];
    self.catImageView.image = [UIImage imageNamed:@"test_cat.png"];
}
-(void)goBack
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
