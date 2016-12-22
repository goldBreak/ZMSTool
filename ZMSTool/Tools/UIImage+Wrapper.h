//
//  UIImage+Wrapper.h
//  
//
//  Created by wwwwwww on 15/12/30.
//  Copyright © 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Wrapper)

/**
 *  加载图片资源
 *  加载一些常用并且图片比较小的资源时，请用imageName方法
 *  对于项目中只用到一次并较大的图片，请务必使用imageWithBigImage方法，以减少内存开销
 *
 *  @param name 图片的名称
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithBigImage:(NSString *)name;

/**
 *  根据颜色和大小绘制图片
 *
 *  @param color  颜色
 *  @param aFrame 大小
 *
 *  @return 图片
 */
+ (UIImage *)ImageWithColor:(UIColor *)color frame:(CGRect)aFrame;


- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
@end
