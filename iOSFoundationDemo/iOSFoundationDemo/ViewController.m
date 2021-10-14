//
//  ViewController.m
//  iOSFoundationDemo
//
//  Created by uwei on 21/12/2017.
//  Copyright © 2017 uwei. All rights reserved.
//

#import "ViewController.h"
#import "UserActivityViewController.h"
#import "TestObject.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *featureTableView;
@property (strong, nonatomic) NSMutableArray *featureDatas;
@property (strong, nonatomic) NSUserActivity *activity;

@end

#define cellID @"cell"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activity = [[[TestObject alloc] initWithName:@"" age:0] addUserActivity];
    self.featureDatas = [NSMutableArray arrayWithObject:@"user activity"];
    // Do any additional setup after loading the view, typically from a nib.
    [self.featureTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)restoreUserActivityState:(NSUserActivity *)activity {
    if ([activity.title isEqualToString:@"test"]) {
        NSLog(@"get test activity!");
    } else {
        NSLog(@"get no activity!");
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.featureDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.featureDatas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserActivityViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserActivityViewController"];
    [self.navigationController pushViewController:uvc animated:YES];
    
//    NSBundle *WGPlatformResourcesBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"WGPlatformResources" ofType:@"bundle"]] ;
//    UINib *nib = [UINib nibWithNibName:@"WGGameWebViewController" bundle:WGPlatformResourcesBundle];
//    NSArray *vcs = [nib instantiateWithOwner:nil options:nil];
//    UIViewController *vc = vcs.lastObject;
//    [self.navigationController pushViewController:vc animated:YES];
}


@end
