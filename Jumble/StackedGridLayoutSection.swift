//
//  StackedGridLayoutSection.swift
//  Jumble
//
//  Created by Aaron Taylor on 11/8/14.
//  Copyright (c) 2014 Hamsterdam. All rights reserved.
//

import UIKit

class StackedGridLayoutSection: NSObject {
  /// Frame for section in collection view.
  private(set) var frame: CGRect

  /// Inset for items in collection view.
  private(set) var itemSpacing: CGFloat

  private(set) var columnWidth: CGFloat

  var numberOfItems: Int {
    get {
      return itemFrames.count
    }
  }

  private var columnHeights = [CGFloat]()

  private var itemFrames = [Int: CGRect]()

  init(origin: CGPoint, width: CGFloat, columns: Int, itemSpacing: CGFloat) {
    self.frame = CGRect(x: origin.x, y: origin.y, width: width, height: 0)
    self.itemSpacing = itemSpacing
    self.columnWidth = floor(width / CGFloat(columns))

    super.init()

    for _ in 1...columns {
      self.columnHeights.append(0)
    }
  }

  func addItemOfSize(size: CGSize, forIndex index: Int) {
    var shortestColumnHeight = CGFloat.max
    var shortestColumnIndex = 0

    var columnIndex = 0
    for columnHeight in columnHeights {
      if columnHeight < shortestColumnHeight {
        shortestColumnHeight = columnHeight
        shortestColumnIndex = columnIndex
      }
      columnIndex++
    }

    var itemFrame = CGRect.zeroRect

    itemFrame.origin.x = frame.origin.x + (columnWidth * CGFloat(shortestColumnIndex)) + itemSpacing
    itemFrame.origin.y = frame.origin.y + shortestColumnHeight + itemSpacing
    itemFrame.size = size

    itemFrames[index] = itemFrame

    if itemFrame.maxY > frame.maxY {
      frame.size.height = (itemFrame.maxY - frame.origin.y) + itemSpacing
    }

    columnHeights[shortestColumnIndex] = shortestColumnHeight + size.height + itemSpacing
  }


  func frameForItemAtIndex(index: Int) -> CGRect {
    return itemFrames[index]!
  }
}
