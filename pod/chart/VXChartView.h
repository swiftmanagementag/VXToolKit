
#import <UIKit/UIKit.h>
#import "VXChartAxis.h"
#import "VXChartSeries.h"
#import "VXChartMarker.h"

@class VXChartView;

@protocol VXChartViewDataSource<NSObject>

@required

- (NSUInteger)numberOfSeries:(VXChartView *)graphView ;
- (NSUInteger)numberOfValuesForSeries:(VXChartView *)graphView withSeriesIndex:(NSUInteger)seriesIndex;
- (NSNumber *)numberForSeries:(VXChartView *)graphView withSeriesIndex:(NSUInteger)seriesIndex field:(NSUInteger)fieldEnum valueIndex:(NSUInteger)index; 

@optional
- (UIColor *)colorForSeries:(VXChartView *)pGraphView withSeriesIndex:(NSUInteger)pSeriesIndex field:(NSUInteger)pFieldEnum valueIndex:(NSUInteger)pIndex; 

@end

typedef NS_ENUM(NSInteger, VXChartType) {
	kChartUndefined = -1,
	kChartLine = 0,
	kChartBar = 1
} ;

@interface VXChartView : UIView {}

@property (nonatomic, unsafe_unretained) IBOutlet id<VXChartViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, strong) IBOutlet VXChartAxis *axisX;
@property (nonatomic, strong) IBOutlet VXChartAxis *axisY;

@property (nonatomic, strong) NSMutableDictionary *series;
@property (nonatomic, strong) NSMutableDictionary *markers;

@property (nonatomic, assign) VXChartType type;

@property (nonatomic, assign) BOOL gradient;

- (void)addSeries:(NSInteger)pIndex withSeries:(VXChartSeries *)pSeries;
- (void)addMarker:(NSInteger)pIndex withMarker:(VXChartMarker *)pMarker;
- (void)reloadData;
- (void)setToLandscape;
- (void)setToPortrait;
- (void)drawSeries:(NSUInteger)pSeries;
- (void)initializeComponent;

@end
