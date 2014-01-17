//
//  ViewController.m
//  StackOverflowFuckfest
//
//  Created by José Luis Canepa on 7/7/13.
//  Copyright (c) 2013 José Luis Canepa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIPinchGestureRecognizer *gesture;
@end

@implementation ViewController

const CGFloat kScaleBoundLower = 0.5;
const CGFloat kScaleBoundUpper = 2.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#warning Set to YES to keep cells fitted inside the collection view while zooming, maintaining the spacing between cells.
    self.fitCells = NO;
    
#warning Set to YES to animate the zooming
    self.animatedZooming = NO;
    
    // Default scale is the average between the lower and upper bound
    self.scale = (kScaleBoundUpper + kScaleBoundLower)/2.0;
    
    // Register a random cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    // Add the pinch to zoom gesture
    self.gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [self.collectionView addGestureRecognizer:self.gesture];
    
}

#pragma mark - Accessors
- (void)setScale:(CGFloat)scale
{
    // Make sure it doesn't go out of bounds
    if (scale < kScaleBoundLower)
    {
        _scale = kScaleBoundLower;
    }
    else if (scale > kScaleBoundUpper)
    {
        _scale = kScaleBoundUpper;
    }
    else
    {
        _scale = scale;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    // Alternate cells between red and blue
    cell.backgroundColor = (indexPath.row % 2) ? [UIColor colorWithRed:0.7 green:0 blue:0 alpha:1.0] : [UIColor colorWithRed:0 green:0 blue:0.7 alpha:1.0];
    
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Main use of the scale property
    CGFloat scaledWidth = 50 * self.scale;
    if (self.fitCells) {
        NSInteger cols = floor(320 / scaledWidth);
        CGFloat totalSpacingSize = 10 * (cols - 1); // 10 is defined in the xib
        CGFloat fittedWidth = (320 - totalSpacingSize) / cols;
        return CGSizeMake(fittedWidth, fittedWidth);
    } else {
        return CGSizeMake(scaledWidth, scaledWidth);
    }
}


#pragma mark - Gesture Recognizers
- (void)didReceivePinchGesture:(UIPinchGestureRecognizer*)gesture
{
    static CGFloat scaleStart;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        // Take an snapshot of the initial scale
        scaleStart = self.scale;
        return;
    }
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // Apply the scale of the gesture to get the new scale
        self.scale = scaleStart * gesture.scale;
        
        if (self.animatedZooming)
        {
            // Animated zooming (remove and re-add the gesture recognizer to prevent updates during the animation)
            [self.collectionView removeGestureRecognizer:self.gesture];
            UICollectionViewFlowLayout *newLayout = [[UICollectionViewFlowLayout alloc] init];
            [self.collectionView setCollectionViewLayout:newLayout animated:YES completion:^(BOOL finished) {
                [self.collectionView addGestureRecognizer:self.gesture];
            }];
        }
        else
        {
            // Invalidate layout
            [self.collectionView.collectionViewLayout invalidateLayout];
        }

}
    
}

@end
