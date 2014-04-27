//
//  PhotoDetailViewController.m
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/26/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

#import "PhotoDetailViewController.h"
@import AssetsLibrary;

@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *NavBar;

@end

@implementation PhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.navigationController.navigationBar.topItem.title = @"Photos";
	self.dateTakenLabel.text = self.dateTakenText;
	
	if (self.imageURL) {
		ALAssetsLibrary *assetLib = [[ALAssetsLibrary alloc] init];
		[assetLib assetForURL:self.imageURL
				  resultBlock:^(ALAsset *asset) {
					  ALAssetRepresentation *rep = [asset defaultRepresentation];
					  CGImageRef imageRef = [rep fullResolutionImage];
					  if (imageRef) {
						  UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:0.5 orientation:UIImageOrientationUp];
						  self.imageView.image = copyOfOriginalImage;
					  }
				  }
				 failureBlock:^(NSError *error) {
					 NSLog(@"AssetLib is failing");
				 }];
		
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
