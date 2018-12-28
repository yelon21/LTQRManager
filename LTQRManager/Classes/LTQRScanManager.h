//
//  LTQRScanManager.h
//  Pods
//
//  Created by yelon on 17/2/16.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//实例化前要判断相机是否可用
@interface LTQRScanManager : NSObject

@property(nonatomic,assign) CGRect layerFrame;//摄像头内容
@property (nonatomic, strong,readonly) AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic,strong) void (^BlockDidDecodeResult)(LTQRScanManager *manager,NSString *resultString);



+ (id)LT_ShowInView:(UIView *)view cameraNotAvailableBlock:(dispatch_block_t)cameraNotAvailable;

@property(nonatomic,assign,readonly) BOOL isScanning;//正在扫描
//开始扫描
- (void)lt_startRunning;
//停止扫描
- (void)lt_stopRunning;

@property(nonatomic, readonly) BOOL hasTorch;
@property(nonatomic, readonly, getter=isTorchActive) BOOL torchActive;

- (void)lt_turnOnTorch:(BOOL)on;
#pragma mark check
+ (void)LT_CheckCameraAccess:(void (^)(BOOL granted))handler;
@end
