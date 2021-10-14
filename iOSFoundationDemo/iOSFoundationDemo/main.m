//
//  main.m
//  iOSFoundationDemo
//
//  Created by uwei on 21/12/2017.
//  Copyright © 2017 uwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TestObject.h"

NSArray *threadArray = nil;

// 默认可能是atomic的，即原子操作
NSInteger threadIntNum = 0;

int main(int argc, char * argv[]) {
#pragma mark - Fundamentals
// // TODO: - Numbers, Data, and Basic Values & Data Formatting
    // 123 x 10-3
    NSDecimal decimal = {-3,5,0,1,0,123};
    NSLocale* locale = [NSLocale autoupdatingCurrentLocale];
    NSLog(@"string = %@", NSDecimalString(&decimal, locale));
    NSDecimalNumber *decimalNumber = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:124.9];
    //    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithMantissa:678 exponent:-2 isNegative:YES];
    NSLog(@"string = %@", [decimalNumber stringValue]);
    NSDecimal decimalFromNumber = [decimalNumber decimalValue];
    NSLog(@"string = %@", NSDecimalString(&decimalFromNumber, locale));
    
    //以","当做小数点格式
    NSDictionary *localeDic = [NSDictionary dictionaryWithObject:@"," forKey:NSLocaleDecimalSeparator];
    //123.4
    NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithString:@"123,419" locale:localeDic];
    NSLog(@"string = %@", [discountAmount stringValue]);
    
    // 算数运算
    NSDecimalNumber *addDecimalNumber = [decimalNumber decimalNumberByAdding:discountAmount];
    NSLog(@"string = %@", [addDecimalNumber stringValue]);
    
    /***************    Type definitions        ***********/
    
    // Rounding policies :
    // Original
    //    value 1.2  1.21  1.25  1.35  1.27
    // Plain    1.2  1.2   1.3   1.4   1.3
    // Down     1.2  1.2   1.2   1.3   1.2
    // Up       1.2  1.3   1.3   1.4   1.3
    // Bankers  1.2  1.2   1.2   1.4   1.3
    
    // 四舍五入运算
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSLog(@"string = %@", [addDecimalNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior]);
    
    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.numberStyle = NSNumberFormatterCurrencyStyle;
    nf.roundingMode = NSNumberFormatterRoundUp;
    nf.roundingIncrement = @(0.2);
    NSLog(@"string = %@", [nf stringFromNumber:@(124.897)]);
    
    NSString *urlString = @"https://username:password@www.apple.com:1290/us/search/uweiyuan?src=globalnav&name=value#jumpLocation";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLComponents *urlComponent = [NSURLComponents componentsWithString:urlString];
    
    NSUUID *uuid = [NSUUID UUID];
    NSLog(@"string = %@", [uuid UUIDString]);
    
    NSRange range = NSMakeRange(102, 89);
    NSLog(@"string = %@", NSStringFromRange(range));
    range = NSRangeFromString(@"{89, 90}");
    //集合运算 union、intersect
    range = NSIntersectionRange(range, NSMakeRange(102, 89));
    NSLog(@"string = %@", NSStringFromRange(range));
    if (NSLocationInRange(150, range)) {
        NSLog(@"in");
    } else {
        NSLog(@"out");
    }
    
    // 规律一：NSFormatter， 对于很多数据格式化，都是有Foundation定义的(NSByteCountFormatter, NSDateFormatter, NSDateComponentsFormatter, NSDateIntervalFormatter, NSEnergyFormatter, NSLengthFormatter, NSMassFormatter, NSNumberFormatter, and NSPersonNameComponentsFormatter)
    // 规律二：NS****FromString、 NSStringFrom****，****代表大多数OC中原生的数据类型
    
