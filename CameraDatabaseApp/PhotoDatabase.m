//
//  PhotoDatabase.m
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/15/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

#import "PhotoDatabase.h"

@implementation PhotoDatabase

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self createDBIfNotExists];
    }
    return self;
}

+ (PhotoDatabase *)sharedDBInstance
{
    // 1
    static PhotoDatabase *_sharedDBInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedDBInstance = [[PhotoDatabase alloc] init];
    });
    
    return _sharedDBInstance;
}

- (void)createDBIfNotExists
{
    NSLog(@"Created DB");
}

@end
