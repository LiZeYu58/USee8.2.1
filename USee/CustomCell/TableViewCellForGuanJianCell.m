//
//  TableViewCellForGuanJianCell.m
//  LOSBi
//
//  Created by JJT on 16/9/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForGuanJianCell.h"

//<ChartViewDelegate,IChartAxisValueFormatter>
@interface TableViewCellForGuanJianCell ()
{
    
    UIView *line1;
    NSArray *yAxisValueArray;
    NSMutableArray *chartXAxisArray;
    NSInteger count;
    
}

@end

@implementation TableViewCellForGuanJianCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithArr1:(NSMutableArray *)arr1 WithArr2:(NSMutableArray *)arr2 WithArr3:(NSMutableArray *)arr3{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        @try {
         
            yAxisValueArray = arr1;
            count = 0;
            
            _xValueArray = [NSMutableArray new];
            
            _xValueArray = arr3;
            
            
            _upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20 * SCREEN_W_SP, 260 * SCREEN_H_SP- 10 * SCREEN_H_SP)];
            
            _upView.layer.borderColor = [UIColor colorWithHex:0xd2d2d2].CGColor;
            
            _upView.layer.borderWidth = 1;
            
            [self.contentView addSubview:_upView];
            
            
            _upView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _upView.frame.size.width, 34 * SCREEN_H_SP)];
            
            _upView1.backgroundColor = [UIColor colorWithHex:0xba2932];
            
            [_upView addSubview:_upView1];
            
            
            
            _uplLab = [[UILabel alloc]initWithFrame:CGRectMake(10* SCREEN_W_SP,0, 100 * SCREEN_W_SP, _upView1.frame.size.height)];
            
            _uplLab.textAlignment = NSTextAlignmentLeft;
            
            _uplLab.textColor = [UIColor whiteColor];
            
            [_upView1 addSubview:_uplLab];
            
            
            
            _uprLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 * SCREEN_W_SP - 150 * SCREEN_W_SP,0, 110 * SCREEN_W_SP, _upView1.frame.size.height)];
            
            _uprLab.textAlignment = NSTextAlignmentRight;
            
            _uprLab.textColor = [UIColor whiteColor];
            
            [_upView1 addSubview:_uprLab];
            
            
            
            _uprLab1 = [[UILabel alloc]initWithFrame:CGRectMake(_uprLab.frame.origin.x + _uplLab.frame.size.width + 20 * SCREEN_W_SP,0, 40 * SCREEN_W_SP, _upView1.frame.size.height)];
            
            _uprLab1.textAlignment = NSTextAlignmentLeft;
            
            _uprLab1.textColor = [UIColor whiteColor];
            
            [_upView1 addSubview:_uprLab1];
            
            
