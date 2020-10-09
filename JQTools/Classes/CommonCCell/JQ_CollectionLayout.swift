//
//  JQ_CommonPageLayout.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/9.
//


/**
 # 自定义的UICollectionViewLayout 风格 #

 ![](https://www.hangge.com/blog/cache/detail_591.html#)

 */
public class JQ_PageCustomLayout : UICollectionViewLayout {

    // 内容区域总大小，不是可见区域
    public override var collectionViewContentSize: CGSize {
        let width = collectionView!.bounds.size.width - collectionView!.contentInset.left
            - collectionView!.contentInset.right
        let height = CGFloat((collectionView!.numberOfItems(inSection: 0) + 1) / 3)
            * (width / 3 * 2)
        return CGSize(width: width, height: height)
    }

    // 所有单元格位置属性
    public override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var attributesArray = [UICollectionViewLayoutAttributes]()
            let cellCount = self.collectionView!.numberOfItems(inSection: 0)
            for i in 0..<cellCount {
                let indexPath =  IndexPath(item:i, section:0)
                let attributes =  self.layoutAttributesForItem(at: indexPath)
                attributesArray.append(attributes!)
            }
            return attributesArray
    }

    // 这个方法返回每个单元格的位置和大小
    public override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            //当前单元格布局属性
            let attribute =  UICollectionViewLayoutAttributes(forCellWith:indexPath)

            //单元格边长
            let largeCellSide = collectionViewContentSize.width / 3 * 2
            let smallCellSide = collectionViewContentSize.width / 3

            //当前行数，每行显示3个图片，1大2小
            let line:Int =  indexPath.item / 3
            //当前行的Y坐标
            let lineOriginY =  largeCellSide * CGFloat(line)
            //右侧单元格X坐标，这里按左右对齐，所以中间空隙大
            let rightLargeX = collectionViewContentSize.width - largeCellSide
            let rightSmallX = collectionViewContentSize.width - smallCellSide

            // 每行2个图片，2行循环一次，一共6种位置
            if (indexPath.item % 6 == 0) {
                attribute.frame = CGRect(x:0, y:lineOriginY, width:largeCellSide,
                                         height:largeCellSide)
            } else if (indexPath.item % 6 == 1) {
                attribute.frame = CGRect(x:rightSmallX, y:lineOriginY, width:smallCellSide,
                                         height:smallCellSide)
            } else if (indexPath.item % 6 == 2) {
                attribute.frame = CGRect(x:rightSmallX,
                                         y:lineOriginY + smallCellSide,
                                         width:smallCellSide, height:smallCellSide)
            } else if (indexPath.item % 6 == 3) {
                attribute.frame = CGRect(x:0, y:lineOriginY, width:smallCellSide,
                                         height:smallCellSide )
            } else if (indexPath.item % 6 == 4) {
                attribute.frame = CGRect(x:0,
                                         y:lineOriginY + smallCellSide,
                                         width:smallCellSide, height:smallCellSide)
            } else if (indexPath.item % 6 == 5) {
                attribute.frame = CGRect(x:rightLargeX, y:lineOriginY,
                                         width:largeCellSide,
                                         height:largeCellSide)
            }

            return attribute
    }

    /*
     //如果有页眉、页脚或者背景，可以用下面的方法实现更多效果
     func layoutAttributesForSupplementaryViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     func layoutAttributesForDecorationViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     */
}
