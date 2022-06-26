//
//  ExampleViewController.m
//  UICollectionViewWaterFallFlowLayout_Example
//
//  Created by xuhuiming on 2021/6/26.
//  Copyright © 2021 xuhuiming. All rights reserved.
//

#import "ExampleViewController.h"
#import "UICollectionViewWaterFallFlowLayout.h"

/**
 * 随机色
 */
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface ExampleViewController ()<UICollectionViewDelegateWaterFallFlowLayout>

/** 存放假数据 */
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *colorsArray;

@end

@implementation ExampleViewController

#pragma mark - 数据相关
- (NSMutableArray *)colorsArray {
    if (_colorsArray == nil) {
        _colorsArray = [NSMutableArray array];
    }
    return _colorsArray;
}

#pragma mark - 其他

/**
 *  初始化
 */
- (id)init
{
    UICollectionViewWaterFallFlowLayout *layout = [[UICollectionViewWaterFallFlowLayout alloc] init];
    layout.numberOfColumns = 3;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return [self initWithCollectionViewLayout:layout];
}

static NSString *const CollectionViewCellIdentifier = @"CollectionViewCell";
static NSString *const UICollectionHeaderViewIdentifier = @"UICollectionHeaderView";
static NSString *const UICollectionFooterViewIdentifier = @"UICollectionFooterView";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionHeaderViewIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionFooterViewIdentifier];
    
    // 增加5组假数据
    for (int section = 0; section < 5; section ++) {
        [self.colorsArray addObject:[[NSMutableArray alloc] init]];
        for (int row = 0; row < 30; row++) {
            [self.colorsArray[section] addObject:RandomColor];
        }
    }
}

#pragma mark - collection数据源代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.colorsArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colorsArray[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.colorsArray[indexPath.section][indexPath.row];
    UILabel *titleLabel = [cell.contentView viewWithTag:1000];
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.tag = 1000;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
    }
    titleLabel.frame = cell.contentView.bounds;
    titleLabel.text = [NSString stringWithFormat:@"section=%ld\n row=%ld",(long)indexPath.section,indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionHeaderViewIdentifier forIndexPath:indexPath];
        reusableView.backgroundColor = RandomColor;
        UILabel *titleLabel = [reusableView viewWithTag:1000];
        if (titleLabel == nil) {
            titleLabel = [[UILabel alloc] init];
            titleLabel.tag = 1000;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [reusableView addSubview:titleLabel];
        }
        titleLabel.frame = reusableView.bounds;
        titleLabel.text = [NSString stringWithFormat:@"section=%ld",(long)indexPath.section];
        return reusableView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionFooterViewIdentifier forIndexPath:indexPath];
        reusableView.backgroundColor = RandomColor;
        UILabel *titleLabel = [reusableView viewWithTag:1001];
        if (titleLabel == nil) {
            titleLabel = [[UILabel alloc] init];
            titleLabel.tag = 1001;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [reusableView addSubview:titleLabel];
        }
        titleLabel.frame = reusableView.bounds;
        titleLabel.text = [NSString stringWithFormat:@"section=%ld",(long)indexPath.section];
        return reusableView;
    }
    return  nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return arc4random_uniform(100) + 100;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForHeaderInSection:(NSInteger)section {
    return arc4random_uniform(50) + 20;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForFooterInSection:(NSInteger)section {
    return arc4random_uniform(50) + 20;
}

@end