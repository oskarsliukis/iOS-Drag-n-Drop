//
//  DragAndDropViewController.h
//  Dragndrop
//
//  Created by Oskars Liukis on 4/7/15.
//  Copyright (c) 2015 OL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DragAndDropViewControllerDelegate <NSObject>

- (void)draggingWasSuccesfull:(BOOL)success;

@end

@interface DragAndDropViewController : UIViewController

@property (nonatomic, assign) id <DragAndDropViewControllerDelegate> delegate;

- (void)setupDraggableView:(UIView *)view withRecognizer:(UILongPressGestureRecognizer *)recognizer;
- (void)updateViewPositionFromRecognizer:(UILongPressGestureRecognizer *)recognizer;
- (void)moveViewToInitialPositionCompletion:(void (^)(BOOL finished))completion;
- (void)dismissDraggableViewCompletion:(void (^)(BOOL finished))completion;

@end
