//
//  ViewController.m
//  iOSSensorDemo
//
//  Created by uwei on 02/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "DistanceViewController.h"
#import "AccelerometerViewController.h"
#import "GyroViewController.h"
#import "MagnetometerViewController.h"
#import "PedometerViewController.h"
#import "AltimeterViewController.h"
#import "ThermalStateViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *sensorNameTable;
@property (strong, nonatomic) NSArray *names;
@property (strong, nonatomic) CMMotionActivityManager *activityManager;
@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.sensorNameTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    self.names = @[@"距离传感器", @"加速计",@"磁力计",@"陀螺仪",@"计步器", @"测高仪", @"GPS", @"温度情况"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(startActivity:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stopActivity:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    leftItem.enabled = NO;
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.text = @"未启动检测";
    self.navigationItem.titleView = self.statusLabel;
    
    // Do any additional setup after loading the view, typically from a nib.
    if ([CMMotionActivityManager isActivityAvailable]) {
        NSLog(@"CMMotionActivityManager OK");
        rightItem.enabled = YES;
        if (!self.activityManager) {
            self.activityManager = [CMMotionActivityManager new];
        }
        
    } else {
        rightItem.enabled = NO;
        NSLog(@"CMMotionActivityManager NO");
    }
}

- (void)startActivity:(UIBarButtonItem *)sender {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity * _Nullable activity) {
        if (activity.confidence != CMMotionActivityConfidenceLow) {
            if (!(activity.stationary || activity.walking || activity.running || activity.automotive || activity.cycling || activity.unknown)) {
                self.statusLabel.text = @"数据不足，无法预测";
            } else if (activity.stationary) {
                self.statusLabel.text = @"设备静止不动";
            } else if (activity.walking) {
                self.statusLabel.text = @"设备在步行";
            } else if (activity.running) {
                self.statusLabel.text = @"设备在跑步";
            } else if (activity.automotive) {
                self.statusLabel.text = @"设备在汽车上";
            } else if (activity.cycling) {
                self.statusLabel.text = @"设备在自行车上";
            } else if (activity.unknown) {
                self.statusLabel.text = @"未知";
            }
        }
        NSLog(@"activity is stationary:%d walking:%d running:%d automotive:%d cycling:%d, unknown:%d", activity.stationary, activity.walking, activity.running, activity.automotive, activity.cycling, activity.unknown);
    }];
}

- (void)stopActivity:(UIBarButtonItem *)sender {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled  = NO;
    [self.activityManager stopActivityUpdates];
    self.statusLabel.text = @"未启动检测";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.textLabel.text = self.names[indexPath.row];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            
            DistanceViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DistanceViewController"];
            [self.navigationController pushViewController:dvc animated:YES];
            break;
        }
            
            case 1:
        {
            AccelerometerViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccelerometerViewController"];
            [self.navigationController pushViewController:avc animated:YES];
            break;
        }
        case 2:
        {
            MagnetometerViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MagnetometerViewController"];
            [self.navigationController pushViewController:mvc animated:YES];
            break;
        }
        case 3:
        {
            GyroViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GyroViewController"];
            [self.navigationController pushViewController:gvc animated:YES];
            break;
        }
            
        case 4:
        {
            PedometerViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PedometerViewController"];
            [self.navigationController pushViewController:pvc animated:YES];
            break;
        }
        case 5:
        {
            AltimeterViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AltimeterViewController"];
            [self.navigationController pushViewController:pvc animated:YES];
            break;
        }
        case 6:
        {
            //
        }
        case 7:
        {
            ThermalStateViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ThermalStateViewController"];
            [self.navigationController pushViewController:pvc animated:YES];
        }
        default:
            break;
    }
}


@end
