//
//  ThermalStateViewController.m
//  iOSSensorDemo
//
//  Created by uwei on 2018/7/27.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "ThermalStateViewController.h"

@interface ThermalStateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation ThermalStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"温度";
    if (@available(iOS 11.0, *)) {
        switch ([[NSProcessInfo processInfo] thermalState]) {
            case NSProcessInfoThermalStateNominal:
                self.stateLabel.text = @"NSProcessInfoThermalStateNominal";
                break;
            case NSProcessInfoThermalStateFair:
                self.stateLabel.text = @"NSProcessInfoThermalStateNominal";
                break;
            case NSProcessInfoThermalStateSerious:
                self.stateLabel.text = @"NSProcessInfoThermalStateNominal";
                break;
            case NSProcessInfoThermalStateCritical:
                self.stateLabel.text = @"NSProcessInfoThermalStateNominal";
                break;
                
            default:
                break;
        }
        ;
    } else {
        // Fallback on earlier versions
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
