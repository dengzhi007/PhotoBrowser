//
//  PhotoPage.m


#import "PhotoPage.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoPage ()
@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic)BOOL hasLoadedImage;
@end

@implementation PhotoPage

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentSize = frame.size;
        self.maximumZoomScale = 2.0;
        self.minimumZoomScale = 0.6;
        self.directionalLockEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;
        _imgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imgView];
    }
    return self;
}



- (void)cancelZooming {
    [self setZoomScale:1.0 animated:YES];
}


- (void)loadImageWithURL:(NSURL *)url {
    [_imgView setImageWithURL:url];
}

- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)img {
    if (_hasLoadedImage) {
        return;
    }
    
    [_imgView setImageWithURL:url placeholderImage:img];
    
    _hasLoadedImage= YES;
}


#pragma mark - scrollview deleate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imgView;
}

@end
