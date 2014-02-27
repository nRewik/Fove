//
//  FVMailboxAnnotation.h
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/3/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FVMatchingMailbox.h"

@interface FVMailboxAnnotation : NSObject <MKAnnotation>

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
-(instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;
-(instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate;
-(instancetype)initWithMailbox:(FVMailbox *)mailbox;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (strong,nonatomic) FVMatchingMailbox *mailbox;

@end
