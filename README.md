#    gifAnimation
今天遇到一个特别好用的GIF加载神器，用sd 的sd_setImageWithURL 方法就可以很轻松的加载普通的网络图片 和网络GIF 图片，功能强大 ，超级赞。名字叫做FLAnimatedImage ，网上的好多方法都是通过官方提供的

## 实现简单方法步骤

1.安装下载

pod 'SDWebImage', '~> 4.4.1'
pod 'SDWebImage/GIF'

2. 实例化对象

​
​
​-(FLAnimatedImageView *)imageViewGift{
​if (!_imageViewGift) {
​_imageViewGift  = [[FLAnimatedImageView alloc] init];
​_imageViewGift.contentMode =  UIViewContentModeScaleAspectFill;
​_imageViewGift.frame = CGRectMake(15, 100, 200, 300);
​}return _imageViewGift;
​}
​3.使用 ，导入头文件#import "SDWebImage/UIImageView+WebCache.h"
​
​这里不管是使用.png  .jpg .gif的类型的都可以直接使用，利用对象，直接像调用sd的方法 ，便可以轻松加载普通图片和gif动态图
​
​- (void)viewDidLoad {
​
​[super viewDidLoad];
​
​[self.view addSubview:self.imageViewGift];
​
​_imageViewGift.backgroundColor = [UIColor redColor];
​
​//gif动态图
​
​//    NSString *urlStr = @"https://staticimg.ngmm365.com/0dd3a526e657396c3dfba57799a2e5e4-w750_h336.gif";
​
​//普通图片
​
​NSString *urlStr = @"https://staticimg.ngmm365.com/a36df0aa145f1d897bf1943ceca4a71c-w1920_h1080.jpg";
​
​[_imageViewGift sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
​
​if (image) {
​self.imageViewGift.backgroundColor = [UIColor clearColor];
​}
​}];
​
​}
​
​## 方法对比（以下为网络资料）
​
​# 简介
​
​FLAnimatedImage 是 Flipboard 团队开发的在它们 App 中渲染 GIF 图片使用的库。 后来 Flipboard 将 FLAnimatedImage 开源出来供大家使用。本文章主要是介绍FLAnimatedImage框架的GIF动画加载和播放流程，旨在说明流程和主要细节点。
​
​## gif渲染原理分析
​
​为什么说 FLAnimatedImage 相对于 iOS 原生的几种 hack 方式更趋近于最佳实践呢？ 咱们简单聊聊 FLAnimatedImage 渲染 GIF 图片的原理。FLAnimatedImage 会有两个线程同时在运转。 其中一个线程负责渲染 GIF 的每一帧的图片内容（所谓的渲染，大体上就是加载 GIF 文件数据，然后抽取出来当前需要哪一帧）。这个加载图片的过程是在异步线程进行的。 
​然后 FLAnimatedImage 会有一个内存区域专门放置这些渲染好的帧。 这时候，在主线程中的 ImageView 会根据当前需要，从这个内存区域中读取相应的帧。这是一个典型的生产者-消费者问题。
​
​## FLAnimatedImage
​
​FLAnimatedImage项目的流程比较简单，FLAnimatedImage就是负责GIF数据的处理，然后提供给FLAnimatedImageView一个UIImage对象。FLAnimatedImageView拿到UIImage对象显示出来就可以了。 
​
​### FLAnimatedImage函数解析
​
​关键方法解析 
​a、对传进来的数据进行合法性判断，至少不能为nil。 
​b、初始化对应的变量，用于存储各类辅助数据。 
​c、将传进来的数据处理成图片数据，其中设置。kCGImageSourceShouldCache为NO,可以避免系统对图片进行缓存。 
​d、从数据中读取图片类型，判断该图片是不是GIF动画类型。 
​e、读取GIF动画中的动画信息，包括动画循环次数，有几帧图片等。 
​f、遍历GIF动画中的所有帧图片，取出并保存帧图片的播放信息，设置GIF动画的封面帧图片 
​g、根据设置或者GIF动画的占用内存大小，与缓存策略对比，确认缓存策略。
​
​网络上的方法都是通过这个方法调用loadAnimatedImageWithURL 这个方法 ，前提是知道网络图片类型是gif ，然后相当于数据源传给 self.imageView3.animatedImage = animatedImage;   创建的FLAnimatedImage View 这个对象
​
​
​
​NSURL *url3 = [NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"];
​[self loadAnimatedImageWithURL:url3 completion:^(FLAnimatedImage *animatedImage) {
​self.imageView3.animatedImage = animatedImage;    self.imageView3.userInteractionEnabled = YES;
​}];
​
​
​-(void)loadAnimatedImageWithURL:(NSURL *const)url completion:(void (^)(FLAnimatedImage *animatedImage))completion
​
​{
​
​NSString *const filename = url.lastPathComponent;
​
​NSString *const diskPath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
​
​NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:diskPath];
​
​FLAnimatedImage * __block animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
​
​if (animatedImage) {
​if (completion) {
​completion(animatedImage);
​}
​} else {
​[[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
​animatedImageData = data;
​animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
​if (animatedImage) {
​if (completion) {
​dispatch_async(dispatch_get_main_queue(), ^{
​completion(animatedImage);
​});
​}
​[data writeToFile:diskPath atomically:YES];
​}
​}] resume];
​
​}
​}
​## 
​
