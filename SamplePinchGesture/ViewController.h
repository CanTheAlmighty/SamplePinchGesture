//
//  ViewController.h
//  StackOverflowFuckfest
//
//  Created by José Luis Canepa on 7/7/13.
//  Copyright (c) 2013 José Luis Canepa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// IBOutlets
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic,assign) CGFloat scale;

@end