//            _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP,54 * SCREEN_H_SP, SCREEN_WIDTH - 40 * SCREEN_W_SP , 186 * SCREEN_H_SP)];
//
//            [_upView addSubview:_chartView];
//
//
//            _chartView.legend.enabled = NO;
//
//            _chartView.delegate = self;
//
//
//            _chartView.autoScaleMinMaxEnabled = NO;
//            [_chartView fitScreen];
//            _chartView.contentScaleFactor = 1;
//            _chartView.scaleXEnabled = NO;
//            _chartView.scaleYEnabled = NO;
//            _chartView.multipleTouchEnabled = NO;
//            _chartView._doubleTapGestureRecognizer = NULL;
//            _chartView.dragEnabled = NO;
//            _chartView.dragDecelerationEnabled = NO;
//
//            _chartView.descriptionText = @"";
//            _chartView.noDataTextDescription = @"You need to provide data for the chart.";
//
//            _chartView.dragEnabled = NO;
//            [_chartView setScaleEnabled:NO];
//            _chartView.drawGridBackgroundEnabled = NO;
//            _chartView.pinchZoomEnabled = NO;
//            _chartView.legend.form = ChartLegendFormLine;
//            _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
//            _chartView.legend.textColor = UIColor.whiteColor;
//            _chartView.legend.position = ChartLegendPositionBelowChartLeft;
//
//
//            ChartXAxis *xAxis = _chartView.xAxis;
//            xAxis.labelFont = [UIFont systemFontOfSize:11.f];
//            xAxis.labelPosition = XAxisLabelPositionBottom; // x轴下方显示数字
//            xAxis.valueFormatter = self;
//
//            xAxis.labelTextColor = [UIColor grayColor];
//            xAxis.drawGridLinesEnabled = NO;
//            xAxis.drawAxisLineEnabled = NO;
//
//
//            NSNumberFormatter * rightAxisFormatter = [[NSNumberFormatter alloc] init];
//            rightAxisFormatter.minimumFractionDigits = 0.0;
//            rightAxisFormatter.maximumFractionDigits = 1.0;
//            rightAxisFormatter.minimumIntegerDigits = 1;
//
//
//            ChartYAxis *leftAxis = _chartView.rightAxis;
//            leftAxis.labelTextColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
//            [leftAxis setLabelCount:3 force:YES];
//            [leftAxis set_customAxisMax:YES];
//            leftAxis.labelTextColor = [UIColor grayColor];
//            //        [leftAxis setDecimals:0.0];
//            leftAxis.axisMinimum = 0.0;
//            //  leftAxis.valueFormatter = self;
//            leftAxis.drawGridLinesEnabled = NO;
//            leftAxis.drawZeroLineEnabled = NO;
//            leftAxis.granularityEnabled = YES;
//            leftAxis.drawAxisLineEnabled = NO; //去掉left线
//            leftAxis.spaceTop = 0.15;
//
//            leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:rightAxisFormatter];
//
//
//
//
//            ChartYAxis *rightAxis = _chartView.leftAxis;
//            rightAxis.labelTextColor = UIColor.redColor;
//            //    rightAxis.axisMaximum = 900.0;
//            //    rightAxis.axisMinimum = -200.0;
//            rightAxis.drawGridLinesEnabled = NO;
//            rightAxis.granularityEnabled = NO;
//            rightAxis.labelFont = [UIFont systemFontOfSize:11];
//
//            _chartView.leftAxis.enabled = NO; //去除右边线
            
            [self UplineChartDataSetWithValues1:arr1 WithValues2:arr2];
            
            //自定制折线图背景三条线（中间是虚线）
//            ChartLimitLine * downLine = [[ChartLimitLine alloc]initWithLimit:[chartXAxisArray[0] doubleValue]];
//            downLine.lineWidth = 1.0;
//            downLine.lineColor = Color(140, 140, 140);
//            ChartLimitLine * topLine = [[ChartLimitLine alloc]initWithLimit:[chartXAxisArray[2] doubleValue]];
//            topLine.lineWidth = 0.8;
//            topLine.lineColor = Color(130, 130, 130);
//            ChartLimitLine * midLine = [[ChartLimitLine alloc]initWithLimit:[chartXAxisArray[1] doubleValue]];
//            midLine.lineWidth = 0.5;
//            midLine.lineColor = Color(130, 130, 130);
//            [midLine setLineDashLengths:@[[NSNumber numberWithInt:2], [NSNumber numberWithInt:1]]];
//            [leftAxis addLimitLine:midLine];
//            [leftAxis addLimitLine:downLine];
//            [leftAxis addLimitLine:topLine];

        } @catch (NSException *exception) {
            
             [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
            
        } @finally {
            
        }
      }
    return self;

}


