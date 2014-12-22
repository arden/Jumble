//
//  StackedGridLayout.swift
//  Jumble
//
//  Created by Aaron Taylor on 11/8/14.
//  Copyright (c) 2014 Hamsterdam. All rights reserved.
//

import UIKit

@objc protocol StackedGridLayoutDelegate: UICollectionViewDelegate {

  /// Asks the delegate for number of columns in a section.
  optional func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    numberOfColumnsInSection section: Int) -> Int

  /// Asks the delegate for the height of an item, given the width of the column.
  optional func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat

  /// Asks the delegate for the spacing between items.
  optional func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    itemSpacingForSection section: Int) -> CGFloat
}

class StackedGridLayout: UICollectionViewLayout {

  /// The number of columns in the layout. The default is 2.
  var numberOfColumns = 2

  /// The horizontal and vertical spacing between items. The default is 10.
  var itemSpacing: CGFloat = 10

  /// The object acting as delegate for the layout.
  weak var delegate: StackedGridLayoutDelegate?

  /// The sections in the layout.
  private var sections = [StackedGridLayoutSection]()

  /// The content height of the collection view.
  private var contentHeight: CGFloat = 0

  /// A boolean that determines whether initial setup occurs when the layout is invalidated.
  var preparedLayoutForCurrentWidth = false

