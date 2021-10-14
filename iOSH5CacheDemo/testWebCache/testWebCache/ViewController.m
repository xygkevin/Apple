//
//  ViewController.m
//  testWebCache
//
//  Created by uwei on 13/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.webview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://cnn.com"]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
