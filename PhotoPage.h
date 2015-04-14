//
//  PhotoPage.h


#import <UIKit/UIKit.h>

@interface PhotoPage : UIScrollView <UIScrollViewDelegate>


- (void)cancelZooming;

- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)img;
- (void)loadImageWithURL:(NSURL *)url;
@end
