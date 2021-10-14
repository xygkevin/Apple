//
//  SCOrderPayResultViewController.m
//  SamClub
//
//  Created by uweiyuan on 2020/3/3.
//  Copyright © 2020 tencent. All rights reserved.
//

#import "SCOrderPayResultViewController.h"
#import "UIColor+HexColor.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry.h>

#define SCLocalizedStringWithKey(key) key
#define SC_SCREEN_WIDTH             ([UIScreen mainScreen].bounds.size.width)
#define SC_SCREEN_HEIGHT            ([UIScreen mainScreen].bounds.size.height)

#define SC_DP_375(size)   ((CGFloat)(size) / (375.0) * (MIN(SC_SCREEN_WIDTH, SC_SCREEN_HEIGHT)))


typedef NS_ENUM(NSUInteger, SCOrderPayType) {
    SCOrderPayTypeWechat = 1,
    SCOrderPayTypeAlipay = 2,
    SCOrderPayTypeChinaUnion = 3,
    SCOrderPayTypeWalmartCard = 4,
    SCOrderPayTypeBankCard = 5
};


typedef NS_ENUM(NSUInteger, SCOrderPayState) {
    SCOrderPayTypeSuccess = 1,
    SCOrderPayTypeFailed = 2,
    SCOrderPayTypeProcessing = 3
};

@interface SCOrderPayModel : NSObject

@property (nonatomic, strong) UIImage *resultImage;
@property (nonatomic, strong) NSString *resultInfo;
@property NSUInteger resultInfoColor;
@property SCOrderPayType payType;
@property SCOrderPayState payState;
@property CGFloat reduceMoney;
@property CGFloat costMoney;
@property (nonatomic, copy) NSString *reduceInfo;
@property (nonatomic, copy) NSString *orderArrivalInfo;

@end

@implementation SCOrderPayModel

@end


@interface SCOrderPayResultViewModel : NSObject

@property (nonatomic, strong) RACSubject *refreshUISubject;
@property (nonatomic, strong) RACSubject *returnHomeSubject;
@property (nonatomic, strong) RACSubject *orderDetailSubject;
@property (nonatomic, strong) RACSubject *repaySubject;

@property (nonatomic, strong) SCOrderPayModel *model;

@end

@implementation SCOrderPayResultViewModel

- (RACSubject *)refreshUISubject {
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}

- (RACSubject *)returnHomeSubject {
    if (!_returnHomeSubject) {
        _returnHomeSubject = [RACSubject subject];
    }
    return _returnHomeSubject;
}

- (RACSubject *)orderDetailSubject {
    if (!_orderDetailSubject) {
        _orderDetailSubject = [RACSubject subject];
    }
    return _orderDetailSubject;
}

- (RACSubject *)repaySubject {
    if (!_repaySubject) {
        _repaySubject = [RACSubject subject];
    }
    return _repaySubject;
}

@end


@interface SCOrderPayResultView : UIView

- (instancetype)initWithViewModel:(SCOrderPayResultViewModel *)viewModel;
@property (nonatomic, strong) SCOrderPayResultViewModel *resultViewModel;

@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UILabel *resultDesLabel;
@property (nonatomic, strong) UIStackView *resultStackView;

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *reduceMoneyTipsLabel;
@property (nonatomic, strong) UIView *seprateLine;
@property (nonatomic, strong) UILabel *arrivalInfoLabel;
@property (nonatomic, strong) UIButton *returnHomeButton;
@property (nonatomic, strong) UIButton *orderDetailButton;
@property (nonatomic, strong) UIButton *repayButton;
@property (nonatomic, strong) UIStackView *buttonStackView;

@end

@implementation SCOrderPayResultView

- (instancetype)initWithViewModel:(SCOrderPayResultViewModel *)viewModel {
    if (self = [super init]) {
        self.resultViewModel = viewModel;
        
        [self initUI];
        
        [self bindViewModel];
    }
    return self;
}

- (SCOrderPayResultViewModel *)resultViewModel {
    if (!_resultViewModel) {
        _resultViewModel = [[SCOrderPayResultViewModel alloc] init];
    }
    return _resultViewModel;
}

- (void)bindViewModel {
    [self.resultViewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        [self refreshUIWithViewModel:self.resultViewModel.model];
    }];
}

- (void)initProcessingUI {
    self.orderDetailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.orderDetailButton setTitle:SCLocalizedStringWithKey(@"订单详情") forState:UIControlStateNormal];
    [self.orderDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.orderDetailButton.titleLabel.font = [UIFont systemFontOfSize:SC_DP_375(16) weight:UIFontWeightRegular];
    self.orderDetailButton.backgroundColor = [UIColor colorWithHex:0x0165B8];
    
    [self addSubview:self.orderDetailButton];
}

