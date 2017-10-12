//
//  ViewController.m
//  RunLoopDemo
//
//  Created by 曾凡旭 on 2017/10/12.
//  Copyright © 2017年 zengfxios. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (strong,nonatomic) dispatch_queue_t myQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    CFOptionFlags observer = kCFRunLoopEntry|kCFRunLoopBeforeTimers|kCFRunLoopBeforeSources|kCFRunLoopBeforeWaiting|kCFRunLoopAfterWaiting;
    [self createRunLoopObserverWithType:observer];
    //    [self createRunLoopObserverWithType:kCFRunLoopBeforeTimers];
    //    [self createRunLoopObserverWithType:kCFRunLoopBeforeSources];
    //    [self createRunLoopObserverWithType:kCFRunLoopBeforeWaiting];
    //    [self createRunLoopObserverWithType:kCFRunLoopAfterWaiting];
    
    CFRunLoopRef mainRunloop = CFRunLoopGetMain();
    CFRunLoopPerformBlock(mainRunloop, kCFRunLoopCommonModes, ^{
        NSLog(@"CFRunLoopPerformBlock");
    });
    
    
    [self performSelector:@selector(performSelector) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    
    
    [self addButton];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"GCD dispatch_after");
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"GCD dispatch_async");
    });
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
    
    
    _myQueue = dispatch_queue_create("com.myQueue", NULL);
    dispatch_async(_myQueue, ^{
        NSLog(@"GCD dispatch_async myQueue");
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)addButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 50)];
    button.backgroundColor = [UIColor cyanColor];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)createRunLoopObserverWithType:(CFOptionFlags)flag{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFStringRef runLoopMode = kCFRunLoopDefaultMode;
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, flag, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _activity) {
        
        switch (_activity) {
            case kCFRunLoopEntry:
                NSLog(@"即将进入 RunLoop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理 Timer");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理 Source");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入休眠");
                ;
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"从休眠中唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"即将退出Loop");
                break;
            default:
                break;
        }
    });
    
    CFRunLoopAddObserver(runLoop, observer, runLoopMode);
}

- (void)performSelector{
    NSLog(@"performSelector");
}

- (void)buttonAction{
    NSLog(@"buttonAction");
}

- (void)timerAction{
    NSLog(@"timerAction");
}


@end
