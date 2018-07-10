//
//  GiftViewController.m
//  GifAnimatedImage
//
//  Created by ngmmxh on 2018/7/9.
//  Copyright © 2018年 ngmmxh. All rights reserved.
//

#import "GiftViewController.h"
#import "FLAnimatedImage.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface GiftViewController ()
@property (nonatomic, strong) FLAnimatedImageView  *imageViewGift;

@end

@implementation GiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageViewGift];
    _imageViewGift.backgroundColor = [UIColor redColor];
    // 动态图
    NSString *urlStr = @"https://staticimg.ngmm365.com/0dd3a526e657396c3dfba57799a2e5e4-w750_h336.gif";

    // 普通URL图片
//    NSString *urlStr = @"https://staticimg.ngmm365.com/a36df0aa145f1d897bf1943ceca4a71c-w1920_h1080.jpg";

    [_imageViewGift sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.imageViewGift.backgroundColor = [UIColor clearColor];
        }
    }];
}

-(FLAnimatedImageView *)imageViewGift{
    if (!_imageViewGift) {
        _imageViewGift  = [[FLAnimatedImageView alloc] init];
        _imageViewGift.contentMode =  UIViewContentModeScaleAspectFill;
        _imageViewGift.frame = CGRectMake(15, 100, 200, 300);
    }return _imageViewGift;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
