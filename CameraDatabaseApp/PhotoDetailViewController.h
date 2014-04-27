//
//  PhotoDetailViewController.h
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/26/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) IBOutlet UINavigationItem *photoTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *dateTakenLabel;
@property (strong, nonatomic) NSString *dateTakenText;

@end