// TODO: - Strings and Text
    
    NSString *text = @"我们是共产主义接班人，迎接着朝霞";
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeTokenType] options:0];
    tagger.string = text;
    NSRange textRange = NSMakeRange(0, text.length);
    [tagger enumerateTagsInRange:textRange unit:(NSLinguisticTaggerUnitWord) scheme:( NSLinguisticTagSchemeTokenType) options:NSLinguisticTaggerOmitPunctuation|NSLinguisticTaggerOmitWhitespace usingBlock:^(NSLinguisticTag  _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        NSLog(@"%@", [text substringWithRange:tokenRange]);
    }];
    
    [[NSLinguisticTagger availableTagSchemesForLanguage:@"zh-Hans"] enumerateObjectsUsingBlock:^(NSLinguisticTagScheme  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    [[NSLinguisticTagger availableTagSchemesForLanguage:@"en"] enumerateObjectsUsingBlock:^(NSLinguisticTagScheme  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    NSLog(@"lan is %@", [NSLinguisticTagger dominantLanguageForString:@"ありがとうございます"]);
    NSLog(@"lan is %@", [NSLinguisticTagger dominantLanguageForString:@"非常的感谢"]);
    NSLog(@"lan is %@", [NSLinguisticTagger dominantLanguageForString:@"thank you very much"]);
    NSRange orthographyRange;
    NSLog(@"orthography is %@", [tagger orthographyAtIndex:0 effectiveRange:&orthographyRange]);
    
    text = @"The American Red Cross was established in Washington, D.C., by Clara Barton.";
    tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeNameType] options:0];
    tagger.string = text;
    textRange = NSMakeRange(0, text.length);
    NSArray *tags = @[NSLinguisticTagPersonalName, NSLinguisticTagPlaceName, NSLinguisticTagOrganizationName];
    [tagger enumerateTagsInRange:textRange unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeNameType options:NSLinguisticTaggerOmitPunctuation|NSLinguisticTaggerOmitWhitespace|NSLinguisticTaggerJoinNames usingBlock:^(NSLinguisticTag  _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if ([tags containsObject:tag]) {
            NSLog(@"name :%@ tag:%@", [text substringWithRange:tokenRange], tag);
        }
    }];
    
    NSString *scannerString = @"100q100.89a99";
    NSScanner *stringScanner = [NSScanner scannerWithString:scannerString];
    stringScanner.charactersToBeSkipped = [NSCharacterSet letterCharacterSet];
    unsigned long long ll  = 0;
    NSLog(@"hex is %hhd", [stringScanner scanHexLongLong:&ll]);
    float f = 0.0;
    NSLog(@"float is %hhd", [stringScanner scanFloat:&f]);
    NSInteger i = 0;
    [stringScanner scanInt:&i];
    NSLog(@"int is %ld", (long)i);
    
// // TODO: - Collections
    NSArray *name1Array = @[@"g", @"b", @"c", @"d"];
    NSArray *name2Array = @[@"a", @"f", @"d", @"g"];
    NSCountedSet *countedName1Set = [[NSCountedSet alloc] initWithArray:name1Array];
    NSCountedSet *countedName2Set = [[NSCountedSet alloc] initWithArray:name2Array];
    [countedName1Set unionSet:countedName2Set];
    NSLog(@"%@", countedName1Set);
    
    NSOrderedSet *orderedNameSet = [[NSOrderedSet alloc] initWithArray:name1Array];
    NSLog(@"%@", orderedNameSet);
    NSLog(@"%@", [orderedNameSet objectAtIndex:2]);
    NSOrderedSet *orderedSet = [[NSOrderedSet alloc] initWithObjects:@"f",@"a", @"e", @"g", @"b", @"c", @"d", nil];
    NSLog(@"%@", orderedSet);
    NSSet *set = [[NSSet alloc] initWithObjects:@"f",@"a", @"e", @"g", @"b", @"c", @"d", nil];
    NSLog(@"%@", set);
    
    //A mutable collection you use to temporarily store transient key-value pairs that are subject to eviction when resources are low
    NSCache *cache = [NSCache new];
    cache.countLimit = 1;
    [cache setObject:@"aValue" forKey:@"akey"];
    [cache setObject:@"bValue" forKey:@"bkey" cost:1];
    NSLog(@"%@", [cache objectForKey:@"bkey"]);
    
    // Pointer Collections
    // NSMapTable    NSHashTable
    NSPointerArray *pointerArray = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsOpaqueMemory];
    int intI = 99;
    void *nullPointer = NULL;
    [pointerArray addPointer:&intI];
    [pointerArray addPointer:nullPointer];
    NSLog(@"%@", pointerArray);
    NSLog(@"%d", *(int *)([pointerArray pointerAtIndex:0]));
    
// TODO: - Dates and Times
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = 20;
    dateComponents.month = 12;
    dateComponents.year = 2017;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSLog(@"time zone name %@", calendar.timeZone.name);
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [calendar dateFromComponents:dateComponents];
    
    NSInteger weekday = [calendar component:NSCalendarUnitWeekdayOrdinal fromDate:date];
    NSLog(@"first day is %ld, now is %ld", calendar.firstWeekday,(long)weekday); // 5, which corresponds to Thursday in the Gregorian Calendar
    
    [calendar.shortStandaloneMonthSymbols enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    [calendar.weekdaySymbols enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    [calendar.quarterSymbols enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    [calendar.longEraSymbols enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    [[NSTimeZone knownTimeZoneNames] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleBrief;
    formatter.includesApproximationPhrase = YES;
    formatter.includesTimeRemainingPhrase = YES;
    formatter.allowedUnits = NSCalendarUnitMinute;
    
    // Use the configured formatter to generate the string.
    NSString* outputString = [formatter stringFromTimeInterval:78400];
    NSLog(@"%@",outputString);
    
    NSDateIntervalFormatter* intervalFormatter = [[NSDateIntervalFormatter alloc] init];
    //    intervalFormatter.dateTemplate = @"YYYY:MM:dd HH-m-sss";
    intervalFormatter.dateStyle = NSDateIntervalFormatterShortStyle;
    intervalFormatter.timeStyle = NSDateIntervalFormatterShortStyle;
    
    // Create two dates that are exactly 1 day apart.
    NSDate* startDate = [NSDate date];
    NSDate* endDate = [NSDate dateWithTimeInterval:86400 sinceDate:startDate];
    
    // Use the configured formatter to generate the string.
    NSString* intervalFormatterOutputString = [intervalFormatter stringFromDate:startDate toDate:endDate];
    NSLog(@"%@",intervalFormatterOutputString);
    
    NSISO8601DateFormatter *isoFormatter = [NSISO8601DateFormatter new];
    isoFormatter.formatOptions = NSISO8601DateFormatWithFullDate|NSISO8601DateFormatWithTime;
    NSString *isoStringOutput = [isoFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",isoStringOutput);
    
    [[NSLocale ISOCountryCodes] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    [[NSLocale ISOLanguageCodes] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    [[NSLocale ISOCurrencyCodes] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    [[NSLocale availableLocaleIdentifiers] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
// TODO: - Units and Measurement
    //    NSUnit *pressUnit = [NSUnitPressure kilopascals];
    NSUnit *pressUnit = [NSUnitLength meters];
    NSMeasurement *measurement = [[NSMeasurement alloc] initWithDoubleValue:1007.98 unit:pressUnit];
    NSMeasurementFormatter *measureFormatter = [NSMeasurementFormatter new];
    measureFormatter.unitOptions = NSMeasurementFormatterUnitOptionsProvidedUnit;
    measureFormatter.unitStyle = NSFormattingUnitStyleShort;
    NSString *measurementFormatterOutputString = [measureFormatter stringFromMeasurement:measurement];
    NSLog(@"%@",measurementFormatterOutputString);
    
    // y = mx + b
    // subclass converter
    NSUnitConverter *converter = [[NSUnitConverterLinear alloc] initWithCoefficient:10 constant:0];
    double linerResult = [converter baseUnitValueFromValue:1.879];
    NSLog(@"%f",linerResult);
    
    // 总结：有很多物理学度量的类：Physical Dimension、Mass, Weight, and Force、Time and Motion、Energy, Heat, and Light、Electricity、Concentration and Dispersion、Fuel Efficiency
    
// TODO: - Filters and Sorting
    NSString *testMatchString = @"we are the champion";
    // self指向evaluateWithObject的参数
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self BEGINSWITH[c] 'We'"];
    if ([predicate evaluateWithObject:testMatchString]) {
        NSLog(@" testMatchString BEGINSWITH We!");
    } else {
        NSLog(@" testMatchString not BEGINSWITH We!");
    }
    
    NSArray *filterArray = @[@"ab", @"abc"];
    NSArray *targetArray = @[@"a", @"b", @"c", @"ab", @"ac", @"bc", @"abc", @"ab"];
    NSPredicate *arrayPredicate = [NSPredicate predicateWithFormat:@"ANY self == 'bc'"];
    if ([arrayPredicate evaluateWithObject:filterArray]) {
        NSLog(@"find bc!");
    } else {
        NSLog(@"not find bc!");
    }
    if ([arrayPredicate evaluateWithObject:targetArray]) {
        NSLog(@"find bc!");
    } else {
        NSLog(@"not find bc!");
    }
    NSPredicate *filterArrayPredicate = [NSPredicate predicateWithFormat:@"(self in %@)", filterArray];
    NSArray *resultArray = [targetArray filteredArrayUsingPredicate:filterArrayPredicate];
    NSLog(@"result array = %@", resultArray);
    
    
    TestObject *o1 = [[TestObject alloc] initWithName:@"uwei" age:12];
    TestObject *o2 = [[TestObject alloc] initWithName:@"wei" age:21];
    TestObject *o3 = [[TestObject alloc] initWithName:@"yuan" age:2];
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name like '*wei'"];
    if ([namePredicate evaluateWithObject:o1]) {
        NSLog(@"o1 find wei!");
    }
    
    if ([namePredicate evaluateWithObject:o2]) {
        NSLog(@"o2 find wei!");
    }
    
    if ([namePredicate evaluateWithObject:o3]) {
        NSLog(@"o3 find wei!");
    }
    
    NSArray *oArray = @[o1,o2,o3];
    NSArray *resultOArray = [oArray filteredArrayUsingPredicate:namePredicate];
    for (TestObject *o in resultOArray) {
        NSLog(@"name = %@, age = %lu", o.name, (unsigned long)o.age);
    }
    
    NSString *property = @"name";
    NSString *value = @"yuan";
    //  该谓词的作用是如果元素中property属性含有值value时就取出放入新的数组内，这里是name包含Jack
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", property, value];
    NSArray *newArray = [oArray filteredArrayUsingPredicate:pred];
    for (TestObject *o in newArray) {
        NSLog(@"name = %@, age = %lu", o.name, (unsigned long)o.age);
    }
    
    //  创建谓词，属性名改为age，要求这个age包含$VALUE字符串
    NSPredicate *predTemp = [NSPredicate predicateWithFormat:@"%K >= $VALUE", @"age"];
    // 指定$VALUE的值为 25
    NSPredicate *pred1 = [predTemp predicateWithSubstitutionVariables:@{@"VALUE" : @12}];
    NSArray *newArray1 = [oArray filteredArrayUsingPredicate:pred1];
    for (TestObject *o in newArray1) {
        NSLog(@"name = %@, age = %lu", o.name, (unsigned long)o.age);
    }
    
    NSExpression *lhs = [NSExpression expressionForKeyPath:@"name"];
    NSExpression *rhs = [NSExpression expressionForVariable:@"VK"];
    NSPredicate *predicateTemplate = [NSComparisonPredicate
                                      predicateWithLeftExpression:lhs
                                      rightExpression:rhs
                                      modifier:NSDirectPredicateModifier
                                      type:NSLikePredicateOperatorType
                                      options:NSCaseInsensitivePredicateOption];
    NSPredicate *predicate11 = [predicateTemplate predicateWithSubstitutionVariables: [NSDictionary dictionaryWithObject:@"*wei" forKey:@"VK"]];
    
    [[oArray filteredArrayUsingPredicate:predicate11] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"NSExpression name = %@, age = %lu", ((TestObject*)obj).name, (unsigned long)((TestObject*)obj).age);
    }];
    
    // NSCompoundPredicate for AND OR NOT logical combinations
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSComparisonResult comResult = [sortDescriptor compareObject:o1 toObject:o2];
    NSLog(@"%ld", (long)comResult);
    
    //规律总结
    // Simple comparisons, such as grade == "7" or firstName like "Shaffiq"
    // Case and diacritic insensitive lookups, such as name contains[cd] "itroen"
    // Logical operations, such as (firstName like "Mark") OR (lastName like "Adderley")
    // Temporal range constraints, such as date between {$YESTERDAY, $TOMORROW}.
    // Relational conditions, such as group.name like "work*"
    // Aggregate operations, such as @sum.items.price < 1000
    // Reference URL:https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795
#pragma mark - App Support
// TODO: - Task Management
//    [o1.undoManager setActionName:@"addUndoOperation"];
    NSLog(@"name is %@", o1.name);
    [o1 changeName:@"new_name"];
    NSLog(@"name is %@", o1.name);
    [o1.undoManager undo];
    NSLog(@"name is %@", o1.name);
    if ([o1.undoManager canRedo]) {
        [o1.undoManager redo];
        NSLog(@"name is %@", o1.name);
    }
    
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    // You use activities when your application is performing a long-running operation
    // If the activity can take different amounts of time (for example, calculating the next move in a chess game), it should use this API.
    // In addition, if your application requires high priority I/O, you can include the NSActivityLatencyCritical flag (using a bitwise OR). You should only use this flag for activities like audio or video recording that really do require high priority.
    // If your activity takes place synchronously inside an event callback on the main thread, you do not need to use this API.
    // This API also provides a mechanism to disable system-wide idle sleep and display idle sleep.
    NSLog(@"Accessing Process Information:%@===%@===%@===%@===%d", processInfo.arguments.description, processInfo.environment, processInfo.processName, processInfo.globallyUniqueString, processInfo.processIdentifier);
    
    NSLog(@"Getting Host Information:%@===%ld===%@===%@===%@", processInfo.hostName, processInfo.operatingSystem, processInfo.operatingSystemName, processInfo.operatingSystemVersionString, [NSString stringWithFormat:@"%ld%ld%ld", processInfo.operatingSystemVersion.majorVersion, processInfo.operatingSystemVersion.minorVersion, processInfo.operatingSystemVersion.patchVersion]);
    
    
    NSLog(@"Getting Computer Information:%ld===%ld===%lld===%f", processInfo.processorCount, processInfo.activeProcessorCount, processInfo.physicalMemory, processInfo.systemUptime);
    // 设备的温度水平
    NSString *thermalStateString = nil;
    switch (processInfo.thermalState) {
        case NSProcessInfoThermalStateFair:
            thermalStateString = @"Fair";
            break;
        case NSProcessInfoThermalStateNominal:
            thermalStateString = @"Normal";
            break;
        case NSProcessInfoThermalStateSerious:
            thermalStateString = @"Serious";
            break;
        case NSProcessInfoThermalStateCritical:
            thermalStateString = @"Critical";
            break;
            
        default:
            break;
    }
    NSLog(@"Thermal State is %@", thermalStateString);
    
    if (processInfo.lowPowerModeEnabled) {
        NSLog(@"low Power Mode Enabled!");
    } else {
        NSLog(@"low Power Mode disabled!");
    }
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    NSLog(@"battery level is %3f", [[UIDevice currentDevice] batteryLevel]);
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceBatteryLevelDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"fuck"]);
        NSLog(@"battery level is %3f", [[UIDevice currentDevice] batteryLevel]);
    }];
    
    id activity = [processInfo beginActivityWithOptions:NSActivityIdleSystemSleepDisabled reason:@"需要一直执行"];
    
    
    // TODO:Resource
    [[NSBundle allBundles] enumerateObjectsUsingBlock:^(NSBundle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"image path is %@", [obj pathForResource:@"share_qq" ofType:@"png"]);
    }];
    
    NSBundle *WGPlatformResourcesBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"WGPlatformResources" ofType:@"bundle"]] ;
    NSLog(@"nib path is %@", [WGPlatformResourcesBundle pathForResource:@"WGGameWebViewController" ofType:@"nib"]);
    NSLog(@"image path is %@", [WGPlatformResourcesBundle pathForResource:@"share_qq" ofType:@"png" inDirectory:@"WebViewResources"]);
    NSLog(@"image url is %@", [WGPlatformResourcesBundle URLForResource:@"share_qq" withExtension:@"png" subdirectory:@"WebViewResources"]);
    
    NSLog(@"%@", WGPlatformResourcesBundle.resourceURL);
    NSLog(@"%@", [NSBundle mainBundle].resourceURL);
    NSLog(@"%@", [NSBundle mainBundle].executablePath);
    NSLog(@"%@", [NSBundle mainBundle].sharedFrameworksPath);
    NSLog(@"%@", [NSBundle mainBundle].bundleIdentifier);
    NSLog(@"%@", WGPlatformResourcesBundle.bundleIdentifier);
    NSLog(@"%@", [NSBundle mainBundle].infoDictionary);
    NSLog(@"%@", [[NSBundle mainBundle] executableArchitectures]);
    
    [o1 startRequestResources];
    
    
    // Loading Code from a Bundle
    NSError *error = nil;
    NSLog(@"%d", [[NSBundle mainBundle] preflightAndReturnError:&error]);
    //load、unload、loaded
    // iOS9之后的按需加载资源, 使用NSBundleResourceRequest类
    //https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/#//apple_ref/doc/uid/TP40015083-CH2-SW1
    
    // TODO: Notification
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
//    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"operation");
//    }];
    
//    NSInvocation *invocation = [[NSInvocation alloc] init];
//    [invocation setTarget:o1];
//    [invocation setSelector:@selector(notificationMethod)];
//    NSOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
//    [operationQueue addOperation:operation];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"test" object:o1 queue:operationQueue usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"*********");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:o1 selector:@selector(notificationMethod) name:@"test" object:nil];
    NSNotificationQueue *notificationQueue = [[NSNotificationQueue alloc] initWithNotificationCenter:[NSNotificationCenter defaultCenter]];
    NSNotification *notification = [NSNotification notificationWithName:@"test" object:o1];
    // 方法一：
    [notificationQueue enqueueNotification:notification postingStyle:NSPostASAP];
    // 方法二：
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //TODO: App Extension Support
    
    // TODO: Errors and Exceptions
    // You create assertions only using the assertion macros—you rarely need to invoke NSAssertionHandler methods directly
    // Each thread has its own NSAssertionHandler object
    // NSAssert方法族中的函数，只能在OC的方法中调用
    NSString *cAssertString = @"yoyoyo";
    NSCAssert(cAssertString, @"fuck C Assert!");
    // NSCAssert方法族中的函数，只能在C的方法中调用
    NSCParameterAssert(argc < 5);//方法中检查参数
    // NSLog  & NSLogv to Apple System Log facility
    //  TODO: Scripting Support - Only for Mac
    
#pragma mark - Files And Data Persistence
    
    // TODO: File System
    NSLog(@"temp dir is %@", [[NSFileManager defaultManager] temporaryDirectory]);
    NSLog(@"temp dir is %@", NSTemporaryDirectory());
    NSLog(@"temp dir is %@", NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES));
    NSLog(@"home dir is %@", NSHomeDirectory());
    
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithURL:[NSURL URLWithString:NSHomeDirectory()] options:NSFileWrapperReadingImmediate error:nil];
    NSLog(@"%d", fileWrapper.directory); //  TODO: ?
    
    // Objects that allow the user to view or edit the content of files or directories should adopt the NSFilePresenter protocol. You use file presenters in conjunction with an NSFileCoordinator object to coordinate access to a file or directory among the objects of your application and between your application and other processes. When changes to an item occur, the system notifies objects that adopt this protocol and gives them a chance to respond appropriately
    // NSFilePresenter Protocol
    // NSFileCoordinator Class
    // NSFileAccessIntent Class
    // UIDocument
    
    
    // TODO: Archives and Serialization
    // Convert objects and values to and from property list, JSON, and other flat binary representations.
    
    //  TODO: Preferences
    // Values returned from NSUserDefaults are immutable, even if you set a mutable object as the value.
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"observer user default change"];
    
    // An iCloud-based container of key-value pairs you use to share data among instances of your app running on a user's connected devices.
    [[NSUbiquitousKeyValueStore defaultStore] setObject:@"" forKey:@"fuck store"];
    
    // TODO:  Spotlight
    // 搜索本地设备上的文件和其他项目，并将应用程序的内容索引化以进行搜索
    //    NSMetadataQuery
    //    NSMetadataQueryDelegate
    //    NSMetadataItem

