//
//  UICollectionViewWaterFallFlowLayout.h
//  UIKit
//
//  Created by xuhuiming on 2021/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 瀑布流布局
@interface UICollectionViewWaterFallFlowLayout : UICollectionViewFlowLayout

/** 显示多少列 */
@property (nonatomic, assign) NSInteger numberOfColumns;
/** 头部高度 */
@property (nonatomic , assign) CGFloat headerHeight;
/** 尾部高度 */
@property (nonatomic , assign) CGFloat footerHeight;
/** 背景颜色是否包含头部视图 */
@property (nonatomic , assign) BOOL isIncludedHeader;
/** 背景颜色是否包含尾部视图 */
@property (nonatomic , assign) BOOL isIncludedFooter;

@end

@protocol UICollectionViewDelegateWaterFallFlowLayout <UICollectionViewDelegateFlowLayout>

/// item高度
/// @param collectionView collectionView
/// @param collectionViewLayout collectionViewLayout
/// @param indexPath indexPath
@required
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/// 头部视图高度
/// @param collectionView collectionView
/// @param collectionViewLayout collectionViewLayout
/// @param section section
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForHeaderInSection:(NSInteger)section;

/// 尾部视图高度
/// @param collectionView collectionView
/// @param collectionViewLayout collectionViewLayout
/// @param section section
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForFooterInSection:(NSInteger)section;

/// section组多少列
/// @param collectionView collectionView
/// @param collectionViewLayout collectionViewLayout
/// @param section section
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)collectionViewLayout numberOfColumnsInSection:(NSInteger)section;

/// 背景视图边距 cell
/// @param collectionView collectionView
/// @param collectionViewLayout collectionViewLayout
/// @param section section
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundViewInsetForSectionAtIndex:(NSInteger)section;

/// 背景视图颜色
/// @param collectionView collectionView
/// @param collectionViewLayout collectionViewLayout
/// @param section section
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundViewColorForSectionAtIndex:(NSInteger)section;


/// 背景视图颜色 - 包含头部
/// @param collectionView collectionView
/// @param collectionViewLayout collectionViewLayout
/// @param section section
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundViewIncludedHeaderViewForSectionAtIndex:(NSInteger)section;

/// 背景视图颜色 - 包含尾部
/// @param collectionView collectionView
/// @param collectionViewLayout collectionViewLayout
/// @param section section
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundViewIncludedFooterViewForSectionAtIndex:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
