//
//  PhotoDatabase.m
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/15/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

#import "PhotoDatabase.h"

@implementation PhotoDatabase

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createDBIfNotExists];
    }
    return self;
}

- (void)createDBIfNotExists
{
	NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    self.databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"photos.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: self.databasePath ] == NO)
    {
        const char *dbpath = [self.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_photoDB) == SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS PHOTOS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, IMAGEURL TEXT, DATETAKEN TEXT)";
            
            
            if (sqlite3_exec(self.photoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            
            sqlite3_close(self.photoDB);
            
        }
        else {
            NSLog(@"Failed to open/create database");
        }
    }

}

- (BOOL)savePhoto:(Photo *)photo
{
	BOOL isPhotoSaved = NO;
	sqlite3_stmt *statement;
    const char *dbpath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_photoDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO PHOTOS (NAME, IMAGEURL, DATETAKEN) VALUES (\"%@\", \"%@\", \"%@\")",
                               photo.name, photo.imageUrl, photo.dateTaken];
        
        const char *insert_stmt = [insertSQL UTF8String];
		NSLog(@"insert stmt = %s", insert_stmt);
        
        sqlite3_prepare_v2(self.photoDB, insert_stmt,
                           -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            isPhotoSaved = YES;
			NSLog(@"photo saved");
        } else {
            isPhotoSaved = NO;
			NSLog(@"photo not saved");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(self.photoDB);
    }
	return isPhotoSaved;
}

- (NSArray *)getPhotoCollection
{
	NSMutableArray *photoCollection = [[NSMutableArray alloc] init];
	const char *dbpath = [self.databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_photoDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT NAME, IMAGEURL, DATETAKEN \
							  FROM PHOTOS \
							  ORDER BY DATETAKEN ASC";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(self.photoDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
				Photo *currentPhoto = [[Photo alloc] init];
				
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                currentPhoto.name = name;
                
                NSString *imageUrl = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                currentPhoto.imageUrl = [NSURL URLWithString:imageUrl];
				
				NSString *datePhotoTakenString = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
				
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
				currentPhoto.dateTaken = [dateFormatter dateFromString:datePhotoTakenString];
                
                [photoCollection addObject:currentPhoto];
            }
            
        }
		else
		{
			NSLog(@"No Data Found");
		}
		
        sqlite3_finalize(statement);
    }
	sqlite3_close(self.photoDB);
	
	return photoCollection;
}

@end
