# Photo Browser for iOS
如何使用：
PhotoBrowser *browser = [[PhotoBrowser alloc] init];
browser.sourceImagesContainerView = self.tableView; // 原图的父控件
browser.imageCount = self.albumPhotos.count; // 图片总数
browser.currentImageIndex = imgView.index;
browser.delegate = self;
[browser show];

self实现PhotoBrowserDelegate
#pragma mark - photo browser delegate
- (UIImage *)photoBrowser:(PhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return imgView.image;
}

- (NSURL *)photoBrowser:(PhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:url];
}
