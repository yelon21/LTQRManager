//
//  LTScanCoverView.m
//  Pods
//
//  Created by yelon on 17/2/17.
//
//

#import "LTScanCoverView.h"
#import <AVFoundation/AVFoundation.h>

@interface LTScanCoverView ()

@property(nonatomic,assign) BOOL isRunning;

@property(nonatomic,strong) CALayer *baseLayer;
@property(nonatomic,strong) CAShapeLayer *maskLayer;
@property(nonatomic,strong) CAShapeLayer *rectLayer;
@property(nonatomic,strong) UILabel *textLabel;

@property(nonatomic,strong) UIImageView *lineView;
@end

@implementation LTScanCoverView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{

    [super awakeFromNib];
    
    [self setup];
}

-(void)layoutSubviews{

    [self updatePath];
}

-(UILabel *)textLabel{

    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"请将二维码/条形码放入框内";
        [self addSubview:_textLabel];
    }
    
    return _textLabel;
}

-(UIImageView *)lineView{

    if (!_lineView) {
        
        _lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LTQRScanLine.png"]];
        _lineView.contentMode = UIViewContentModeScaleToFill;
    }
    return _lineView;
}
#pragma mark setup
- (void)setup{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.baseLayer = [CALayer layer];
    self.baseLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35].CGColor;
   
    [self.layer addSublayer:self.baseLayer];
    
    self.maskLayer = [CAShapeLayer layer];
    
    self.baseLayer.mask = self.maskLayer;
    
    self.rectLayer = [CAShapeLayer layer];
    
    self.rectLayer.strokeColor = [UIColor colorWithRed:27.0/255.0
                                                 green:183.0/255.0
                                                  blue:35.0/255.0
                                                 alpha:1.0].CGColor;
    self.rectLayer.lineWidth = 4.0;
    self.rectLayer.fillColor = nil;
    
    [self.layer addSublayer:self.rectLayer];

    [self updatePath];
}

- (void)updatePath{

    self.baseLayer.frame = self.bounds;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat maskWidth = MIN(width, height)/10.0*6.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat boundsLength = 0.0;
    
    [path moveToPoint:CGPointMake(boundsLength, boundsLength)];
    [path addLineToPoint:CGPointMake(width-boundsLength, boundsLength)];
    [path addLineToPoint:CGPointMake(width-boundsLength, height-boundsLength)];
    [path addLineToPoint:CGPointMake(boundsLength, height-boundsLength)];
    
    [path addLineToPoint:CGPointMake(boundsLength, boundsLength)];
    
    CGFloat deltY = -30.0;
    
    CGFloat deltW = (width-maskWidth)/2.0;
    CGFloat deltH = (height-maskWidth)/2.0;
  
    [path moveToPoint:CGPointMake(boundsLength+deltW, boundsLength+deltH+deltY)];
    [path addLineToPoint:CGPointMake(boundsLength+deltW, height-boundsLength-deltH+deltY)];
    [path addLineToPoint:CGPointMake(width-boundsLength-deltW, height-boundsLength-deltH+deltY)];
    [path addLineToPoint:CGPointMake(width-boundsLength-deltW, boundsLength+deltH+deltY)];
    [path addLineToPoint:CGPointMake(boundsLength+deltW, boundsLength+deltH+deltY)];

    self.maskLayer.path = path.CGPath;
    
    CGRect textFrame = CGRectMake(boundsLength+deltW,
                                  height-boundsLength-deltH+deltY+20.0,
                                  maskWidth,
                                  20.0);
    self.textLabel.frame = textFrame;
    
    CGRect rectFrame = CGRectMake(boundsLength+deltW,
                                  boundsLength+deltH+deltY,
                                  maskWidth,
                                  maskWidth);
    self.rectLayer.frame = rectFrame;
    [self updateRectLayerContent];
    
    self.lineView.layer.frame = CGRectMake(0.0, -6, maskWidth, 12.0);
    [self updateScanLineAnimation];
}

- (void)updateRectLayerContent{

    CGFloat maskWidth = CGRectGetWidth(self.rectLayer.bounds);
    
    CGFloat lineLength = 40.0;
    
    UIBezierPath *rectPath = [UIBezierPath bezierPath];
    //左上角
    [rectPath moveToPoint:CGPointMake(0.0, lineLength)];
    [rectPath addLineToPoint:CGPointMake(0.0, 0.0)];
    [rectPath addLineToPoint:CGPointMake(lineLength, 0.0)];
    
    //右上角
    [rectPath moveToPoint:CGPointMake(maskWidth-lineLength, 0.0)];
    [rectPath addLineToPoint:CGPointMake(maskWidth, 0.0)];
    [rectPath addLineToPoint:CGPointMake(maskWidth, lineLength)];
    
    //右下角
    [rectPath moveToPoint:CGPointMake(maskWidth, maskWidth-lineLength)];
    [rectPath addLineToPoint:CGPointMake(maskWidth, maskWidth)];
    [rectPath addLineToPoint:CGPointMake(maskWidth-lineLength, maskWidth)];
    
    //左下角
    [rectPath moveToPoint:CGPointMake(lineLength, maskWidth)];
    [rectPath addLineToPoint:CGPointMake(0.0, maskWidth)];
    [rectPath addLineToPoint:CGPointMake(0.0, maskWidth-lineLength)];
    
    self.rectLayer.path = rectPath.CGPath;
}

- (void)updateScanLineAnimation{
    
    CALayer *lineSuperLayer = self.lineView.layer;
    if (!lineSuperLayer) {
        
        return;
    }
    [self.lineView.layer removeAllAnimations];
    
    CGFloat maskWidth = CGRectGetWidth(lineSuperLayer.bounds);
    
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform"];
    translation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0, -6.0, 0.0)];
    translation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0, maskWidth-6.0, 0.0)];
    translation.duration = 2;
    translation.repeatCount = HUGE_VALF;
    translation.autoreverses = NO;
    
    [self.lineView.layer addAnimation:translation forKey:@"LT_SCAN"];
}

#pragma mark function
//开始扫描
- (void)lt_startRunning{

    if (!self.isRunning) {
        
        self.isRunning = YES;
        
        [self.rectLayer addSublayer:self.lineView.layer];
        [self updateScanLineAnimation];
    }
}
//停止扫描
- (void)lt_stopRunning{

    if (self.isRunning) {
        
        self.isRunning = NO;
        
        [self.lineView.layer removeAllAnimations];
        [self.lineView.layer removeFromSuperlayer];
    }
}

@end