- (void)initFaildUI {
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.font = [UIFont systemFontOfSize:SC_DP_375(16) weight:UIFontWeightRegular];
    self.moneyLabel.textColor = [UIColor colorWithHex:0x222427 alpha:1.0];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.repayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.repayButton setTitle:SCLocalizedStringWithKey(@"重新支付") forState:UIControlStateNormal];
    [self.repayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repayButton.titleLabel.font = [UIFont systemFontOfSize:SC_DP_375(16) weight:UIFontWeightRegular];
    self.repayButton.backgroundColor = [UIColor colorWithHex:0x0165B8];
    [[self.repayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.resultViewModel.repaySubject sendNext:nil];
    }];
    
    [self addSubview:self.moneyLabel];
    [self addSubview:self.repayButton];
}

- (void)initSuccessUIwithReduce:(CGFloat)reduce {
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.font = [UIFont systemFontOfSize:SC_DP_375(16) weight:UIFontWeightRegular];
    self.moneyLabel.textColor = [UIColor colorWithHex:0x222427 alpha:1.0];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    if (reduce > 0) {
        self.reduceMoneyTipsLabel = [[UILabel alloc] init];
        self.reduceMoneyTipsLabel.font = [UIFont systemFontOfSize:SC_DP_375(13) weight:UIFontWeightRegular];
        self.reduceMoneyTipsLabel.textColor = [UIColor colorWithHex:0x898E92 alpha:1.0];
        self.reduceMoneyTipsLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    self.seprateLine = [[UIView alloc] init];
    self.seprateLine.backgroundColor = [UIColor colorWithHex:0xDCE0E4 alpha:1.0];
    
    self.arrivalInfoLabel = [[UILabel alloc] init];
    self.arrivalInfoLabel.textColor = [UIColor colorWithHex:0xDE1C24];
    self.arrivalInfoLabel.textAlignment = NSTextAlignmentCenter;
    self.arrivalInfoLabel.font = [UIFont systemFontOfSize:SC_DP_375(14) weight:UIFontWeightRegular];
    
    self.returnHomeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.returnHomeButton.layer.borderWidth = 1;
    self.returnHomeButton.layer.borderColor = [UIColor colorWithHex:0x0165B8 alpha:1.0].CGColor;
    [self.returnHomeButton setTitle:SCLocalizedStringWithKey(@"返回首页") forState:UIControlStateNormal];
    [self.returnHomeButton setTitleColor:[UIColor colorWithHex:0x0165B8 alpha:1.0] forState:UIControlStateNormal];
    self.returnHomeButton.titleLabel.font = [UIFont systemFontOfSize:SC_DP_375(16) weight:UIFontWeightRegular];
    [[self.returnHomeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.resultViewModel.returnHomeSubject sendNext:nil];
    }];
    
    self.orderDetailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.orderDetailButton setTitle:SCLocalizedStringWithKey(@"订单详情") forState:UIControlStateNormal];
    [self.orderDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.orderDetailButton.titleLabel.font = [UIFont systemFontOfSize:SC_DP_375(16) weight:UIFontWeightRegular];
    self.orderDetailButton.backgroundColor = [UIColor colorWithHex:0x0165B8];
    [[self.orderDetailButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.resultViewModel.repaySubject sendNext:nil];
    }];
    
    self.buttonStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.returnHomeButton, self.orderDetailButton]];
    self.buttonStackView.axis = UILayoutConstraintAxisHorizontal;
    self.buttonStackView.distribution = UIStackViewDistributionFillEqually;
    self.buttonStackView.spacing = SC_DP_375(17);
    
    [self addSubview:self.moneyLabel];
    [self addSubview:self.reduceMoneyTipsLabel];
    [self addSubview:self.arrivalInfoLabel];
    [self addSubview:self.seprateLine];
    [self addSubview:self.buttonStackView];
}

- (void)initUI {
    self.backgroundColor = [UIColor yellowColor];
    self.resultImageView = [[UIImageView alloc] init];
    self.resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.resultDesLabel = [[UILabel alloc] init];
    self.resultDesLabel.font = [UIFont systemFontOfSize:SC_DP_375(20) weight:UIFontWeightMedium];
    
    self.resultStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.resultImageView, self.resultDesLabel]];
    self.resultStackView.axis = UILayoutConstraintAxisHorizontal;
    self.resultStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.resultStackView.spacing = 8;
    
    [self addSubview:self.resultStackView];
}

