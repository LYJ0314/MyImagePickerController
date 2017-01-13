//
//  ViewController.m
//  MyImagePickerController
//
//  Created by lyj on 17/1/11.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "ViewController.h"
#import "PhotoPickManager.h"

#import "MHImagePickerMutilSelector.h"

#define kScreenW  [UIScreen mainScreen].bounds.size.width
#define kScreenH  [UIScreen mainScreen].bounds.size.height

#define ImageW  80
#define ImageH  80
#define ImageCount 4
#define ImageMarginH  15
#define ImageMarginW  (kScreenW - 4 * (ImageW)) / (ImageCount + 1)

@interface ViewController ()<UIActionSheetDelegate,MHImagePickerMutilSelectorDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, strong) NSMutableArray *importItems;
@property (weak, nonatomic) IBOutlet UIView *containtImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContaintImageViewHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选取照片";

}
#pragma mark 方法1
- (IBAction)pickBtnClick:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];

}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PhotoPickManager *pickManager = [PhotoPickManager shareInstance];
    [pickManager presentPicker:buttonIndex target:self callBackBlock:^(NSDictionary *infoDict, BOOL isCancel) {
        _imgView.image = [infoDict valueForKey:UIImagePickerControllerOriginalImage];
    }];
}
#pragma mark 方法2
// mrc 环境
- (IBAction)pickButtonClick:(id)sender {
    // http://www.cocoachina.com/bbs/read.php?tid=112242
    MHImagePickerMutilSelector *imagePickerMutilSelector = [MHImagePickerMutilSelector standardSelector];
    imagePickerMutilSelector.delegate = self;
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = imagePickerMutilSelector; //将UIImagePicker的代理指向到imagePickerMutilSelector
    [picker setAllowsEditing:NO];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    picker.navigationController.delegate = imagePickerMutilSelector;//将UIImagePicker的导航代理指向到imagePickerMutilSelector
    imagePickerMutilSelector.imagePicker = picker; //使imagePickerMutilSelector得知其控制的UIImagePicker实例，为释放时需要
    [self presentModalViewController:picker animated:YES];

}

#pragma mark MHImagePickerMutilSelectorDelegate
// 就一个代理的方法，获得多选的图片数据数组
- (void)imagePickerMutilSelectorDidGetImages:(NSArray *)imageArray
{
    // 删除原来的图片
    if (self.importItems.count > 0) {
       NSArray *arr = self.containtImageView.subviews;
        for (UIView *ii in arr) {
            [ii removeFromSuperview];
            self.ContaintImageViewHeight.constant = 100;
        }
    }
    // 然后再 新图片更新
    self.importItems = [[NSMutableArray alloc]initWithArray:imageArray copyItems:YES];
    NSLog(@"++++++++++++%@",self.importItems);
    
    for (int i = 0; i < self.importItems.count; i ++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        UIImage *img = self.importItems[i];
        imgView.image = img;
        float x = ImageMarginW * ((i % ImageCount) + 1) + ImageW * (i % ImageCount);
        float y = ImageMarginH;

        if (i / ImageCount) {
            y = (ImageH + ImageMarginH) * (i / ImageCount) + ImageMarginH;
            self.ContaintImageViewHeight.constant = y + ImageH + ImageMarginH;
        }
        imgView.frame = CGRectMake(x, y, ImageW, ImageH);
        [self.containtImageView addSubview:imgView];
    }
}

                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
