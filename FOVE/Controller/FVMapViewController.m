//
//  FVMapViewController.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/1/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVMapViewController.h"

#import "FVCreateMailboxViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FVMailbox.h"
#import "FVMailboxAnnotation.h"
#import "FVMailboxViewController.h"

#import "FVAppDelegate.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface FVMapViewController () <CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong,nonatomic) FVMailbox *currentSelectedMailbox;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation FVMapViewController


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //create mailbox
    if ( [segue.identifier isEqualToString:@"createMailbox"])
    {
        id destinationVC = segue.destinationViewController;
        if ([destinationVC isKindOfClass:[FVCreateMailboxViewController class]]) {
            FVCreateMailboxViewController *createMailboxVC = (FVCreateMailboxViewController *)destinationVC;
            createMailboxVC.location = [[[self.mapView userLocation] location] coordinate];
        }
    }
    else if( [segue.identifier isEqualToString:@"viewMailbox"])
    {
        id destinationVC = segue.destinationViewController;
        if( [destinationVC isKindOfClass:[FVMailboxViewController class]])
        {
            FVMailboxViewController *mailboxVC = (FVMailboxViewController *)destinationVC;
            mailboxVC.mailbox = self.currentSelectedMailbox;
        }
        
    }
    
    
    
}

- (IBAction)changeLoc {
    //CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(13.7281169, 100.7791107);
    //self.mapView.userLocation.location = loc;
}


#pragma mark - mapkit


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //Todo : view selected mailbox
    //...
    id annotation = view.annotation;
    if ( [annotation isKindOfClass:[FVMailboxAnnotation class]] ) {
        FVMailboxAnnotation *pin = (FVMailboxAnnotation *)annotation;
        self.currentSelectedMailbox = pin.mailbox;
        [self performSegueWithIdentifier:@"viewMailbox" sender:self];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationDistance spanDistance = 500;
    
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, spanDistance , spanDistance);
    [mapView setRegion:region animated:YES];
    
    NSDictionary *locationDict = @{ @"latitude": @(loc.latitude),
                                    @"longitude" : @(loc.longitude),
                                    @"radius" : @(spanDistance / 1000.0) //in km.
                                    };

    MSClient *client = [(FVAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    [client invokeAPI:@"viewnearlymailbox"
                 body:nil HTTPMethod:@"get"
           parameters:locationDict
              headers:nil
           completion:^(id result, NSHTTPURLResponse *response, NSError *error){
               //NSLog(@"%@",result);
               if( error)
               {
                   NSLog(@"%@",error);
               }
               else
               {
                   if (result != nil)
                   {
                       // add annotation of mailbox around me on map
                       if ([result objectForKey:@"found"] != [NSNull null])
                       {
                           NSInteger mailCount = [[result objectForKey:@"found"] integerValue];
                           NSMutableArray *mailboxList = [[NSMutableArray alloc] initWithCapacity:mailCount];
                           NSArray *mailDictArray = [result objectForKey:@"mailbox_list"];
                           for (int i=0; i<mailCount; i++)
                           {
                               mailboxList[i] = [[FVMailbox alloc] initWithMailboxDictionary:mailDictArray[i]];
                           }
                           for (int i=0; i<mailCount; i++)
                           {
                               FVMailbox *mailbox = (FVMailbox *)mailboxList[i];
                               if ( ![self isAnnotateInMap:mailbox] ) {
                                   FVMailboxAnnotation *pin = [[FVMailboxAnnotation alloc] initWithMailbox:mailbox];
                                   [self.mapView addAnnotation:pin];
                               }
                           }
                       }
                   }
               }
               
           }
     ];
    
    NSLog(@"%d",[self.mapView.annotations count]);
    
    
}

-(BOOL)isAnnotateInMap:(FVMailbox *)mailbox
{
    for (int i=0; i<[self.mapView.annotations count]; i++) {
        id annotation = self.mapView.annotations[i];
        if ([annotation isKindOfClass:[FVMailboxAnnotation class]]) {
            FVMailboxAnnotation *pin = (FVMailboxAnnotation *)annotation;
            if ([pin.mailbox.mailbox_id isEqualToString:mailbox.mailbox_id]) {
                return YES;
            }
        }
    }
    return NO;
}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //mapview init
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = NO;
    self.mapView.delegate = self;
    
    
    self.navigationController.navigationBarHidden = YES;
    //transition
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




