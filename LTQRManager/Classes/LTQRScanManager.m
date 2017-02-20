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
@property (nonatomic, strong) AVCaptureSession *session;
/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation LTQRScanManager

-(void)dealloc{

    [self.previewLayer removeFromSuperlayer];
}

-(instancetype)init{

    if (self = [super init]) {
        
        [self setup];
    }
    return self;
}

- (void)setup{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleStatusBarOrientationDidChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil
     ];

    self.session = [[AVCaptureSession alloc] init];
    // 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    // 2、创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 5、初始化链接对象（会话对象）
    // 高质量采集率
    //session.sessionPreset = AVCaptureSessionPreset1920x1080; // 如果二维码图片过小、或者模糊请使用这句代码，注释下面那句代码
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 5.1 添加会话输入
    [self.session addInput:input];
    
    // 5.2 添加会话输出
    [self.session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

}

- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationPortrait: {
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

    return self.session.isRunning;
}

- (void)lt_startRunning{

    if (!self.session.isRunning) {
        
        [self.session startRunning];
    }
}

- (void)lt_stopRunning{

    if (self.session.isRunning) {
        
        [self.session stopRunning];
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
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
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
    
    [device lockForConfiguration:nil];
    if (on) {
        [device setTorchMode:AVCaptureTorchModeOn];
    } else {
        [device setTorchMode: AVCaptureTorchModeOff];
    }
    [device unlockForConfiguration];
}
@end
