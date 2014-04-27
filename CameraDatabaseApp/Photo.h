
//  Photo.h
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/13/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface Photo : NSObject

//@property (nonatomic) CGRect visibleRect;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *imageUrl;
@property (strong, nonatomic) NSMutableDictionary *photoDictionary;
@property (strong, nonatomic) NSDate *dateTaken;
//@property (nonatomic) CLLocationCoordinate2D *locationOfPhoto;

@end
