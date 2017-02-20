//
//  LYViewController.m
//  LTQRManager
//
//  Created by 254956982@qq.com on 02/15/2017.
//  Copyright (c) 2017 254956982@qq.com. All rights reserved.
//

#import "LYViewController.h"
#import "UIImage+LTQR.h"
#import "LTQRScanManager.h"
#import "LTScanCoverView.h"

@interface LYViewController (){

    
}

@property (weak, nonatomic) IBOutlet UITextField *TF;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) LTQRScanManager *scanManager;
@property (weak, nonatomic) IBOutlet LTScanCoverView *maskView;

@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.scanManager lt_startRunning];
    [self.maskView lt_startRunning];
}

-(LTQRScanManager *)scanManager{

    if (!_scanManager) {
        
        _scanManager = [LTQRScanManager LT_ShowInView:self.view];
        __weak typeof(self)weakSelf = self;
        [_scanManager setBlockDidDecodeResult:^(LTQRScanManager *manager, NSString *result) {
            
            [manager lt_stopRunning];
            [weakSelf.maskView lt_stopRunning];
            weakSelf.TF.text = result;
        }];
    }
    return _scanManager;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{

    [self startScan];
}

- (void)startScan{
    
    if (self.scanManager.isScanning) {
        
        [self.scanManager lt_stopRunning];
        [self.maskView lt_stopRunning];
    }
    else{
    
        [self.scanManager lt_startRunning];
        [self.maskView lt_startRunning];
    }
}

- (IBAction)truchAction:(id)sender {
    
    [self.scanManager lt_turnOnTorch:!self.scanManager.isTorchActive];
}


-(void)getQRImage{

    CGFloat width = [self.TF.text doubleValue];
    
    if (width < 50.0) {
        width = 50.0;
    }
    UIImage *imageData = [UIImage LT_QRImageWithContentString:@"开啥玩笑啊"
                                                  defaultSize:width];
    
    self.image.image = imageData;
    
    
    NSData *data = UIImageJPEGRepresentation(imageData, 1.0);
    UIImage *imageI = [UIImage imageWithData:data];
    NSString *content = [imageData lt_qrContentFromQRImage];
    NSLog(@"content=%@",content);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
