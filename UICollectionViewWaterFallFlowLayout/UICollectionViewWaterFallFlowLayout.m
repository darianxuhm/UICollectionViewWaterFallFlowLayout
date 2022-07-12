//
//  UICollectionViewWaterFallFlowLayout.m
//  UIKit
//
//  Created by xuhuiming on 2021/6/25.
//

#import "UICollectionViewWaterFallFlowLayout.h"

/// 装饰视图属性
@interface UICollectionSectionBackgroundLayoutAttributes : UICollectionViewLayoutAttributes

/// 添加组背景
@property (nonatomic, strong) UIColor *backgroundColor;

/// 添加组圆角
@property (nonatomic, assign) UIRectCorner corners;

/// 添加组圆角的大小
@property (nonatomic, assign) CGSize sectionCornerRadii;

@end

@implementation UICollectionSectionBackgroundLayoutAttributes

@end

/// 装饰视图
@interface UICollectionSectionBackgroundView : UICollectionReusableView

+ (NSString *)kind;

@end

@implementation UICollectionSectionBackgroundView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    if ([layoutAttributes isKindOfClass:[UICollectionSectionBackgroundLayoutAttributes class]]) {
        UICollectionSectionBackgroundLayoutAttributes * backgroundLayoutAttributes = (UICollectionSectionBackgroundLayoutAttributes *)layoutAttributes;
        self.backgroundColor = backgroundLayoutAttributes.backgroundColor;
        self.layer.cornerRadius = 10;
    }
}

+ (NSString *)kind {
    return  NSStringFromClass([self class]);
}

@end

@interface UICollectionViewWaterFallFlowLayout()

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSNumber *> *> *columnHeights;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *itemAttributes;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *footerAttributes;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *headerAttributes;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *sectionBackgroundAttributes;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *allAttributes;

@end

@implementation UICollectionViewWaterFallFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.numberOfColumns = 2;//默认2两列
        self.minimumLineSpacing = 10; //默认行间距
        self.minimumInteritemSpacing = 10;//默认列间距
        self.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    UICollectionView *collectionView = self.collectionView;
    if (collectionView == nil) {
        return;
    }
    
    self.itemAttributes = [[NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> alloc] init];
    self.allAttributes = [[NSMutableArray<UICollectionViewLayoutAttributes *> alloc] init];
    self.headerAttributes = [[NSMutableArray<UICollectionViewLayoutAttributes *> alloc] init];
    self.footerAttributes = [[NSMutableArray<UICollectionViewLayoutAttributes *> alloc] init];
    self.sectionBackgroundAttributes = [[NSMutableArray<UICollectionViewLayoutAttributes *> alloc] init];
    self.columnHeights = [[NSMutableArray alloc] init];
    
    CGFloat top = 0.0f;
    NSInteger numberOfSections = collectionView.numberOfSections;
    for (int section = 0; section<numberOfSections; section++) {
        /// sectio内边距n
        UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:section];
        /// 每一组有多少个Items
        NSInteger numberOfItems = [self evaluatedNumberOfItemsInSection:section];
        /// 列间距
        CGFloat columnSpacing = [self evaluatedMinimumInteritemSpacingForSectionAtIndex:section];
        /// 行间距
        CGFloat lineSpacing = [self evaluatedMinimumLineSpacingForSectionAtIndex:section];
        /// 每一组多少列
        NSInteger numberOfColumns = [self evaluatedReferenceNumberOfColumnsInSection:section];
        
        top += sectionInset.top;
        
        CGSize headerSize = [self _headerSizeForSection:section];
        /// 头部视图
        if (headerSize.height > 0) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            CGFloat left = sectionInset.left;
            CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
            CGFloat height = headerSize.height;
            attributes.frame = CGRectMake(left, top, width, height);
            [self.headerAttributes addObject:attributes];
            [self.allAttributes addObject:attributes];
            top = CGRectGetMaxY(attributes.frame);
        } else {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            CGFloat left = sectionInset.left;
            CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
            CGFloat height = headerSize.height;
            attributes.frame = CGRectMake(left, top, width, height);
            [self.headerAttributes addObject:attributes];
            [self.allAttributes addObject:attributes];
        }
        
        [self.columnHeights addObject:[[NSMutableArray alloc] init]];
        for (int i = 0; i< numberOfColumns; i++) {
            [self.columnHeights[section] addObject:[NSNumber numberWithFloat:top]];
        }
        
        /// 每一列宽度
        CGFloat columnWidth = [self _columnWidthForSection:section];
        [self.itemAttributes addObject:[[NSMutableArray alloc] init]];
        for (int idx = 0; idx< numberOfItems; idx ++) {
            NSInteger columnIndex = [self _shortestColumnIndexInSection:section];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            
            CGSize itemSize = [self _itemSizeAtIndexPath:indexPath];
            CGFloat xOffset = sectionInset.left + (columnWidth + columnSpacing) * columnIndex;
            CGFloat yOffset = self.columnHeights[section][columnIndex].floatValue;
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
            
            self.columnHeights[section][columnIndex] = [NSNumber numberWithFloat:(CGRectGetMaxY(attributes.frame) + lineSpacing)];
            
            [self.itemAttributes[section] addObject:attributes];
            [self.allAttributes addObject:attributes];
        }
        
        /// 尾部视图
        CGSize ferenceSize = [self _footerSizeForSection:section];
        if (ferenceSize.height > 0) {
            NSInteger columnIndex = [self _tallestColumnIndexInSection:section];
            
            top = self.columnHeights[section][columnIndex].floatValue - lineSpacing;
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            
            CGFloat left = sectionInset.left;
            CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
            CGFloat height = ferenceSize.height;
            attributes.frame = CGRectMake(left, top, width, height);
            
            self.columnHeights[section][columnIndex] = [NSNumber numberWithFloat:(CGRectGetMaxY(attributes.frame) + lineSpacing)];
            
            [self.footerAttributes addObject:attributes];
            [self.allAttributes addObject:attributes];
        } else {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            CGFloat left = sectionInset.left;
            CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
            CGFloat height = ferenceSize.height;
            attributes.frame = CGRectMake(left, top, width, height);
            [self.footerAttributes addObject:attributes];
            [self.allAttributes addObject:attributes];
        }
        
        NSInteger columnIndex = [self _tallestColumnIndexInSection:section];
        top = self.columnHeights[section][columnIndex].floatValue - lineSpacing + sectionInset.bottom;
        
        NSInteger sectionCount = self.columnHeights[section].count;
        for (int idx = 0; idx < sectionCount; idx++) {
            self.columnHeights[section][idx] = [NSNumber numberWithFloat:top];
        }
        
        /// 装饰视图
        if (numberOfItems <= 0) {
            continue;
        }
        
        /// 不响应背景颜色或者不响应背景边距  不添加背景装饰视图
        if (![self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundViewColorForSectionAtIndex:)] && ![self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundViewInsetForSectionAtIndex:)]) {
            continue;
        }
        
        /// sectio内边距n
        UIEdgeInsets backgroundViewInset = [self evaluatedSectionBackgroundViewInsetForItemAtIndex:section];
        
        /// 每一组第一个item的Attributes
        UICollectionViewLayoutAttributes *firstItem = self.itemAttributes[section][0];
        /// 每一组最后一个item的Attributes
        UICollectionViewLayoutAttributes *lastItem = self.itemAttributes[section][numberOfItems - 1];
        /// 满足条件 结束本次循环执行下一次
        if (firstItem == nil || lastItem == nil) {
            continue;
        }
        
        [self registerClass:[UICollectionSectionBackgroundView class] forDecorationViewOfKind:UICollectionSectionBackgroundView.kind];
    
        /// 获取第一个和最后一个item的联合frame ，得到的就是这一组的frame
        CGRect sectionFrame = CGRectUnion(firstItem.frame, lastItem.frame);
        if ([self evaluatedSectionBackgroundViewIncludedHeaderViewForSectionAtIndex:section]) {
            UICollectionViewLayoutAttributes *headerSectionItem = self.headerAttributes[section];
            sectionFrame = CGRectUnion(headerSectionItem.frame, sectionFrame);
        }
        
        if ([self evaluatedSectionBackgroundViewIncludedFooterViewForSectionAtIndex:section]) {
            UICollectionViewLayoutAttributes *footerSectionItem = self.footerAttributes[section];
            sectionFrame = CGRectUnion(footerSectionItem.frame, sectionFrame);
        }
        /// 设置它的x.y  注意理解这里的x点和y点的坐标，不要硬搬，下面这样写的时候是把inset的left的
        /// 距离包含在sectionFrame 开始x的位置 下面的y同逻辑
        sectionFrame.origin.x = backgroundViewInset.left;
        sectionFrame.origin.y -= backgroundViewInset.top;
        /// 纵向滚动的时候组的宽度  这里的道理和上面的x,y的一样，需要你按照自己项目的实际需求去处理
        sectionFrame.size.width = (collectionView.frame.size.width - backgroundViewInset.left - backgroundViewInset.right);
        sectionFrame.size.height += backgroundViewInset.top + backgroundViewInset.bottom;
        
        UICollectionViewLayoutAttributes *backgroundLayoutAttributes = [self layoutAttributesForDecorationViewOfKind:UICollectionSectionBackgroundView.kind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        if (backgroundLayoutAttributes != nil) {
            backgroundLayoutAttributes.frame = sectionFrame;
            [self.sectionBackgroundAttributes addObject:backgroundLayoutAttributes];
            [self.allAttributes addObject:backgroundLayoutAttributes];
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionSectionBackgroundView.kind]) {
        UICollectionSectionBackgroundLayoutAttributes *backgroundLayoutAttributes = [UICollectionSectionBackgroundLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
        backgroundLayoutAttributes.zIndex = -1;
        backgroundLayoutAttributes.backgroundColor = [self evaluatedSectionBackgroundViewColorForItemAtIndex:indexPath.section];
        return backgroundLayoutAttributes;
    }
    return  [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *includedAttributes = [[NSMutableArray alloc] init];
    // Slow search for small batches
    for (UICollectionViewLayoutAttributes *attribute in self.allAttributes) {
        if (CGRectIntersectsRect(attribute.frame,rect)) {
            [includedAttributes addObject:attribute];
        }
    }
    return includedAttributes;
}

/// 总宽度
- (CGFloat)_widthForSection:(NSInteger)section {
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:section];
    return self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
}

