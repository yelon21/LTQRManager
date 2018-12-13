//
//  LTQRScanManager.m
//  Pods
//
//  Created by yelon on 17/2/16.
//
//

#import "LTQRScanManager.h"

@interface LTQRScanManager ()<AVCaptureMetadataOutputObjectsDelegate>

/** 会话对象 */
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
/** 摄像设备 */
@property (nonatomic, strong, readonly) AVCaptureDevice *captureDevice;
/** 输入流 */
@property (nonatomic, strong, readonly) AVCaptureDeviceInput *captureDeviceInput;

/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation LTQRScanManager
@synthesize captureSession = _captureSession;
@synthesize captureDevice = _captureDevice;
@synthesize captureDeviceInput = _captureDeviceInput;

-(void)dealloc{

    [self.previewLayer removeFromSuperlayer];
}

-(instancetype)init{

    if (self = [super init]) {
        
        [self setup];
    }
    return self;
}
//getter
-(AVCaptureSession *)captureSession{
    
    if (!_captureSession) {
        
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

-(AVCaptureDevice *)captureDevice{
    
    if (!_captureDevice) {
        
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([_captureDevice lockForConfiguration:nil]) {
            
            if ([_captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [_captureDevice setFlashMode:AVCaptureFlashModeAuto];
            }
            if ([_captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                
                [_captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            if ([_captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
                [_captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
            }
            
            if ([_captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                CGPoint exposurePoint = CGPointMake(0.5f, 0.5f); // 曝光点为中心
                [_captureDevice setExposurePointOfInterest:exposurePoint];
                [_captureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            [_captureDevice unlockForConfiguration];
        }
    }
    return _captureDevice;
}

-(AVCaptureDeviceInput *)captureDeviceInput{
    
    if (!_captureDeviceInput) {
        NSError *error = nil;
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
        NSLog(@"error=%@",error);
    }
    return _captureDeviceInput;
}

- (void)setup{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleStatusBarOrientationDidChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];

    // 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    
    // 3、创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 5、初始化链接对象（会话对象）
    // 高质量采集率
    //session.sessionPreset = AVCaptureSessionPreset1920x1080; // 如果二维码图片过小、或者模糊请使用这句代码，注释下面那句代码
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 5.1 添加会话输入
    [self.captureSession addInput:self.captureDeviceInput];
    
    // 5.2 添加会话输出
    [self.captureSession addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    NSMutableArray *metadataObjectTypes = [[NSMutableArray alloc]init];
    
    [metadataObjectTypes addObject:AVMetadataObjectTypeQRCode];
    
    [metadataObjectTypes addObject:AVMetadataObjectTypeEAN13Code];
    [metadataObjectTypes addObject:AVMetadataObjectTypeEAN8Code];
    [metadataObjectTypes addObject:AVMetadataObjectTypeCode128Code];
    
    [metadataObjectTypes addObject:AVMetadataObjectTypeUPCECode];
    [metadataObjectTypes addObject:AVMetadataObjectTypeCode39Code];
    [metadataObjectTypes addObject:AVMetadataObjectTypeCode39Mod43Code];
    
    [metadataObjectTypes addObject:AVMetadataObjectTypePDF417Code];
    [metadataObjectTypes addObject:AVMetadataObjectTypeAztecCode];
    [metadataObjectTypes addObject:AVMetadataObjectTypeCode39Mod43Code];
    
    if (@available(iOS 8.0, *)) {
        
        [metadataObjectTypes addObject:AVMetadataObjectTypeInterleaved2of5Code];
        [metadataObjectTypes addObject:AVMetadataObjectTypeITF14Code];
        [metadataObjectTypes addObject:AVMetadataObjectTypeDataMatrixCode];
    }
    
    output.metadataObjectTypes = metadataObjectTypes;
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationUnknown:{
            return AVCaptureVideoOrientationPortrait;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
    }
}

+ (id)LT_ShowInView:(UIView *)view{

    if (!view || ![view isKindOfClass:[UIView class]]) {
        
        return nil;
    }
    
    LTQRScanManager *manager = [[LTQRScanManager alloc]init];
    
    [manager lt_ShowInView:view];
    
    return manager;
}

- (void)lt_ShowInView:(UIView *)view{
    
    if (!view || ![view isKindOfClass:[UIView class]]) {
        
        return;
    }
    
    self.layerFrame = view.layer.bounds;
    
    [view.layer insertSublayer:self.previewLayer atIndex:0];
}

-(BOOL)isScanning{

    return self.captureSession.isRunning;
}

- (void)lt_startRunning{

    if (!self.captureSession.isRunning) {
        
        [self.captureSession startRunning];
    }
}

- (void)lt_stopRunning{

    if (self.captureSession.isRunning) {
        
        [self.captureSession stopRunning];
    }
}
//
-(CGRect)layerFrame{

    return self.previewLayer.frame;
}

-(void)setLayerFrame:(CGRect)layerFrame{

    self.previewLayer.frame = layerFrame;
    self.previewLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
}

- (void)handleStatusBarOrientationDidChange:(NSNotification *)notification{
    //1.获取 当前设备 实例
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CALayer *superLayer = self.previewLayer.superlayer;
    
    if (superLayer) {
        
        self.layerFrame = superLayer.bounds;
    }
//    switch (orientation) {
//            
//        case UIInterfaceOrientationPortrait:
//        case UIInterfaceOrientationPortraitUpsideDown:
//        case UIInterfaceOrientationLandscapeLeft:
//        case UIInterfaceOrientationLandscapeRight:
//        case UIInterfaceOrientationUnknown:
//            break;
//        default:
//            NSLog(@"无法辨识");
//            break;
//    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection{
    
    if (self.BlockDidDecodeResult) {
        
        if (metadataObjects.count > 0) {
            
            AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
            
            NSLog(@"metadataObjects = %@", metadataObjects);
            
            self.BlockDidDecodeResult(self,obj.stringValue);
        }
    }
}

-(BOOL)isTorchActive{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return device.isTorchActive;
}

-(BOOL)hasTorch{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return device.hasTorch;
}

-(void)lt_turnOnTorch:(BOOL)on{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!device.hasTorch) {
        
        return;
    }
    
    if ([device lockForConfiguration:nil]) {
        
        if (on) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode: AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

#pragma mark check
+ (void)LT_CheckCameraAccess:(void (^)(BOOL granted))handler{
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                             completionHandler:handler];
}
@end
