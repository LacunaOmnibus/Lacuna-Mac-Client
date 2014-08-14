//
//  LEPlanet.h
//  LacunaExpanse
//
//  Created by Mizar on 8/11/14.
//  Copyright (c) 2014 Mizar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEPlanet : NSObject {
    NSString *planetName;
    NSString *planetStatus;
}
@property (readwrite, copy) NSString *planetName;
@property (readwrite, copy) NSString *planetStatus;

@end
