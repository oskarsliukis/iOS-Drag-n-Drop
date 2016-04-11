//
//  DragAndDropViewController.m
//  Dragndrop
//
//  Created by Oskars Liukis on 4/7/15.
//  Copyright (c) 2015 OL. All rights reserved.
//

#import "DragAndDropViewController.h"
#import "UIImage+Snapshot.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@interface DragAndDropViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *draggableView;
@property (nonatomic, assign) CGPoint draggingOffest;
@property (nonatomic, assign) CGPoint initialDraggableViewCenter;
@property (nonatomic, assign) CGFloat initialDistanceFromCenter;

@property (weak, nonatomic) IBOutlet UIView *completionArea;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@end

@implementation DragAndDropViewController

- (void)setupDraggableView:(UIView *)view withRecognizer:(UILongPressGestureRecognizer *)recognizer {
    self.overlayView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageFromView:view]];
    imageView.frame = view.frame;
    self.draggableView = imageView;
    
    self.draggableView.center = [view.superview convertPoint:view.center toView:nil];
    CGPoint startLocation = [recognizer locationInView:nil];
    self.draggingOffest = CGPointMake(self.draggableView.center.x - startLocation.x, self.draggableView.center.y - startLocation.y);
    self.initialDraggableViewCenter = self.draggableView.center;
    self.initialDistanceFromCenter = [self distanceBetweenPoint:self.view.center andPoint:self.draggableView.center];
    [self.view addSubview:self.draggableView];
    
    self.draggableView.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        view.alpha = 0;
        self.draggableView.alpha = 1;
        self.overlayView.alpha = .5;
    }];
    
    [self shakeDraggableView];
}

- (void)moveViewToInitialPositionCompletion:(void (^)(BOOL))completion {
    [self checkIfDraggingIsCompleted];
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.draggableView.center = self.initialDraggableViewCenter;
        self.overlayView.alpha = 0;
        self.draggableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

- (void)dismissDraggableViewCompletion:(void (^)(BOOL))completion {
    [UIView animateWithDuration:.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        completion(finished);
    }];
}

- (void)updateViewPositionFromRecognizer:(UILongPressGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    
    location.x += self.draggingOffest.x;
    location.y += self.draggingOffest.y;
    
    CGFloat distance = [self distanceBetweenPoint:self.view.center andPoint:location];
    
    CGFloat coefficient = distance / self.initialDistanceFromCenter;
    coefficient += .4;
    if (coefficient < 1) {
        self.draggableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, coefficient, coefficient);
    }
    self.draggableView.center = location;
    
    [self checkForCompletion];
}

#pragma mark - Private

- (void)shakeDraggableView {
    self.draggableView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-1));
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^ {
                         self.draggableView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(1));
                         
                     }
                     completion:NULL
     ];
}

- (BOOL)checkForCompletion {
    
    BOOL overlaps = CGRectIntersectsRect(self.completionArea.frame, self.draggableView.frame);
    
    /*
     // Center check
     overlaps = NO;
     if (abs(self.completionArea.center.x - self.draggableView.center.x) < 20 &&
     abs(self.completionArea.center.y - self.draggableView.center.y) < 20) {
     overlaps = YES;
     }
     */
    
    if (overlaps) {
        [UIView animateWithDuration:.3 animations:^{
            self.completionArea.backgroundColor = [UIColor redColor];
        }];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            self.completionArea.backgroundColor = [UIColor clearColor];
        }];
    }
    return overlaps;
}

- (void)checkIfDraggingIsCompleted {
    [self.delegate draggingWasSuccesfull:[self checkForCompletion]];
}

- (CGFloat)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

@end
