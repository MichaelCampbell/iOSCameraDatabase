//
//  ViewController.m
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/12/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "PhotoDatabase.h"
@import AssetsLibrary;
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *savePhotoButton;
@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) PhotoDatabase *photoDB;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.savePhotoButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkForCamera];
}

- (void)checkForCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.takePhotoButton = [[UIBarButtonItem alloc] initWithTitle:@"Choose"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(choosePhoto:)];
        [self.navigationItem setRightBarButtonItem:self.takePhotoButton
                                          animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Photo *)photo
{
    if (!_photo) {
        _photo = [[Photo alloc] init];
    }
    return _photo;
}

- (PhotoDatabase *)photoDB
{
    if (!_photoDB) {
        _photoDB = [PhotoDatabase sharedDBInstance];
    }
    return _photoDB;
}

- (IBAction)takePhoto:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)choosePhoto:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)savePhoto:(UIButton *)sender
{
    if (self.photo.imageUrl) {
        
        NSString *folderName = @"CameraDatabase App";
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library addAssetURL:self.photo.imageUrl
                     toAlbum:folderName
         withCompletionBlock:^(NSError *error) {
             if (error) {
                 NSLog(@"%@", error);
             }
         }];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera
        ||picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!chosenImage) {
            chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        self.imageView.image = chosenImage;
        self.savePhotoButton.enabled = YES;
        self.photo.photoDictionary = [info mutableCopy];
        self.photo.imageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        self.photo.visibleRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
        self.photo.dateTaken = [NSDate date];
        
    }

    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
    
}

@end
