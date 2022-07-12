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
    layout.numberOfColumns = 2;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.isIncludedHeader = YES;
    layout.isIncludedFooter = YES;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return [self initWithCollectionViewLayout:layout];
}

static NSString *const CollectionViewCellIdentifier = @"CollectionViewCell";
static NSString *const UICollectionHeaderViewIdentifier = @"UICollectionHeaderView";
static NSString *const UICollectionFooterViewIdentifier = @"UICollectionFooterView";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionHeaderViewIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionFooterViewIdentifier];
    
    // 增加5组假数据
    for (int section = 0; section < 10; section ++) {
        [self.colorsArray addObject:[[NSMutableArray alloc] init]];
        for (int row = 0; row < 2*section + 2; row++) {
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
    
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constrant1 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *constrant2 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [cell.contentView addConstraints:@[constrant1,constrant2]];
    
    titleLabel.text = [NSString stringWithFormat:@"row=%ld",indexPath.row];
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
        
        [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *constrant1 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:reusableView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *constrant2 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:reusableView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        [reusableView addConstraints:@[constrant1,constrant2]];
        
        titleLabel.frame = reusableView.bounds;
        titleLabel.text = [NSString stringWithFormat:@"header section=%ld",(long)indexPath.section];
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
        [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *constrant1 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:reusableView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *constrant2 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:reusableView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        [reusableView addConstraints:@[constrant1,constrant2]];

        titleLabel.text = [NSString stringWithFormat:@"footer section=%ld",(long)indexPath.section];
        return reusableView;
    }
    return  nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 3) {
        return 44;
    }
    return arc4random_uniform(100) + 100;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout *)collectionViewLayout numberOfColumnsInSection:(NSInteger)section {
    if (section < 3) {
        return section + 1;
    }
    return  3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForFooterInSection:(NSInteger)section {
    return 44;
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundViewColorForSectionAtIndex:(NSInteger)section {
    return RandomColor;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundViewInsetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
