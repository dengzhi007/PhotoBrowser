//
//  PhotoBrowser.m

static const CGFloat PADDING = 20.0;  //两图片间的间距
static const CGFloat DURATION = 0.5;  //图片显示过程的动画时间
static const NSInteger ROWPICCOUNT = 3;  //tableview每行显示的图片个数

#import "PhotoBrowser.h"
#import "PhotoPage.h"

@interface PhotoBrowser ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end


@implementation PhotoBrowser

#pragma mark -- lazy loading
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        CGRect frame = self.frame;
        frame.size.width = frame.size.width + PADDING;
        frame.origin.x = - PADDING * 0.5;
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.tag = -1;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(frame.size.width * self.imageCount, frame.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.backgroundColor = [UIColor blackColor];
        
        for (int i = 0; i < self.imageCount; i++) {
            CGRect frame = self.frame;
            frame.origin.x = (frame.size.width + PADDING) * i + PADDING * 0.5;
            PhotoPage *page = [[PhotoPage alloc]initWithFrame:frame];
            page.tag = i;
            [_scrollView addSubview:page];
            
            if (i == self.currentImageIndex) {
                [page loadImageWithURL:[self highQualityImageURLForIndex:i] placeholderImage:[self placeholderImageForIndex:i]];
            }
            
        }
        
        //单击隐藏
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];

    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        CGRect frame = CGRectMake([[UIScreen mainScreen] bounds].size.width * 0.5 - 30, [[UIScreen mainScreen] bounds].size.height - 50, 60, 10);
        _pageControl = [[UIPageControl alloc]initWithFrame:frame];
        _pageControl.numberOfPages = self.imageCount;
        _pageControl.currentPage = self.currentImageIndex;
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (UIButton *)saveBtn {
    if (_saveBtn == nil) {
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, [[UIScreen mainScreen] bounds].size.height - 60, 30, 30)];
    }
    return _saveBtn;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(60, [[UIScreen mainScreen] bounds].size.height - 60, 30, 30)];
    }
    return _deleteBtn;
}

- (void)setShowSaveButton:(BOOL)showSaveButton {
    if (showSaveButton) {
        [self addSubview:self.saveBtn];
    }else{
        [self.saveBtn removeFromSuperview];
    }
}

- (void)setShowDeleteButton:(BOOL)showDeleteButton {
    if (showDeleteButton) {
        [self addSubview:self.deleteBtn];
    }else{
        [self.deleteBtn removeFromSuperview];
    }
}
#pragma mark -- custom

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    [self addSubview:self.scrollView];
    [self browserWillShow];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * self.currentImageIndex, 0) animated:NO];
    [self addSubview:self.pageControl];
}

//显示之前的动画
- (void)browserWillShow {
    if (self.sourceImagesContainerView == nil) {
        return;
    }
    
    self.scrollView.hidden = YES;
    
    UIImageView *sourceView = nil;
    CGRect rect = CGRectZero;
    if ([self.sourceImagesContainerView class] == [UITableView class]) {
        UITableView *tableView = (UITableView *)self.sourceImagesContainerView;
        NSInteger row = self.currentImageIndex / ROWPICCOUNT;
        NSInteger tag = self.currentImageIndex % ROWPICCOUNT + 1;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        sourceView = (UIImageView *)[cell viewWithTag:tag];
        rect = [cell.contentView convertRect:sourceView.frame toView:self];
    }else{
        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
        rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = [UIColor clearColor];
    [self addSubview:imgView];
    imgView.image = sourceView.image;
    
    
    [UIView animateWithDuration:DURATION animations:^{
        [imgView setFrame:self.frame];
    } completion:^(BOOL finished) {
        if (finished) {
            self.scrollView.hidden = NO;
            [imgView removeFromSuperview];
            
        }
    }];

}

//消失之前的动画
- (void)dismiss {
    if (self.sourceImagesContainerView == nil) {
        [self removeFromSuperview];
        return;
    }
    self.scrollView.hidden = YES;
    
    UIImageView *destView = nil;
    CGRect rect = CGRectZero;
    if ([self.sourceImagesContainerView class] == [UITableView class]) {
        UITableView *tableView = (UITableView *)self.sourceImagesContainerView;
        NSInteger row = self.currentImageIndex / ROWPICCOUNT;
        NSInteger tag = self.currentImageIndex % ROWPICCOUNT + 1;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        destView = (UIImageView *)[cell viewWithTag:tag];
        rect = [cell.contentView convertRect:destView.frame toView:self];
    }else{
        destView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
        rect = [self.sourceImagesContainerView convertRect:destView.frame toView:self];
    }

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.frame];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = [UIColor clearColor];
    [self addSubview:imgView];
    imgView.image = [self placeholderImageForIndex:self.currentImageIndex];    
    
    [UIView animateWithDuration:DURATION animations:^{
        [imgView setFrame:rect];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
        
    }];
    
}



- (void)savePhoto {
    UIImageView *imgView = (UIImageView *)[self.scrollView viewWithTag:self.currentImageIndex];
    UIImageWriteToSavedPhotosAlbum(imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}


#pragma mark - scrollview deleate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    if (index < 0 || index >= self.imageCount) {
        return;
    }
    
    if (index != self.currentImageIndex) {
        PhotoPage *page = (PhotoPage *)[scrollView viewWithTag:self.currentImageIndex];
        [page cancelZooming];
        
        self.currentImageIndex = index;
        self.pageControl.currentPage = index;
        page = (PhotoPage *)[scrollView viewWithTag:index];
        [page loadImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    }
    
    
}


@end