#pragma mark - Networking
    // TODO: URL Loading System
    // The URL Loading System provides access to resources identified by URLs, using standard protocols like https or custom protocols you create. Loading is performed asynchronously, so your app can remain responsive and handle incoming data or errors as they arrive.
    // You use a NSURLSession instance to create one or more NSURLSessionTask instances, which can fetch and return data to your app, download files, or upload data and files to remote locations. To configure a session, you use a NSURLSessionConfiguration object, which controls behavior like how to use caches and cookies, or whether to allow connections on a cellular network.
    // You can use one session repeatedly to create tasks
    
    // TODO: Bonjour
    // 局域网内服务的发现和交互
    // NSNetService NSNetServiceDelegate
    // NSNetServiceBrowser NSNetServiceBrowserDelegate

#pragma mark - Low-Level Utilities
    // TODO:XPC， to look XPCDemo.git
    // Manage secure interprocess communication.
    // NSXPCProxyCreating NSXPCConnection NSXPCInterface
    
    // TODO: Run Time,  to look RuntimeDemo.git
    // refrence RunTimeDemo
    // NSProxy 一个抽象超类，它定义了一个对象的API，作为其他对象或者还不存在的对象的替身。
    
    // TODO: Processes and Threads, look above
    // NSRunLoop NSThread NSLock
 /*
    NSLock *lock = [NSLock new];
//    NSLock *lock = nil;
    [[[NSThread alloc] initWithBlock:^{
        [lock lock];
        //thread A
        for (int i = 0; i < 10000; i ++) {
            if (i % 2 == 0) {
                threadArray = @[@"1", @"2", @"3"];
            }
            else {
                threadArray = @[@"1"];
            }
            NSLog(@"Thread A: %@\n",threadArray);
        }
        [lock unlock];
        
    }] start];
    
        [[[NSThread alloc] initWithBlock:^{
             [lock lock];
            //thread B
            for (int i = 0; i < 10000; i ++) {
                if (threadArray.count >= 2) {
                    [threadArray objectAtIndex:1];
                }
                NSLog(@"Thread B: %@\n", threadArray);
            }
            [lock unlock];
        }] start];
    */
    // 以下3个线程对threadIntNum进行累加操作，但是未必结果是： 10000 +  10000 + 10000，则证明出现了线程不安全
    [[[NSThread alloc] initWithBlock:^{
        @synchronized(o1) { //  对o1的内存实例上锁操作
            //thread A
            for (int i = 0; i < 10000; i ++) {
                o1.threadIntNum = o1.threadIntNum + 1; // 这一步并非是原子操作
            }
            NSLog(@"Thread A: %ld\n", (long)o1.threadIntNum);
        }
    }] start];
    
    [[[NSThread alloc] initWithBlock:^{
        @synchronized(o1) { //  对o1的内存实例上锁操作
            //thread B
            for (int i = 0; i < 10000; i ++) {
                o1.threadIntNum = o1.threadIntNum + 1; // 这一步并非是原子操作
            }
            NSLog(@"Thread B: %ld\n", (long)o1.threadIntNum);
        }
    }] start];
    
    [[[NSThread alloc] initWithBlock:^{
        @synchronized(o1) { //  对o1的内存实例上锁操作
            //thread C
            for (int i = 0; i < 10000; i ++) {
                o1.threadIntNum = o1.threadIntNum + 1; // 这一步并非是原子操作
            }
            NSLog(@"Thread C: %ld\n", (long)o1.threadIntNum);
        }
    }] start];
    
    // dead lock demo
    // 死锁是因为多线程访问共享资源，由于访问的顺序不当所造成的
    //通常是一个线程锁定了一个资源A，而又想去锁定资源B；
    //在另一个线程中，锁定了资源B，而又想去锁定资源A以完成自身的操作;
    //两个线程都想得到对方的资源，而不愿释放自己的资源，造成两个线程都在等待，而无法执行的情况。
    NSLog(@"1"); // 任务1
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2"); // 任务2
    });
    NSLog(@"3"); // 任务3
    
    // TODO: Streams, Sockets, and Ports
    // Streams NSPipe NSPort
    
    [processInfo endActivity:activity];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
//    - (void)loadBundle:(id)sender
//    {
//        Class exampleClass;
//        id newInstance;
//        NSString *path = @"/tmp/Projects/BundleExample/BundleExample.bundle";
//        NSBundle *bundleToLoad = [NSBundle bundleWithPath:path];
//        if (exampleClass = bundleToLoad.principalClass) {
//            newInstance = [[exampleClass alloc] init];
//            [newInstance doSomething];
//        }
//    }
