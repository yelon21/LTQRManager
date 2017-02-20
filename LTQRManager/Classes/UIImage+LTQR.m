//
//  UIImage+LTQR.m
//  Pods
//
//  Created by yelon on 17/2/16.
//
//

#import "UIImage+LTQR.h"



@implementation UIImage (LTQR)

/**
 根据内容生成二维码

 @param content 内容
 @param width 图片宽度
 @return 二维码图片
 */
+ (UIImage *)LT_QRImageWithContentString:(NSString *)content
                             defaultSize:(CGFloat)width{

    return [UIImage LT_QRImageWithContentString:content
                                    defaultSize:width
                                foregroundColor:[CIColor colorWithRed:0 green:0 blue:0 alpha:1]
                                backgroundColor:[CIColor colorWithRed:1 green:1 blue:1 alpha:0.01]];
}

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
                         backgroundColor:(CIColor*)iBackgroundColor{

    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    content = [NSString stringWithFormat:@"%@",content];

    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置滤镜inputMessage数据
    [filter setValue:contentData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    CIFilter *filterColor = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",outputImage,
                             @"inputColor0",iForegroundColor,
                             @"inputColor1",iBackgroundColor, nil];
    
    return [UIImage LT_ImageFormCIImage:[filterColor outputImage] defaultSize:width];
}

+ (UIImage *)LT_ImageFormCIImage:(CIImage *)image
                     defaultSize:(CGFloat)defaultWidth{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat extentH = CGRectGetHeight(extent);
    CGFloat extentW = CGRectGetWidth(extent);
    
    if (extentH<=0.0||extentW<=0.0) {
        
        return nil;
    }
    CGFloat scale = MIN(defaultWidth/extentW, defaultWidth/extentH);
    
    //创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image
                                           fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    //保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 根据二维码图片获取内容

 @return 二维码内容
 */
- (NSString *)lt_qrContentFromQRImage{

    if (self == nil) {
        
        return nil;
    }
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
    
        return [self lt_qrContentFromQRImageByZXing];
    }
    else{
    
        return [self lt_qrContentFromQRImageBySystem];
    }
}

- (NSString *)lt_qrContentFromQRImageBySystem{
    
    if (self == nil) {
        
        return nil;
    }
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:self.CGImage]];
    
    NSLog(@"扫描结果 － － %@", features);
    
    for (CIQRCodeFeature *feature in features) {
        
        NSString *scannedResult = feature.messageString;
        NSLog(@"result:%@",scannedResult);
    }
    
    for (CIQRCodeFeature *feature in features) {
        
        NSString *scannedResult = feature.messageString;
        NSLog(@"result:%@",scannedResult);
        return scannedResult;
    }
    
    return nil;
}



- (NSString *)lt_qrContentFromQRImageByZXing{

    if (self == nil) {
        
        return nil;
    }
    
    CGImageRef imageToDecode = self.CGImage;  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    
    if (result) {

        NSString *contents = result.text;
        
        return contents;
    } else {
        
        NSLog(@"error=%@",error);
    }
    return nil;
}
@end
