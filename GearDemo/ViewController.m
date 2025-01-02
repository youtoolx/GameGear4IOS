//
//  ViewController.m
//  demo
//
//  Created by xzs on 2024/12/30.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "GearSdk/GearSDK.h"

@interface ViewController ()
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *speedIndexLabel;
@property (nonatomic, strong) UISlider *seekBar;
@property (nonatomic, strong) UIButton *controlButton;
@property (nonatomic, strong) UIButton *showViewButton;
@property (nonatomic, strong) UIButton *hideViewButton;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, assign) int speedIndexUp;
@property (nonatomic, assign) int speedIndexDown;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int frameWidth = self.view.frame.size.width;
    int frameHeight = self.view.frame.size.height;
    int height = 40;
    int padding = 30;
    
    self.hideViewButton = [self createButtonWithTitle:@"隐藏悬浮球" action:@selector(hideTap:) yPosition:frameHeight - padding - height];
    self.showViewButton = [self createButtonWithTitle:@"显示悬浮球" action:@selector(showTap:) yPosition:CGRectGetMinY(self.hideViewButton.frame) - padding - height];
    self.controlButton = [self createButtonWithTitle:@"开启加速" action:@selector(controlTap:) yPosition:CGRectGetMinY(self.showViewButton.frame) - padding - height];
    
    self.seekBar = [[UISlider alloc] initWithFrame:CGRectMake(padding, CGRectGetMinY(self.controlButton.frame) - padding - height, frameWidth - padding * 2, height)];
    [self.seekBar addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.seekBar];
    
    self.speedIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.seekBar.frame) - padding - height, frameWidth, height)];
    self.speedIndexLabel.font = [UIFont boldSystemFontOfSize:30];
    self.speedIndexLabel.textAlignment = NSTextAlignmentCenter;
    self.speedIndexLabel.textColor = [UIColor blackColor];
    self.speedIndexLabel.text = @"加速 x1";
    [self.view addSubview:self.speedIndexLabel];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"加速模式", @"减速模式"]];
    self.segmentedControl.frame = CGRectMake(padding, CGRectGetMinY(self.speedIndexLabel.frame) - padding - height, frameWidth - padding * 2, height);
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, frameWidth,CGRectGetMinY(self.segmentedControl.frame) - padding) configuration:configuration];
    [self.view addSubview:self.webView];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"h5game" ofType:@"html"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    
    //同意隐私协议
    [GearSDK setAgreePrivacy:YES];
    
    //默认加速模式
    self.segmentedControl.selectedSegmentIndex = 0;
    //最大档位
    int maxSpeedIndex = 15;
    //最大真实变速倍率
    int maxGear = 5;
    //默认加速速度档位
    self.speedIndexUp = 1;
    //默认减速速度档位
    self.speedIndexDown = 1;
    
    self.seekBar.minimumValue = 1;
    self.seekBar.maximumValue = maxSpeedIndex;
    self.seekBar.value = [self isUpMode] ? self.speedIndexUp : self.speedIndexDown;
    
    //配置速度档位
    [GearSDK configMaxSpeedIndex:maxSpeedIndex maxGear:maxGear];
}

//UISegmentedControl值改变事件
- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    if (self.speedIndexUp != self.speedIndexDown) {
        if (sender.selectedSegmentIndex == 0) {
            [self.seekBar setValue:self.speedIndexUp animated:NO];
        } else{
            [self.seekBar setValue:self.speedIndexDown animated:NO];
        }
        [self sliderValueChanged:self.seekBar];
    }else{
        [self setSpeedIndex:self.speedIndexUp];
    }
}

//UISlider值改变事件
- (void)sliderValueChanged:(UISlider *)sender {
    int speedIndex = (int)roundf(sender.value);
    [self setSpeedIndex:speedIndex];
}

- (void)controlTap:(UIButton *)sender {
    self.isStart = !self.isStart;
    if (self.isStart) {
        [self.controlButton setTitle:[self isUpMode] ? @"停止加速" : @"停止减速" forState:UIControlStateNormal];
        //开启变速
        [GearSDK start];
    }else{
        [self.controlButton setTitle:[self isUpMode] ? @"开启加速" : @"开启减速" forState:UIControlStateNormal];
        //停止变速
        [GearSDK stop];
    }
}

- (void)showTap:(UIButton *)sender {
    //显示悬浮球
    int x = 0;
    int y = [UIScreen mainScreen].bounds.size.height / 2;
    [GearSDK showGearViewxPos:x yPos:y];
}

- (void)hideTap:(UIButton *)sender {
    //隐藏悬浮球
    [GearSDK hideGearView];
}

- (void)setSpeedIndex:(int)speedIndex{
    if ([self isUpMode]) {
        //加速模式设置速度档位
        self.speedIndexUp = speedIndex;
        self.speedIndexLabel.text = [NSString stringWithFormat:@"加速 x%d", speedIndex];
        [self.controlButton setTitle:self.isStart ? @"停止加速" : @"开启加速" forState:UIControlStateNormal];
        [GearSDK speedUp:speedIndex];
    }else{
        //减速模式设置速度档位
        self.speedIndexDown = speedIndex;
        self.speedIndexLabel.text = [NSString stringWithFormat:@"减速 x%d", speedIndex];
        [self.controlButton setTitle:self.isStart ? @"停止减速" : @"开启减速" forState:UIControlStateNormal];
        [GearSDK speedDown:speedIndex];
    }
}

- (BOOL)isUpMode{
    return self.segmentedControl.selectedSegmentIndex == 0;
}

- (UIButton*)createButtonWithTitle:(NSString *)title action:(SEL)action yPosition:(CGFloat)y {
    CGFloat frameWidth = self.view.frame.size.width;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, y, frameWidth - 60, 40);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button.backgroundColor = [UIColor systemGray5Color];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 8;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
