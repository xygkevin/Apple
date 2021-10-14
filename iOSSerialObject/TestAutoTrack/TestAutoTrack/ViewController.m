//
//  ViewController.m
//  TestAutoTrack
//
//  Created by uwei on 15/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "MPApplicationStateSerializer.h"
#import "MPObjectIdentityProvider.h"
#import "MPObjectSerializerConfig.h"
#import "CustomWindow.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.testButton.frame = CGRectMake(100, 10, 80, 80);
    self.testButton.backgroundColor = [UIColor yellowColor];
    [self.testButton setTitle:@"test" forState:UIControlStateNormal];
    self.testButton.titleLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.testButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)tap:(UIGestureRecognizer *)gesture {
    NSLog(@"tap from gesture");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)track:(UIButton *)sender {
    
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"conf" ofType:@"json"];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[[NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    
    
    MPObjectSerializerConfig *serializerConfig = [[MPObjectSerializerConfig alloc] initWithDictionary:dic];
    // Get the object identity provider from the connection's session store or create one if there is none already.
    MPObjectIdentityProvider *objectIdentityProvider = [[MPObjectIdentityProvider alloc] init];
    
    MPApplicationStateSerializer *serializer = [[MPApplicationStateSerializer alloc] initWithApplication:[UIApplication sharedApplication]
                                                                                             configuration:serializerConfig
                                                                                    objectIdentityProvider:objectIdentityProvider];
    
    NSDictionary *serializedObjects = [serializer objectHierarchyForWindowAtIndex:0];
    NSLog(@"%@", serializedObjects);
}
- (IBAction)clicked:(id)sender forEvent:(UIEvent *)event {
    CustomWindow *cw = [[CustomWindow alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].rootViewController.view.frame];
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:cw];
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view bringSubviewToFront:cw];
}


@end
