//
//  FlowLayout.swift
//  YKTools
//
//  Created by 杨锴 on 2019/6/14.
//  Copyright © 2019 younger_times. All rights reserved.
//

import UIKit

public class JQ_FlowLayout:UICollectionViewFlowLayout{
    
    public override func prepare() {
        super.prepare()
        let inset = (self.collectionView!.jq_width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let original = super.layoutAttributesForElements(in: rect)
        let attsArray = NSArray(array: original!, copyItems: true)
        let centerX = collectionView!.jq_width / 2 + collectionView!.contentOffset.x
        
        for atts in attsArray {
            let attributes = atts as! UICollectionViewLayoutAttributes
            let space = abs(attributes.center.x - centerX)
            let scale = 1 - (space/collectionView!.jq_width/4)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return (attsArray as! [UICollectionViewLayoutAttributes])
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let rect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.jq_width, height: collectionView!.jq_height)
        let original = super.layoutAttributesForElements(in: rect)
        
        let attsArray = NSArray(array: original!, copyItems: true) as! [UICollectionViewLayoutAttributes]
        
        let centerX = proposedContentOffset.x + collectionView!.jq_width/2
        var minSpace = CGFloat(MAXFLOAT)
        
        for attrs in attsArray {
            if abs(minSpace) > abs(attrs.center.x - centerX){
                minSpace = attrs.center.x - centerX
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + minSpace, y: proposedContentOffset.y)
    }
}
