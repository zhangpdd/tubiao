//
//  ViewController.m
//  demo
//
//  Created by zhang peng on 2016/12/17.
//  Copyright © 2016年 zhangpeng. All rights reserved.
//

#import "ViewController.h"
#import "demo-Bridging-Header.h"
#import "Masonry.h"

@interface ViewController () <ChartViewDelegate>

@property (strong , nonatomic) BarChartView *barChartView;

@property (nonatomic, strong) LineChartView *lineChartView;

@property (strong , nonatomic) NSArray *colorArray;

@property (strong , nonatomic) NSArray *xTitles;
@end


@implementation ViewController

#pragma mark - getter and setter


-(LineChartView *)lineChartView
{
    if (_lineChartView == nil) {
        
        _lineChartView = [[LineChartView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height - 10)];
        _lineChartView.delegate=self;

        
    }
    return _lineChartView;
}
- (NSArray *)colorArray
{
    if (_colorArray == nil) { //橘黄色  蓝色 淡绿色 浅紫色 浅红色
        _colorArray = @[ [UIColor orangeColor], [UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor lightGrayColor]];
    }
    return _colorArray;
}
- (NSArray *)xTitles
{
    if (_xTitles == nil) {
        
        _xTitles = @[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周"];
    }
    return _xTitles;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    BarChartView *chatView = [[BarChartView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height - 10)];
//    [self.view addSubview:chatView];
    
    self.colorArray=[NSArray arrayWithObjects:[UIColor orangeColor],[UIColor blueColor],[UIColor greenColor], nil];
    
    
    self.barChartView = [[BarChartView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height - 10)];
    [self.view addSubview:self.barChartView];
    
    //[self zhuxing];
    
    
    [self.view addSubview:self.lineChartView];
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(10, 20, 10, 10));
    }];
    [self setData];
    
    //[self zhexian];
}

-(void)zhuxing
{
    NSArray *array = @[@"17655.2", @"20939.38", @"36271.65", @"30353.48", @"26874.45", @"23715.13", @"24367.3", @"23408.85", @"24016.9", @"31424.75", @"26744.25", @"26307.8"];
    NSArray *array1 = @[@"17077.85", @"18197.63", @"29818.3", @"26785.3", @"26273.75", @"22973.3", @"23457.4", @"25208.25", @"27054.9", @"32088.15", @"24960.65", @"31157.2"];
    NSArray *array2= @[@"20155.2", @"19874.18", @"32059.85", @"25786.1", @"28643.8", @"26407.05", @"23894.45", @"23832.1", @"28999.18", @"35795.8", @"16169.15", @"--"];
    NSMutableArray *valueArray = [NSMutableArray array];
    [valueArray addObject:array];
    [valueArray addObject:array1];
    [valueArray addObject:array2];
    
    double dataSetMin = 0;
    double dataSetMax = 0;
    float groupSpace = 0.25f;
    float barSpace = 0.0f;
    float barWidth = 0.25f;
    
    /* (barSpace + barWidth) * 系列数 + groupSpace = 1.00 -> interval per "group"
     groupSpace
     groupSpace -- 组的间隔
     barSpace -- 每组之间柱状图的间隔
     barWidth -- 每组柱状图的宽度
     */
    
    NSMutableArray *dataSets = [NSMutableArray array];
    
    for (int i = 0; i < valueArray.count; i++) {
        NSMutableArray *yVals = [NSMutableArray array];
        BarChartDataSet *set = nil;
        NSArray *array = valueArray[i];
        for (int j = 0; j < array.count; j++)
        {
            double val = [array[j] doubleValue];
            dataSetMax = MAX(val, dataSetMax);
            dataSetMin = MIN(val, dataSetMin);
            [yVals addObject:[[BarChartDataEntry alloc]
                              initWithX:j
                              y:val]];
            set = [[BarChartDataSet alloc] initWithValues:yVals label:[NSString stringWithFormat:@"第%d个图例",i]];
            [set setColor:self.colorArray[i]];
            set.valueColors = @[self.colorArray[i]];
        }
        [dataSets addObject:set];
    }
    double diff = dataSetMax - dataSetMin;
    
    if (dataSetMax == 0 && dataSetMin == 0) {
        dataSetMax = 100.0;
        dataSetMin = -10.0;
    } else {
        dataSetMax = (dataSetMax + diff * 0.2);
        dataSetMin = (dataSetMin - diff * 0.1);
    }
    self.barChartView.leftAxis.axisMaximum = dataSetMax;
    self.barChartView.leftAxis.axisMinimum = 0;
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont systemFontOfSize:10.f]];
    data.barWidth = barWidth;
    _barChartView.xAxis.axisMinimum = -0.1;
    _barChartView.xAxis.axisMaximum = 0 + [data groupWidthWithGroupSpace:groupSpace barSpace: barSpace] * 12;
    [data groupBarsFromX: 0 groupSpace: groupSpace barSpace: barSpace];
    
    _barChartView.data = nil;
    _barChartView.data = data;
    
     [self.barChartView animateWithXAxisDuration:0.25f];
}


