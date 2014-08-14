//
//  LEPlanet.m
//  LacunaExpanse
//
//  Created by Mizar on 8/11/14.
//  Copyright (c) 2014 Mizar. All rights reserved.
//

#import "LEPlanet.h"

@implementation LEPlanet

@synthesize planetName;
@synthesize planetStatus;

- (id)init
{
    self = [super init];
    if (self) {
        planetName = @"New Planet";
        planetStatus = @"New";
    }
    return self;
}

@end
