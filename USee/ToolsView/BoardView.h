//
//  BoardView.h
//  LOSBi
//
//  Created by JJT on 16/9/1.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "BaseView.h"
#import "Line.h"

@interface BoardView : UIView {
    BOOL isCleared;
}

@property (nonatomic) Line *currentLine;
@property (nonatomic) NSMutableArray *linesCompleted;
@property (nonatomic) UIColor *drawColor;

- (void)undo;
- (void)redo;
@end
