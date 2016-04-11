//
//  CollectionViewController.m
//  Dragndrop
//
//  Created by Oskars Liukis on 4/7/15.
//  Copyright (c) 2015 OL. All rights reserved.
//

#import "DraggableCollectionViewController.h"
#import "DraggableCollectionViewCell.h"
#import "DragAndDropViewController.h"

@interface DraggableCollectionViewController () <CollectionViewCellDelegate, DragAndDropViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) DragAndDropViewController *dragAndDropViewController;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DraggableCollectionViewController

static NSString * const reuseIdentifier = @"DraggableCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - Private

- (void)startDragAndDropWithRecognizer:(UILongPressGestureRecognizer *)recognizer fromCell:(DraggableCollectionViewCell *)cell  {
    if (!self.dragAndDropViewController) {
        self.dragAndDropViewController = [DragAndDropViewController new];
        self.dragAndDropViewController.view.frame = self.view.bounds;
        self.dragAndDropViewController.delegate = self;
        [self.view addSubview:self.dragAndDropViewController.view];
        [self.dragAndDropViewController setupDraggableView:cell withRecognizer:recognizer];
    }
}

- (void)stopDragging {
    [self.dragAndDropViewController moveViewToInitialPositionCompletion:^(BOOL finished) {
        [self.collectionView reloadData];
        [self.dragAndDropViewController dismissDraggableViewCompletion:^(BOOL finished) {
            self.dragAndDropViewController = nil;
        }];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DraggableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.alpha = 1;
    return cell;
}

#pragma mark - CollectionViewCellDelegate

- (void)cell:(DraggableCollectionViewCell *)cell didLongPress:(UILongPressGestureRecognizer *)recognizer {
    [self startDragAndDropWithRecognizer:recognizer fromCell:cell];
}

- (void)cell:(DraggableCollectionViewCell *)cell didDrag:(UILongPressGestureRecognizer *)recognizer {
    [self.dragAndDropViewController updateViewPositionFromRecognizer:recognizer];
}

- (void)cell:(DraggableCollectionViewCell *)cell didEndDrag:(UILongPressGestureRecognizer *)recognizer {
    [self stopDragging];
}

#pragma mark - DragAndDropViewControllerDelegate

- (void)draggingWasSuccesfull:(BOOL)success {
    if (success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