- (void)updateConstraints {
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(SC_DP_375(30));
    }];
    
    [self.resultDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SC_DP_375(30));
    }];
    
    [self.resultStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SC_DP_375(40));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    if (self.resultViewModel.model.payState == SCOrderPayTypeSuccess) {
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.resultStackView.mas_bottom).mas_offset(8);
            make.height.mas_equalTo(SC_DP_375(28));
            make.width.mas_equalTo(self);
        }];
        
        if (self.resultViewModel.model.reduceMoney > 0) {
            [self.reduceMoneyTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.top.mas_equalTo(self.moneyLabel.mas_bottom).mas_offset(4);
                make.height.mas_equalTo(SC_DP_375(18));
                make.width.mas_equalTo(self);
            }];
        }
        
        [self.seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SC_DP_375(24));
            make.right.mas_equalTo(SC_DP_375(-24));
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.resultViewModel.model.reduceMoney > 0 ? self.reduceMoneyTipsLabel.mas_bottom : self.moneyLabel.mas_bottom).mas_offset(SC_DP_375(16.5));
        }];
        
        [self.arrivalInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.seprateLine.mas_bottom).mas_offset(SC_DP_375(16.5));
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(SC_DP_375(20));
            make.width.mas_equalTo(self);
        }];
        
        [self.buttonStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SC_DP_375(24));
            make.right.mas_equalTo(SC_DP_375(-24));
            make.top.mas_equalTo(self.arrivalInfoLabel.mas_bottom).mas_offset(SC_DP_375(20));
            make.height.mas_equalTo(SC_DP_375(48));
        }];
    } else if (self.resultViewModel.model.payState == SCOrderPayTypeFailed) {
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.resultStackView.mas_bottom).mas_offset(8);
            make.height.mas_equalTo(SC_DP_375(28));
            make.width.mas_equalTo(self);
        }];
        
        [self.repayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SC_DP_375(24));
            make.right.mas_equalTo(SC_DP_375(-24));
            make.top.mas_equalTo(self.moneyLabel.mas_bottom).mas_offset(SC_DP_375(30));
            make.height.mas_equalTo(SC_DP_375(48));
        }];
        
    } else if (self.resultViewModel.model.payState == SCOrderPayTypeProcessing) {
        [self.orderDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SC_DP_375(24));
            make.right.mas_equalTo(SC_DP_375(-24));
            make.top.mas_equalTo(self.resultStackView.mas_bottom).mas_offset(SC_DP_375(30));
            make.height.mas_equalTo(SC_DP_375(48));
        }];
    }
    
    [super updateConstraints];
}

- (void)refreshUIWithViewModel:(SCOrderPayModel *)model {
    if (!model) {
        return;
    }
    
    self.resultImageView.image = model.resultImage;
    self.resultDesLabel.text = model.resultInfo;
    [self.resultDesLabel sizeToFit];
    self.resultDesLabel.textColor = [UIColor colorWithHex:model.resultInfoColor alpha:1.0];
    
    if (model.payState == SCOrderPayTypeSuccess) {
        [self initSuccessUIwithReduce:model.reduceMoney];
        self.moneyLabel.text = [NSString stringWithFormat:@"%@%@", SCLocalizedStringWithKey(@"实付：￥"), @(model.costMoney)];
        if (model.reduceMoney > 0) {
            self.reduceMoneyTipsLabel.text = [NSString stringWithFormat:@"%@%@", SCLocalizedStringWithKey(@"本次购物，山姆为您节省："), @(model.reduceMoney)];
        }
        self.arrivalInfoLabel.text = model.orderArrivalInfo;
    }
    
    if (model.payState == SCOrderPayTypeFailed) {
        [self initFaildUI];
        self.moneyLabel.text = [NSString stringWithFormat:@"%@%@", SCLocalizedStringWithKey(@"待支付：￥"), @(model.costMoney)];
    }
    
    if (model.payState == SCOrderPayTypeProcessing) {
        [self initProcessingUI];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end




@interface SCOrderPayResultMainViewModel : NSObject

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) SCOrderPayResultViewModel *resultViewModel;
@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACSubject *returnHomeSubject;
@property (nonatomic, strong) RACSubject *orderDetailSubject;
@property (nonatomic, strong) RACSubject *repaySubject;




@end

@implementation SCOrderPayResultMainViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            SCOrderPayModel *model = [[SCOrderPayModel alloc] init];
            
            model.payState = SCOrderPayTypeSuccess;
            model.resultImage = [UIImage imageNamed:@"order_pay_success"];
            model.resultInfo = SCLocalizedStringWithKey(@"支付成功");
            model.costMoney = 340.9;
            model.resultInfoColor = 0x509036;
            model.reduceMoney = 201.09;
            model.orderArrivalInfo = @"预计明日09:00-10:00送达";
            
//            model.payState = SCOrderPayTypeFailed;
//            model.resultImage = [UIImage imageNamed:@"order_pay_failed"];
//            model.resultInfo = SCLocalizedStringWithKey(@"支付失败");
//            model.costMoney = 340.9;
            
//            model.payState = SCOrderPayTypeProcessing;
//            model.resultImage = [UIImage imageNamed:@"order_pay_ing"];
//            model.resultInfo = SCLocalizedStringWithKey(@"订单已提交，待转账");
            
            
            NSMutableArray *datas = [NSMutableArray array];
            [datas addObject:model];
            
            self.dataArray = datas;
            self.resultViewModel.model = model;
            [self.resultViewModel.refreshUISubject sendNext:nil];
        }];
    }
    return self;
}

