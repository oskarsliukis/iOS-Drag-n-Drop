//
//  CollectionViewCell.m
//  Dragndrop
//
//  Created by Oskars Liukis on 4/7/15.
//  Copyright (c) 2015 OL. All rights reserved.
//

#import "DraggableCollectionViewCell.h"

@interface DraggableCollectionViewCell ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;

@end

@implementation DraggableCollectionViewCell

- (void)awakeFromNib {
    self.longPressRecognizer.enabled = YES;
    self.layer.cornerRadius = self.frame.size.width / 2;
}

#pragma mark - Private

- (UILongPressGestureRecognizer *)longPressRecognizer {
    if (!_longPressRecognizer) {
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
        _longPressRecognizer.minimumPressDuration = .3;
        [self addGestureRecognizer:_longPressRecognizer];
    }
    return _longPressRecognizer;
}

- (void)didLongPress:(UILongPressGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.delegate cell:self didLongPress:recognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self.delegate cell:self didDrag:recognizer];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self.delegate cell:self didEndDrag:recognizer];
            break;
        default:
            break;
    }
}

@end
