//
//  PhotoDatabase.h
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/15/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

#import <sqlite3.h>
#import "Photo.h"

@interface PhotoDatabase : NSObject

@property (nonatomic) sqlite3 *photoDB;
@property (strong, nonatomic) NSString *databasePath;

- (BOOL)savePhoto:(Photo *)photo;
- (NSArray *)getPhotoCollection;
@end
