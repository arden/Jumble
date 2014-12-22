//
//  ThingsViewController.swift
//  Jumble
//
//  Created by Aaron Taylor on 11/8/14.
//  Copyright (c) 2014 Hamsterdam. All rights reserved.
//

import UIKit

let ThingCellIdentifier = "ThingCell"

class ThingsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
  StackedGridLayoutDelegate, UICollectionViewDelegateFlowLayout {

  // MARK: Properties

  let data = ["1\n\n\n\n\n", "2", "3\n\n\n\n", "4", "5\n\n\n", "6", "7\n\n\n", "8", "9"]

  var collectionView: UICollectionView = {
    let layout = StackedGridLayout()

    let collectionView = UICollectionView(frame: CGRect.zeroRect, collectionViewLayout: layout)
    collectionView.backgroundColor = UIColor.redColor()
    collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    collectionView.registerClass(ThingCollectionViewCell.self, forCellWithReuseIdentifier: ThingCellIdentifier)

    return collectionView
  }()

  // MARK: Lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    collectionView.delegate = self
    collectionView.dataSource = self
    let layout = collectionView.collectionViewLayout as StackedGridLayout
    layout.delegate = self
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    view.addConstraint(NSLayoutConstraint(
      item: collectionView,
      attribute: NSLayoutAttribute.Top,
      relatedBy: NSLayoutRelation.Equal,
      toItem: view,
      attribute: NSLayoutAttribute.Top,
      multiplier: 1.0,
      constant: 0.0))
    view.addConstraint(NSLayoutConstraint(
      item: collectionView,
      attribute: NSLayoutAttribute.Leading,
      relatedBy: NSLayoutRelation.Equal,
      toItem: view,
      attribute: NSLayoutAttribute.Leading,
      multiplier: 1.0,
      constant: 0.0))
    view.addConstraint(NSLayoutConstraint(
      item: collectionView,
      attribute: NSLayoutAttribute.Trailing,
      relatedBy: NSLayoutRelation.Equal,
      toItem: view,
      attribute: NSLayoutAttribute.Trailing,
      multiplier: 1.0,
      constant: 0.0))
    view.addConstraint(NSLayoutConstraint(
      item: collectionView,
      attribute: NSLayoutAttribute.Bottom,
      relatedBy: NSLayoutRelation.Equal,
      toItem: view,
      attribute: NSLayoutAttribute.Bottom,
      multiplier: 1.0,
      constant: 0.0))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }

  // MARK: UICollectionViewDataSource

  func collectionView(
    collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
      ThingCellIdentifier, forIndexPath: indexPath) as ThingCollectionViewCell
      cell.contentView.backgroundColor = UIColor.whiteColor()
      cell.label.text = data[indexPath.item]
    return cell
  }

  func collectionView(
    collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    return data.count
  }

  // MARK: StackedGridLayoutDelegate

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfColumnsInSection section: Int) -> Int {
    return traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact ? 3 : 4
  }
}