#pragma mark - 上部表数据
- ( void)UplineChartDataSetWithValues1:(NSArray <NSNumber *>*)values1 WithValues2:(NSArray <NSNumber *>*)values2{
    
    @try {
       
        NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
        
        for (int index = 0; index < values1.count; index++)
        {
//            [yVals1 addObject:[[ChartDataEntry alloc] initWithX:index y:values1[index].doubleValue]];
        }
        
//        LineChartDataSet *set1 = nil;
        [line1 removeFromSuperview];
        line1 = nil;
        //    if (_chartView.data.dataSetCount > 0)
        //    {
        //        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        //        set1.values = yVals1;
        //        [_chartView.rightAxis resetCustomAxisMax];
        //        [_chartView.rightAxis setAxisMaxValue:[self reCalculateMaxYValue:[set1 yMax]]];
        //        [_chartView.data notifyDataChanged];
        //        [_chartView notifyDataSetChanged];
        //    }
        //    else
        //    {
//        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:@"DataSet 1"];
//        set1.axisDependency = AxisDependencyRight;
//        [set1 setColor:[UIColor grayColor]];
//        [set1 setCircleColor:[UIColor grayColor]];
//        set1.lineWidth = 1.3;
//        set1.circleRadius = 2.5;
//        set1.fillAlpha = 65/255.0;
//        set1.fillColor = [UIColor greenColor];
//        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//        set1.drawCircleHoleEnabled = NO;
//        set1.drawValuesEnabled = NO;
//        set1.drawHorizontalHighlightIndicatorEnabled = NO;
//        [set1 setHighlightEnabled:YES];
//
//        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//        [dataSets addObject:set1];
//
//        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
//        [data setValueTextColor:UIColor.whiteColor];
//        [data setValueFont:[UIFont systemFontOfSize:9.f]];
//
//        if ([set1 yMax] < 2) {
//            double ww = [set1 yMax];
//            if (ww > 1 &&  ww <= 2) {
//                ww = 2;
//            }
//            else if (ww <= 1){
//                ww = 1;
//            }
//            [_chartView.rightAxis setAxisMaxValue:ww];
//
//            double a;
//            double b;
//            double c;
//
//            if (ww == 2) {
//                a = 0;
//                b = 1;
//                c = 2;
//            }
//            else if (ww == 1){
//                a = 0;
//                b = 0.5;
//                c = 1;
//            }
//
//            //自定制折线图背景三条线（中间是虚线）
//            ChartLimitLine * downLine = [[ChartLimitLine alloc]initWithLimit:a];
//            downLine.lineWidth = 1.0;
//            downLine.lineColor = Color(140, 140, 140);
//            ChartLimitLine * topLine = [[ChartLimitLine alloc]initWithLimit:c];
//            topLine.lineWidth = 0.8;
//            topLine.lineColor = Color(130, 130, 130);
//            ChartLimitLine * midLine = [[ChartLimitLine alloc]initWithLimit:b];
//            midLine.lineWidth = 0.5;
//            midLine.lineColor = Color(130, 130, 130);
//            [midLine setLineDashLengths:@[[NSNumber numberWithInt:2], [NSNumber numberWithInt:1]]];
//            [_chartView.rightAxis addLimitLine:midLine];
//            [_chartView.rightAxis addLimitLine:downLine];
//            [_chartView.rightAxis addLimitLine:topLine];
//
//        }
//        else
//        {
//            [_chartView.rightAxis resetCustomAxisMax];
//
//              CGFloat sssddd = [set1 yMax];
//            [_chartView.rightAxis setAxisMaxValue:[self reCalculateMaxYValue:sssddd]];
//
//        }
//
//        CGFloat maxWidth = 0.0;
//        for (NSString *yValue in chartXAxisArray) {
//            CGFloat messageWidth = [yValue boundingRectWithSize:CGSizeMake(_chartView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.width;
//            maxWidth = messageWidth > maxWidth ? messageWidth : maxWidth;
//        }
//
//        line1 = [[UIView alloc]init];
//        line1.backgroundColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//        [_chartView addSubview:line1];
//        if ([set1 yMax] < 5) {
//            if ([set1 yMax] <= 1 && [set1 yMax] > -10) {
//                line1.frame = CGRectMake(_chartView.width - 18 * SCREEN_W_SP - maxWidth - 7, 10,0.5, _chartView.frame.size.height - 30 * SCREEN_H_SP);
//            }
//            else if (([set1 yMax] <= 2 && [set1 yMax] > 1) || ([set1 yMax] <= 4 && [set1 yMax] > 3)){
//                 line1.frame = CGRectMake(_chartView.width - 12 * SCREEN_W_SP - maxWidth, 10,0.5, _chartView.frame.size.height - 30 * SCREEN_H_SP);
//            }
//            else{
//                line1.frame = CGRectMake(_chartView.width - 14 * SCREEN_W_SP - maxWidth + 5, 10,0.5, _chartView.frame.size.height - 30 * SCREEN_H_SP);
//            }
//
//        }
//        else
//        {
//
//            line1.frame = CGRectMake(_chartView.width - 7.75 * SCREEN_W_SP - maxWidth, 10,0.5, _chartView.frame.size.height - 30 * SCREEN_H_SP);
//        }
//
//        _chartView.data = data;
//        [_chartView setNeedsDisplay];
        //  }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (double)reCalculateMaxYValue:(NSInteger)yMax {
    
    @try {
       
        chartXAxisArray = [NSMutableArray new];
        NSString *yMaxStr = [NSString stringWithFormat:@"%ld", (long)yMax];
        NSInteger leftMath = [[yMaxStr substringToIndex:1] integerValue];
        NSInteger maxYValue = 0;
        if (yMaxStr.length > 2) {   // 超过4位数(万)判断第二位
            NSInteger secondNum = [[yMaxStr substringWithRange:NSMakeRange(1, 1)] integerValue];
            secondNum += 1;
            if (secondNum == 10) {
                leftMath += 1;
                maxYValue = leftMath * pow(10, yMaxStr.length - 1);
            } else {
                maxYValue = leftMath * pow(10, yMaxStr.length - 1) + secondNum * pow(10, yMaxStr.length - 2);
            }
        } else if(yMaxStr.length > 1) { // 4位数以下判断第一位
            maxYValue = (leftMath + 1) * pow(10, yMaxStr.length - 1);
        } else {    //个位数单独处理
            if (yMax > 5) {
                maxYValue = 10;
            } else if(yMax > 1){
                maxYValue = 5;
            }else {
                maxYValue = 1;
            }
        }
        
        [chartXAxisArray addObject:@"0"];
        if (maxYValue <= 5) {
            [chartXAxisArray addObject:[NSString stringWithFormat:@"%.1f", ((double)maxYValue)/2]];
        } else {
            [chartXAxisArray addObject:[NSString stringWithFormat:@"%ld", (long)maxYValue / 2]];
        }
        [chartXAxisArray addObject:[NSString stringWithFormat:@"%ld", (long)maxYValue]];
        
        return maxYValue;

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//    @try {
//
//        line1.hidden = YES;
//        _uprLab.text = yAxisValueArray[(int)highlight.x];
//
//    } @catch (NSException *exception) {
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//
//}
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//
//}
//
//#pragma mark - IChartAxisValueFormatter
//
//- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
//
//    @try {
//
//        NSString *str = [NSString stringWithFormat:@"%f", value];
//
//        if ([axis isKindOfClass:[ChartXAxis class]]) {
//
//            if (_xValueArray.count != 0) {
//
//                NSInteger index = value;
//                str = [NSString stringWithString:_xValueArray[index][@"xAxis"]];
//                return str;
//
//            }else {
//                str = [NSNumber numberWithDouble:value].stringValue;
//                return str;
//            }
//        } else {
//            str = chartXAxisArray[count];
//            count = count < chartXAxisArray.count - 1 ? count + 1 : 0;
//            return str;
//        }
//
//        return str;
//
//    } @catch (NSException *exception) {
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}

@end
