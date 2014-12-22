//
//  ThingCollectionViewCell.swift
//  Jumble
//
//  Created by Aaron Taylor on 11/9/14.
//  Copyright (c) 2014 Hamsterdam. All rights reserved.
//

import UIKit

class ThingCollectionViewCell: UICollectionViewCell {
  var label: UILabel = {
    let label = UILabel()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    label.textColor = UIColor.blackColor()
    label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).fontWithSize(50)
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    label.textAlignment = NSTextAlignment.Center
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    contentView.addSubview(label)
    contentView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.LeadingMargin, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1.0, constant: 0.0))
    contentView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1.0, constant: 0.0))
    contentView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0.0))
    contentView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.BottomMargin, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: 0.0))
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    label.text = nil
  }

  override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes! {
    setNeedsLayout()
    layoutIfNeeded()

    var bounds = label.bounds.width
    label.preferredMaxLayoutWidth = label.bounds.width

    var attrs = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)

    return attrs
  }
}
