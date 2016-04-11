//
//  CollectionViewCell.h
//  Dragndrop
//
//  Created by Oskars Liukis on 4/7/15.
//  Copyright (c) 2015 OL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DraggableCollectionViewCell;

@protocol CollectionViewCellDelegate <NSObject>

- (void)cell:(DraggableCollectionViewCell *)cell didLongPress:(UILongPressGestureRecognizer *)recognizer;
- (void)cell:(DraggableCollectionViewCell *)cell didDrag:(UILongPressGestureRecognizer *)recognizer;
- (void)cell:(DraggableCollectionViewCell *)cell didEndDrag:(UILongPressGestureRecognizer *)recognizer;

@end

@interface DraggableCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id <CollectionViewCellDelegate> delegate;

@end
