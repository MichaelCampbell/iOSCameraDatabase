//
//  PhotoViewController.h
//  CameraDatabaseApp
//
//  Created by Michael Campbell on 4/12/14.
//  Copyright (c) 2014 Michael Campbell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray* images;

@end
