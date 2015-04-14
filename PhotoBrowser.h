//
//  PhotoBrowser.h


#import <UIKit/UIKit.h>

@class PhotoBrowser;

@protocol PhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(PhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(PhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface PhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;   //图片的父视图 或者图片所在的tableview ，如果按tableview排列，则需要指定每行cell的图片个数，并且按tag区分
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic) BOOL showSaveButton;
@property (nonatomic) BOOL showDeleteButton;

@property (nonatomic, weak) id<PhotoBrowserDelegate> delegate;

- (void)show;
@end
