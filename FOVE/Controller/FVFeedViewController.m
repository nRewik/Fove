//
//  FVFeedViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/8/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVFeedViewController.h"

#import "FVBlobStorageService.h"

@interface FVFeedViewController ()


//mock up

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *photos;
@property (weak, nonatomic) IBOutlet UIImageView *artImageView;

@end

@implementation FVFeedViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    for (int i=1; i<=6; i++) {
        UIImageView *imv = (UIImageView *)self.photos[i-1];
        imv.image = [UIImage imageNamed:[NSString stringWithFormat:@"test_profile_%d",i]];
    }
    
    self.artImageView.image = [UIImage imageNamed:@"test_art.png"];
}

@end