- (SCOrderPayResultViewModel *)resultViewModel {
    if (!_resultViewModel) {
        _resultViewModel = [[SCOrderPayResultViewModel alloc] init];
    }
    return _resultViewModel;
}

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
            _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                // input is order_id
                return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                    NSDictionary *queryInfo = @{@"order_id":@1};
                    // API
                    // API callback
                    NSDictionary *result = @{};
                    [subscriber sendNext:result];
                    
                    [subscriber sendCompleted];
                    return [RACDisposable disposableWithBlock:^{
                        // finished
                    }];
                }];
            }];
        }
    return _refreshDataCommand;
}

- (RACSubject *)returnHomeSubject {
    return self.resultViewModel.returnHomeSubject;
}

- (RACSubject *)orderDetailSubject {
    return self.resultViewModel.orderDetailSubject;
}

- (RACSubject *)repaySubject {
    return self.resultViewModel.repaySubject;
}

@end

@interface SCOrderPayResultMainView : UIView

- (instancetype)initWithViewModel:(SCOrderPayResultMainViewModel *)viewModel;

@end

@interface SCOrderPayResultMainView ()

@property (nonatomic, strong) SCOrderPayResultMainViewModel *mainViewModel;

@property (nonatomic, strong) SCOrderPayResultView *resultView;

@end

@implementation SCOrderPayResultMainView

- (instancetype)initWithViewModel:(SCOrderPayResultMainViewModel *)viewModel {
    if (self = [super init]) {
        self.mainViewModel = viewModel;
        [self addSubview:self.resultView];
        [self bindViewModel];
    }
    return self;
}

- (void)bindViewModel {
    [self.mainViewModel.refreshDataCommand execute:nil];
    [self.mainViewModel.resultViewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        //
        [self setNeedsUpdateConstraints];
    }];
}

- (SCOrderPayResultView *)resultView {
    if (!_resultView) {
        _resultView = [[SCOrderPayResultView alloc] initWithViewModel:self.mainViewModel.resultViewModel];
    }
    return _resultView;
}

- (SCOrderPayResultMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[SCOrderPayResultMainViewModel alloc] init];
    }
    
    return _mainViewModel;
}

- (void)updateConstraints {
    if (self.mainViewModel.resultViewModel.model.payState == SCOrderPayTypeSuccess) {
        [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(SC_DP_375(385));
        }];
    } else if (self.mainViewModel.resultViewModel.model.payState == SCOrderPayTypeFailed) {
        [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(SC_DP_375(320));
        }];
    } else if (self.mainViewModel.resultViewModel.model.payState == SCOrderPayTypeProcessing) {
        [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(SC_DP_375(284));
        }];
    }
     [super updateConstraints];
}
@end


@interface SCOrderPayResultViewController ()

@property (nonatomic, strong) SCOrderPayResultMainViewModel *resultMainViewModel;
@property (nonatomic, strong) SCOrderPayResultMainView *resultMainView;

@end

@implementation SCOrderPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SCLocalizedStringWithKey(@"支付结果");
    [self.view addSubview:self.resultMainView];
    [self bindViewModel];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"xxxxxxxxxx"];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"++++++++");
        }];
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal01--------- %@", x);
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal02--------- %@", x);
    }];
    
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者1---------%@", x);
    }];
    
    [subject sendNext:@"subject1"];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者2--------%@", x);
    }];
    
    [subject sendNext:@"subject2"];
    
    
}

- (void)updateViewConstraints {
    [self.resultMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (void)bindViewModel {
    [self.resultMainViewModel.returnHomeSubject subscribeNext:^(id  _Nullable x) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [self.resultMainViewModel.orderDetailSubject subscribeNext:^(id  _Nullable x) {
         //TODO: 跳转到详情页
        NSLog(@"跳转到详情页");
    }];
    [self.resultMainViewModel.repaySubject subscribeNext:^(id  _Nullable x) {
        //TODO: 重新拉起支付
        NSLog(@"重新拉起支付");
    }];
}

- (SCOrderPayResultMainViewModel *)resultMainViewModel {
    if (!_resultMainViewModel) {
        _resultMainViewModel = [SCOrderPayResultMainViewModel new];
    }
    
    return _resultMainViewModel;
}

- (SCOrderPayResultMainView *)resultMainView {
    if (!_resultMainView) {
        _resultMainView = [[SCOrderPayResultMainView alloc] initWithViewModel:self.resultMainViewModel];
    }
    
    return _resultMainView;
}

@end
