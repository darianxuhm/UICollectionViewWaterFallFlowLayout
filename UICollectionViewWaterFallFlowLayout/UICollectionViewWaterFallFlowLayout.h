//
//  UICollectionViewWaterFallFlowLayout.h
//  LMUIKit
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

@end

@protocol UICollectionViewDelegateWaterFallFlowLayout <UICollectionViewDelegateFlowLayout>

@required
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForHeaderInSection:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForFooterInSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
