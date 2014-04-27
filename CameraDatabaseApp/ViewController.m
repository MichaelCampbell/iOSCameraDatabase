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

@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UITapGestureRecognizer *tappedBackground;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *savePhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *photoNameTextField;
@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) PhotoDatabase *photoDB;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.savePhotoButton.enabled = NO;
	self.photoNameTextField.delegate = self;
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

- (UITapGestureRecognizer *) tappedBackground
{
	if (!_tappedBackground) {
		_tappedBackground = [[UITapGestureRecognizer alloc] initWithTarget:self
																	action:@selector(didTapBackground:)];
	}
	return _tappedBackground;
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
        _photoDB = [[PhotoDatabase alloc] init];
    }
    return _photoDB;
}

- (IBAction)takePhoto:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)choosePhoto:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (BOOL)isTextFieldReadyForSaving
{
	if ([self.photoNameTextField.text length] > 0) {
		return YES;
	}
	return NO;
}

- (BOOL)isImageReadyForSaving
{
	if (self.photo.imageUrl == nil) {
		return NO;
	}
	return YES;
}

- (IBAction)savePhoto:(UIButton *)sender
{
	if (![self isTextFieldReadyForSaving]) {
		[[[UIAlertView alloc] initWithTitle:@"Uh-oh"
									message:@"Please enter the name of the Photo"
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
		return;
	}

	self.photo.name = self.photoNameTextField.text;

	
    if ([self isImageReadyForSaving]) {
        
        NSString *folderName = @"CameraDatabase App";
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library addAssetURL:self.photo.imageUrl
                     toAlbum:folderName
         withCompletionBlock:^(NSError *error) {
             if (error) {
                 NSLog(@"%@", error);
             }
			 else{
				 BOOL isPhotoSaved = [self.photoDB savePhoto:self.photo];
				 if (!isPhotoSaved) {
					 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh-oh"
																	 message:@"It seems your photo did not save. Please try again"
																	delegate:nil
														   cancelButtonTitle:@"OK"
														   otherButtonTitles:nil];
					 [alert show];
				 }
				 else
				 {
					 [[[UIAlertView alloc] initWithTitle:@"Saved"
												 message:@"Your Photo has been saved"
												delegate:nil
									   cancelButtonTitle:@"OK"
									   otherButtonTitles:nil] show];
					 self.photoNameTextField.text = nil;
					 self.imageView.image = nil;
					 self.photo = nil;
				 }
			 }
         }];
        
    }
	
}

- (void)didTapBackground:(UITapGestureRecognizer *)sender
{
	[self.view endEditing:YES];
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
//        self.photo.visibleRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
        self.photo.dateTaken = [NSDate date];
        
    }

    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.view endEditing:YES];
	return YES;
}

@end