/// 每一列的宽度
- (CGFloat)_columnWidthForSection:(NSInteger)section {
    CGFloat columnSpacing = [self evaluatedMinimumInteritemSpacingForSectionAtIndex:section];
    CGFloat width = [self _widthForSection:section];
    /// 每一组多少列
    NSInteger numberOfColumns = [self evaluatedReferenceNumberOfColumnsInSection:section];
    return (width - (numberOfColumns - 1) * columnSpacing) / numberOfColumns;
}

/// item宽高
- (CGSize)_itemSizeAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [self _columnWidthForSection:indexPath.section];
    CGFloat height = 0.0f;
    CGSize size = CGSizeMake(width, height);
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        height = [delegate collectionView: self.collectionView layout:self heightForItemAtIndexPath:indexPath];
    } else {
        height = width;
    }
    
    CGSize originalSize = CGSizeMake(width, height);
    if (originalSize.height > 0 && originalSize.width > 0) {
        size.height = originalSize.height / originalSize.width * size.width;
    }
    return size;
}

/// 头部视图宽高
- (CGSize)_headerSizeForSection:(NSInteger)section {
    CGFloat width = [self _widthForSection:section];
    CGFloat height = [self evaluatedReferenceHeightForHeaderInSection:section];
    return CGSizeMake(width, height);
}

/// 尾部视图宽高
- (CGSize)_footerSizeForSection:(NSInteger)section {
    CGFloat width = [self _widthForSection:section];
    CGFloat height = [self evaluatedReferenceHeightForFooterInSection:section];
    return CGSizeMake(width, height);
}

