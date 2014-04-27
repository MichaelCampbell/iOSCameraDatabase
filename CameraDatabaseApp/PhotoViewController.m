//
//  PhotoViewController.m
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/12/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoDatabase.h"
#import "MJCollectionViewCell.h"
#import "PhotoDetailViewController.h"
@import AssetsLibrary;

@interface PhotoViewController ()

@property (nonatomic, strong) PhotoDatabase *photoDB;
@property (nonatomic, strong) NSArray *photoDBPhotos; //array of Photos
													  //@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation PhotoViewController

- (PhotoDatabase *)photoDB
{
	if (!_photoDB) {
		_photoDB = [[PhotoDatabase alloc] init];
	}
	return _photoDB;
}

- (NSArray *)photoDBPhotos
{
	if (!_photoDBPhotos) {
		_photoDBPhotos = [[NSMutableArray alloc] init];
		_photoDBPhotos = [self.photoDB getPhotoCollection];
	}
	return _photoDBPhotos;
}

- (NSMutableArray *)images
{
	if (!_images) {
		_images = [[NSMutableArray alloc] init];
	}
	return _images;
}

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
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;

	[self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.photoDB.getPhotoCollection count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
	Photo *photo = [self.photoDBPhotos objectAtIndex:indexPath.row];
	
	MJCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJCell" forIndexPath:indexPath];
	
	ALAssetsLibrary *assetLib = [[ALAssetsLibrary alloc] init];
	[assetLib assetForURL:photo.imageUrl
			  resultBlock:^(ALAsset *asset) {
				  ALAssetRepresentation *rep = [asset defaultRepresentation];
				  CGImageRef imageRef = [rep fullResolutionImage];
				  if (imageRef) {
					  UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:0.5 orientation:UIImageOrientationUp];
					  cell.image = copyOfOriginalImage;
				  }
			  }
			 failureBlock:^(NSError *error) {
				 NSLog(@"AssetLib is failing");
			 }];
    
    //set offset accordingly
    CGFloat yOffset = ((self.collectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
	
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	Photo *photo = [self.photoDBPhotos objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:@"PhotoDetail" sender:photo];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([sender isKindOfClass:[Photo class]]) {
		Photo *photo = (Photo *) sender;
		
		PhotoDetailViewController *pdvc = (PhotoDetailViewController *)segue.destinationViewController;
		
		pdvc.photoTitle.title = photo.name;
		pdvc.imageURL = photo.imageUrl;
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EE, d LLLL yyyy HH:mm:ss"];
		pdvc.dateTakenText =[NSString stringWithFormat:@"Date Taken: %@",[dateFormatter stringFromDate:photo.dateTaken]];
	}
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(MJCollectionViewCell *view in self.collectionView.visibleCells) {
        CGFloat yOffset = ((self.collectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}

@end
