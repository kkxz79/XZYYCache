//
//  XZCacheViewController.m
//  XZYYCache
//
//  Created by kkxz on 2018/12/19.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "XZCacheViewController.h"
#import "XZDefinitionConstants.h"
#import "XZPortDatasCacheManager.h"
#import "Book.h"

@interface XZCacheViewController ()<UIActionSheetDelegate>

@end

@implementation XZCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cache";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"action" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.navigationItem.rightBarButtonItem = barButton;
}

-(void)rightButtonAction {
    [[[UIActionSheet alloc]
      initWithTitle:@"YYCache操作"
      delegate:self
      cancelButtonTitle:@"Cancel"
      destructiveButtonTitle:nil
      otherButtonTitles:@"存数据",@"取数据",@"部分删除",@"全部删除",@"存自定义数据",@"取自定义数据",nil]
     showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    SEL selectors[] = {
        @selector(saveStringCache),
        @selector(getStringCache),
        @selector(removeData),
        @selector(removeAllData),
        @selector(saveCustomData),
        @selector(getCustomData)
    };
    
    if (buttonIndex < sizeof(selectors) / sizeof(SEL)) {
        void(*imp)(id, SEL) = (typeof(imp))[self methodForSelector:selectors[buttonIndex]];
        imp(self, selectors[buttonIndex]);
    }
}

-(void)saveStringCache {
    NSString * str = @"Squirrels are native to the northeast, northwest, southeast and Europe of China and are found all over the world except Oceania. Squirrels are widely distributed throughout the cold temperate forest areas can be seen. In China, it is mainly distributed in the mountainous areas of the three northeastern provinces, northeast Inner Mongolia, north hebei and shanxi, sichuan, ningxia, gansu, xinjiang, hunan and guizhou.";
    [[XZPortDatasCacheManager sharedInstance].cache setObject:str forKey:@"squirrel"];
    
    str = @"Rabbits have long tubular ears (ears several times wider than ears), short tufted tails, and strong hind legs that are much longer than the forelimbs. There are 9 genera and 43 species. East, south, Africa and North America have the largest number of species. ";
    [[XZPortDatasCacheManager sharedInstance].cache setObject:str forKey:@"rabbit" withBlock:^{
        NSLog(@"兔子数据存储成功!");
    }];
}

-(void)getStringCache {
   //判断缓存数据是否存在
    if([[XZPortDatasCacheManager sharedInstance].cache containsObjectForKey:@"squirrel"]){
        NSLog(@"松鼠数据存在！");
        id ss = [[XZPortDatasCacheManager sharedInstance].cache objectForKey:@"squirrel"];
        NSLog(@"squirrel - %@",ss);
    }else {
        NSLog(@"松鼠数据不存在！");
    }
    
    [[XZPortDatasCacheManager sharedInstance].cache containsObjectForKey:@"rabbit" withBlock:^(NSString * _Nonnull key, BOOL contains) {
        if(contains){
            NSLog(@"兔子数据存在!");
            [[XZPortDatasCacheManager sharedInstance].cache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
                id tz = object;
                NSLog(@"rabbit - %@",tz);
            }];
        }else{
            NSLog(@"兔子数据不存在");
        }
        
    }];
}

-(void)removeData {
    //移除数据
    [[XZPortDatasCacheManager sharedInstance].cache removeObjectForKey:@"rabbit" withBlock:^(NSString * _Nonnull key) {
        if(![[XZPortDatasCacheManager sharedInstance].cache containsObjectForKey:key]){
            NSLog(@"兔子已经被移除!");
        }
    }];
}

-(void)removeAllData {
    [[XZPortDatasCacheManager sharedInstance].cache removeAllObjects];
    if(![[XZPortDatasCacheManager sharedInstance].cache containsObjectForKey:@"squirrel"]
       &&(![[XZPortDatasCacheManager sharedInstance].cache containsObjectForKey:@"rabbit"])){
        NSLog(@"所有数据已经被移除");
    }
}

-(void)saveCustomData {
    NSMutableArray * arr = [NSMutableArray array];
    Book *book = [[Book alloc] init];
    book.name = @"三国演义";
    book.author = @"罗贯中";
    book.publishHouse = @"南方出版社";
    book.pages = 766;
    [arr addObject:book];
    
    book = [[Book alloc] init];
    book.name = @"红楼梦";
    book.author = @"曹雪芹";
    book.publishHouse = @"人民教育出版社";
    book.pages = 986;
    [arr addObject:book];
    
    [[XZPortDatasCacheManager sharedInstance].cache setObject:arr forKey:@"bookCache" withBlock:^{
        NSLog(@"书籍数据存储成功");
    }];
    
}

-(void)getCustomData {
    [[XZPortDatasCacheManager sharedInstance].cache objectForKey:@"bookCache" withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        NSMutableArray *arr = (NSMutableArray*)object;
        for(Book *book in arr){
            NSLog(@"bookInfo name:%@ author:%@ publishHouse:%@ pages:%ld",book.name,book.author,book.publishHouse,book.pages);
        }
    }];
}

@end