/// 内容宽高
- (CGSize)collectionViewContentSize {
    CGFloat height = 0;
    if (self.columnHeights.count > 0) {
        NSInteger sectionCount = self.columnHeights.count;
        if (self.columnHeights[sectionCount -1].count > 0) {
            height = self.columnHeights[sectionCount -1][0].floatValue;
        }
    }
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

/// 找到最长列
- (NSInteger)_tallestColumnIndexInSection:(NSInteger)section {
    __block NSInteger index = 0;
    __block CGFloat tallestHeight = 0;
    [self.columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = obj.floatValue;
        if (height > tallestHeight) {
            index = idx;
            tallestHeight = height;
        }
    }];
    return index;
}

/// 找到最短列
- (NSInteger)_shortestColumnIndexInSection:(NSInteger)section {
    __block NSInteger index = 0;
    __block CGFloat shortestHeight = CGFLOAT_MAX;
    [self.columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = obj.floatValue;
        if (height < shortestHeight) {
            index = idx;
            shortestHeight = height;
        }
    }];
    return index;
}

/// 每一组有多少Item
/// @param section section
- (NSInteger)evaluatedNumberOfItemsInSection:(NSInteger)section {
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        id<UICollectionViewDataSource> dataSource = (id<UICollectionViewDataSource>)self.collectionView.dataSource;
        
        return [dataSource collectionView:self.collectionView numberOfItemsInSection:section];
    } else {
        return 0;
    }
}

/// 头部视图Size
/// @param section section
- (CGFloat)evaluatedReferenceHeightForHeaderInSection:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceHeightForHeaderInSection:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self referenceHeightForHeaderInSection:section];
    } else if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView: self.collectionView layout:self referenceSizeForHeaderInSection:section].height;
    } else {
        return self.headerHeight;
    }
}

/// 尾部视图高度
/// @param section section
- (CGFloat)evaluatedReferenceHeightForFooterInSection:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceHeightForFooterInSection:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self referenceHeightForFooterInSection:section];
    } else if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView: self.collectionView layout:self referenceSizeForFooterInSection:section].height;
    } else {
        return self.footerHeight;
    }
}

/// 每一组 多少列
/// @param section section
- (NSInteger)evaluatedReferenceNumberOfColumnsInSection:(NSInteger)section {
    NSInteger numberOfColumns = 0;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:numberOfColumnsInSection:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        numberOfColumns = [delegate collectionView:self.collectionView layout:self numberOfColumnsInSection:section];
    } else {
        numberOfColumns = self.numberOfColumns;
    }
    
    /// 最少1列
    return numberOfColumns > 0 ? numberOfColumns : 1;
}

/// 列间隙
- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    } else {
        return self.minimumInteritemSpacing;
    }
}

/// 行间距
- (CGFloat)evaluatedMinimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    } else {
        return self.minimumLineSpacing;
    }
}

/// section边距
/// @param section section
- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else {
        return self.sectionInset;
    }
}

/// 背景视图section边距
/// @param section section
- (UIEdgeInsets)evaluatedSectionBackgroundViewInsetForItemAtIndex:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundViewInsetForSectionAtIndex:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self backgroundViewInsetForSectionAtIndex:section];
    } else {
        return UIEdgeInsetsZero;
    }
}

- (UIColor *)evaluatedSectionBackgroundViewColorForItemAtIndex:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundViewColorForSectionAtIndex:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self backgroundViewColorForSectionAtIndex:section];
    } else {
        return [UIColor clearColor];
    }
}

- (BOOL)evaluatedSectionBackgroundViewIncludedHeaderViewForSectionAtIndex:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundViewIncludedHeaderViewForSectionAtIndex:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self backgroundViewIncludedHeaderViewForSectionAtIndex:section];
    } else {
        return self.isIncludedHeader;
    }
}

- (BOOL)evaluatedSectionBackgroundViewIncludedFooterViewForSectionAtIndex:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundViewIncludedFooterViewForSectionAtIndex:)]) {
        id<UICollectionViewDelegateWaterFallFlowLayout> delegate = (id<UICollectionViewDelegateWaterFallFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self backgroundViewIncludedFooterViewForSectionAtIndex:section];
    } else {
        return self.isIncludedFooter;
    }
}

@end