- (void)setData
{
    NSArray *array = @[@"5553.8", @"5959.3", @"1961.7", @"<null>", @"<null>"];
    NSArray *array1 = @[@"998.5", @"1014.5", @"249", @"<null>", @"<null>"];
    NSMutableArray *valueArray = [NSMutableArray array];
    [valueArray addObject:array];
    [valueArray addObject:array1];
    
    NSMutableArray *dataSets = [NSMutableArray array];
    double leftAxisMin = 0;
    double leftAxisMax = 0;
    for (int i = 0; i < valueArray.count; i++) {
        
        NSArray *values = valueArray[i];
        NSMutableArray *yVals = [NSMutableArray array];
        NSString *legendName = [NSString stringWithFormat:@"第%d个图例", i];
        for (int i = 0; i < values.count; i++)
        {
            NSString *valStr = [NSString stringWithFormat:@"%@", values[i]];
            double val = [valStr doubleValue];
            leftAxisMax = MAX(val, leftAxisMax);
            leftAxisMin = MIN(val, leftAxisMax);
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
            [yVals addObject:entry];
        }
        
        LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:yVals label:legendName];
        dataSet.lineWidth = 3.0f;//折线宽度
        dataSet.drawValuesEnabled = YES;//是否在拐点处显示数据
        dataSet.valueColors = @[self.colorArray[i]];//折线拐点处显示数据的颜色
        [dataSet setColor:self.colorArray[i]];//折线颜色
        dataSet.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        dataSet.drawCirclesEnabled = NO;//是否绘制拐点
        dataSet.circleRadius = 3.0f;//拐点半径
        dataSet.axisDependency = AxisDependencyLeft;
        dataSet.drawCircleHoleEnabled = YES;//是否绘制中间的空心
        dataSet.circleHoleRadius = 1.0f;//空心的半径
        dataSet.circleHoleColor = self.colorArray[i];//空心的颜色
        dataSet.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
        dataSet.highlightColor = [UIColor clearColor];
        dataSet.valueFont = [UIFont systemFontOfSize:12];
        [dataSets addObject:dataSet];
    }
    double leftDiff = leftAxisMax - leftAxisMin;
    if (leftAxisMax == 0 && leftAxisMin == 0) {
        leftAxisMax = 100.0;
        leftAxisMin = -10.0;
    } else {
        leftAxisMax = (leftAxisMax + leftDiff * 0.2);
        leftAxisMin = (leftAxisMin - leftDiff * 0.1);
    }
    self.lineChartView.leftAxis.axisMaximum = leftAxisMax;
    self.lineChartView.leftAxis.axisMinimum = leftAxisMin;
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    self.lineChartView.data = nil;
    self.lineChartView.xAxis.axisMinimum = -0.8;
    self.lineChartView.xAxis.axisMaximum = 5.1;
    self.lineChartView.data = data;
    [self.lineChartView animateWithXAxisDuration:0.3f];
    
    //x轴数据源方法
    //lineChartView.xAxis.valueFormatter = target;
    //这句话如果设置了，就必须实现x轴的数据源方法
    //self.lineChartView.xAxis.valueFormatter = self;
}


//- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
//{
//    return self.xTitles[(int)value % self.monthTitles.count];
//}
//xTitles就是你需要在x轴展现的标题数组，赋值就这么写就好，别问为什么，英语好的点进去看看就知道了，四级过了英语就不看了。


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