  override func prepareLayout() {
    super.prepareLayout()

    if !preparedLayoutForCurrentWidth {
      sections = [StackedGridLayoutSection]()
      contentHeight = 0

      var currentOrigin = CGPoint.zeroPoint

      var numberOfSections = collectionView!.numberOfSections()

      let sectionWidth = collectionView!.bounds.width

      for sectionIndex in 0..<numberOfSections {
        currentOrigin.y = contentHeight

        let numberOfColumnsFromDelegate = delegate?.collectionView?(
          collectionView!, layout: self, numberOfColumnsInSection: sectionIndex)
        let numberOfColumnsInSection = numberOfColumnsFromDelegate ?? numberOfColumns

        let numberOfItemsInSection = collectionView!.numberOfItemsInSection(sectionIndex)

        let itemSpacingFromDelegate = delegate?.collectionView?(
          collectionView!, layout: self, itemSpacingForSection: sectionIndex)
        let itemSpcaingInSection = itemSpacingFromDelegate ?? itemSpacing

        var section = StackedGridLayoutSection(
          origin: currentOrigin,
          width: sectionWidth,
          columns: numberOfColumnsInSection,
          itemSpacing: itemSpcaingInSection)

        for itemIndex in 0..<numberOfItemsInSection {
          let itemWidth = section.columnWidth - (section.itemSpacing * 2)
          var itemHeight: CGFloat
          let itemIndexPath = NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
          let itemHeightFromDelegate = delegate?.collectionView?(
            collectionView!, layout: self,
            heightForItemAtIndexPath: itemIndexPath)
          if itemHeightFromDelegate != nil && itemHeightFromDelegate > itemWidth {
            itemHeight = itemHeightFromDelegate!
          } else {
            itemHeight = itemWidth
          }
          var itemSize = CGSize(width: itemWidth, height: itemHeight)

          section.addItemOfSize(itemSize, forIndex: itemIndex)
        }
        sections.append(section)

        contentHeight += section.frame.height
        currentOrigin.y = contentHeight
      }
      preparedLayoutForCurrentWidth = true
    }
  }

  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: collectionView!.bounds.width, height: contentHeight)
  }

  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
    let section = sections[indexPath.section]
    let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    layoutAttributes.frame = section.frameForItemAtIndex(indexPath.item)
    return layoutAttributes
  }

  override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
    var layoutAttributesForRect = [UICollectionViewLayoutAttributes]()
    var sectionIndex = 0
    for section in sections {
      if section.frame.intersects(rect) {
        for itemIndex in 0..<section.numberOfItems {
          let itemFrame = section.frameForItemAtIndex(itemIndex)
          if itemFrame.intersects(rect) {
            let itemIndexPath = NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
            let layoutAttributesForItem = layoutAttributesForItemAtIndexPath(itemIndexPath)
            layoutAttributesForRect.append(layoutAttributesForItem)
          }
        }
      }
      sectionIndex++
    }
    return layoutAttributesForRect
  }


  override func shouldInvalidateLayoutForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
    if preferredAttributes.frame != originalAttributes.frame {
      // If the dynamically sized item, when normalized, has the same size, do nothing.
      let changedItemSection = sections[preferredAttributes.indexPath.section]
      let changedItemCurrentSize = changedItemSection.frameForItemAtIndex(
        preferredAttributes.indexPath.item).size

      let changedItemWidth = changedItemSection.columnWidth -
        (changedItemSection.itemSpacing * 2)
      let changedItemHeight = max(preferredAttributes.frame.height, changedItemWidth)
      let changedItemSize = CGSize(width: changedItemWidth, height: changedItemHeight)

      if changedItemCurrentSize == changedItemSize {
        return false
      }

      let indexPath = preferredAttributes.indexPath

      let numberOfSections = collectionView!.numberOfSections()

      // Remove and store the current sections that are now invalid.
      var invalidSections = [StackedGridLayoutSection]()
      for sectionIndex in indexPath.section..<numberOfSections {
        invalidSections.append(sections.removeAtIndex(sectionIndex))
      }

      // Set the content height to reflect the sections that are still valid.
      contentHeight = 0
      for sectionIndex in 0..<indexPath.section {
        contentHeight += sections[sectionIndex].frame.height
      }

      var currentOrigin = CGPoint(x: 0, y: contentHeight)

      let sectionWidth = collectionView!.bounds.width

      // Add sections for invalidated sections.
      for sectionIndex in indexPath.section..<numberOfSections {
        currentOrigin.y = contentHeight

        let numberOfColumnsFromDelegate = delegate?.collectionView?(
          collectionView!, layout: self, numberOfColumnsInSection: sectionIndex)
        let numberOfColumnsInSection = numberOfColumnsFromDelegate ?? numberOfColumns

        let numberOfItemsInSection = collectionView!.numberOfItemsInSection(sectionIndex)

        let itemSpacingFromDelegate = delegate?.collectionView?(
          collectionView!, layout: self, itemSpacingForSection: sectionIndex)
        let itemSpcaingInSection = itemSpacingFromDelegate ?? itemSpacing

        var section = StackedGridLayoutSection(
          origin: currentOrigin,
          width: sectionWidth,
          columns: numberOfColumnsInSection,
          itemSpacing: itemSpcaingInSection)

        for itemIndex in 0..<numberOfItemsInSection {
          var itemWidth = section.columnWidth - (section.itemSpacing * 2)
          var itemHeight: CGFloat = 0.0
          let itemIndexPath = NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
          if  itemIndexPath == indexPath {
            itemHeight = max(preferredAttributes.frame.height, itemWidth)
          } else {
            itemHeight = invalidSections[sectionIndex].frameForItemAtIndex(itemIndex).height
          }
          let itemSize = CGSize(width: itemWidth, height: itemHeight)
          section.addItemOfSize(itemSize, forIndex: itemIndex)
        }
        sections.append(section)

        contentHeight += section.frame.height
        currentOrigin.y = contentHeight
      }
      return true
    }

    return false
  }

  override func invalidationContextForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
    let invalidationContext = super.invalidationContextForPreferredLayoutAttributes(
      preferredAttributes, withOriginalAttributes: originalAttributes)

    let invalidIndexPath = preferredAttributes.indexPath

    let numberOfSections = collectionView!.numberOfSections()

    var invalidIndexPaths = [NSIndexPath]()

    // Invalidate all items including and after the dynamically changed item.
    for sectionIndex in invalidIndexPath.section..<numberOfSections {
      let section = sections[sectionIndex]
      let lowerItemIndex = sectionIndex == invalidIndexPath.section ? invalidIndexPath.item : 0
      for itemIndex in lowerItemIndex..<section.numberOfItems {
        let itemIndexPath = NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
        invalidationContext.invalidateItemsAtIndexPaths([itemIndexPath])
      }
    }

    let heightDelta = preferredAttributes.frame.height - originalAttributes.frame.height
    invalidationContext.contentOffsetAdjustment = CGPoint(x: 0, y: heightDelta)
    invalidationContext.contentSizeAdjustment = CGSize(width: 0, height: heightDelta)

    return invalidationContext
  }

  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    let shouldInvalidate = collectionView!.bounds.size.width != newBounds.size.width
    
    preparedLayoutForCurrentWidth = !shouldInvalidate
    
    return shouldInvalidate
  }
}
