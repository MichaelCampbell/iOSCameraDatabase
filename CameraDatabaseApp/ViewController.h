//
//  ViewController.h
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/12/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(UIBarButtonItem *)sender;
- (IBAction)savePhoto:(UIButton *)sender;

@end
