//
//  FVMailboxAnnotation.m
//  FOVE
//
//  Created by Nutchaphon Rewik on 2/3/14.
//  Copyright (c) 2014 Nutchaphon Rewik. All rights reserved.
//

#import "FVMailboxAnnotation.h"

@implementation FVMailboxAnnotation


-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [self initWithTitle:nil subtitle:nil coordinate:coordinate];
}

-(instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate
{
    return [self initWithTitle:title subtitle:nil coordinate:coordinate];
}

-(instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if(self)
    {
        _coordinate = coordinate;
        _subtitle = subtitle;
        _title = title;
    }
    return self;
}

-(instancetype)initWithMailbox:(FVMatchingMailbox *)mailbox
{
    _mailbox = mailbox;
    return [self initWithTitle:mailbox.owner.name subtitle:mailbox.message coordinate:mailbox.location];
}

@end
