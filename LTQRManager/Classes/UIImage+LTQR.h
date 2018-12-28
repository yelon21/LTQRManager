//
//  UIImage+LTQR.h
//  Pods
//
//  Created by yelon on 17/2/16.
//
//

#import <UIKit/UIKit.h>

#import "ZXBinaryBitmap.h"
#import "ZXCGImageLuminanceSource.h"
#import "ZXHybridBinarizer.h"
#import "ZXDecodeHints.h"
#import "ZXMultiFormatReader.h"
#import "ZXResult.h"

@interface UIImage (LTQR)

/**
 根据内容生成二维码
 
 @param content 内容
 @param width 图片宽度
 @return 二维码图片
 */
+ (UIImage *)LT_QRImageWithContentString:(NSString *)content
                             defaultSize:(CGFloat)width;
/**
 生成二维码
 
 @param content 二维码内容
 @param width 二维码图片边长
 @param iForegroundColor 前景色
 @param iBackgroundColor 背景色
 @return 二维码图片
 */
+ (UIImage *)LT_QRImageWithContentString:(NSString *)content
                             defaultSize:(CGFloat)width
                         foregroundColor:(CIColor*)iForegroundColor
                         backgroundColor:(CIColor*)iBackgroundColor;
/**
 根据二维码图片获取内容
 
 @return 二维码内容
 */
- (NSString *)lt_qrContentFromQRImage;
@end
