
#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)x {
  return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (CGFloat)y {
  return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
  CGPoint center = self.center;
  center.x = centerX;
  self.center = center;
}

- (CGFloat)centerX {
  return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
  CGPoint center = self.center;
  center.y = centerY;
  self.center = center;
}

- (CGFloat)centerY {
  return self.center.y;
}

- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)width {
  return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

- (CGFloat)height {
  return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}

- (CGSize)size {
  return self.frame.size;
}

//- (void)myShadowView {
//  self.layer.borderColor = [[UIColor clearColor] CGColor];
//  self.backgroundColor = [UIColor whiteColor];
//  self.layer.cornerRadius = zRadiusCorner;
//  
//  UIBezierPath *shadowPath = [UIBezierPath
//      bezierPathWithRect:CGRectMake(0, self.height - 1, self.width, 1)];
//  self.layer.masksToBounds = NO;
//  self.layer.shadowColor = [UIColor blackColor].CGColor;
//  self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//  self.layer.shadowOpacity = 0.5f;
//  self.layer.shadowPath = shadowPath.CGPath;
//}

@end
