//
//  JKSideSlipView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//
#define SLIP_WIDTH 250

#import "JKSideSlipView.h"
#import <Accelerate/Accelerate.h>

@implementation JKSideSlipView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSAssert(nil, @"please init with -initWithSender:sender");
    }
    return self;
    
}
- (instancetype)initWithSender:(UIViewController*)sender
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake(-SLIP_WIDTH, 0, SLIP_WIDTH, bounds.size.height);
    self = [super initWithFrame:frame];
    if (self)
    {
        [self buildViews:sender];
    }
    return self;
}
-(void)buildViews:(UIViewController*)sender
{
    _sender = sender;
    _sender.view.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:1];
    
    _rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
   [_sender.view addGestureRecognizer:_rightSwipe];
    
    
    _blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SLIP_WIDTH, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _blurImageView.userInteractionEnabled = NO;
    _blurImageView.alpha = 0;
    _blurImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_blurImageView];
}

-(void)setContentView:(UIView*)contentView
{
    if (contentView)
    {
        _contentView = contentView;

    }
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_contentView];

}
-(void)show:(BOOL)show
{
    UIImage *image =  [self imageFromView:_sender.view];
    if (!isOpen)
    {
        _blurImageView.alpha = 1;
    }
    CGFloat x = show?0:-SLIP_WIDTH;
    [UIView animateWithDuration:0.3 animations:^
    {
        self.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
        if(!isOpen)
        {
            _blurImageView.image = image;
            _blurImageView.image= [self blurryImage:_blurImageView.image withBlurLevel:0.2];
        }
    }
     completion:^(BOOL finished)
    {
        isOpen = show;
        if(!isOpen)
        {
            _blurImageView.alpha = 0;
            _blurImageView.image = nil;
        }

    }];
    
}
#pragma mark - 行为收敛控制
- (void)disableTapButton
{
    for (UIButton *tempButton in [_sender.view subviews])
    {
        [tempButton setUserInteractionEnabled:NO];
    }
    //单击
    if (!self.tap)
    {
        //单击手势
        self.tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self.tap setNumberOfTapsRequired:1];
        
        [_sender.view addGestureRecognizer:self.tap];
        self.tap.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
    }
}

//关闭行为收敛
- (void) removeSingleTap
{
    for (UIButton *tempButton in [_sender.view  subviews])
    {
        [tempButton setUserInteractionEnabled:YES];
    }
    [_sender.view removeGestureRecognizer:self.tap];
    self.tap = nil;
}


-(void)switchMenu
{
    if (_leftSwipe == nil)
    {
        _leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [_sender.view addGestureRecognizer:_leftSwipe];
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_sender.view addGestureRecognizer:_tap];
    }
    else
    {
        _leftSwipe.enabled = YES;
        _tap.enabled = YES;
    }
    
    [self show:!isOpen];
}
-(void)show
{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"StarBtnDefaultShow" object:nil userInfo:nil];
    
    if (_leftSwipe == nil)
    {
        _leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [_sender.view addGestureRecognizer:_leftSwipe];
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_sender.view addGestureRecognizer:_tap];
    }
    else
    {
        _leftSwipe.enabled = YES;
        _tap.enabled = YES;
    }

    [self show:YES];

    [self disableTapButton];
}

-(void)hide
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StarBtnDefaultHide" object:nil userInfo:nil];
    
    _leftSwipe.enabled = NO;
    _tap.enabled = NO;
    [self show:NO];
    
    [self removeSingleTap];
}


#pragma mark - shot
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - Blur
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    if ((blur < 0.0f) || (blur > 1.0f))
    {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end