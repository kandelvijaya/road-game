//
//  ViewController.swift
//  Road
//
//  Created by Yunus Eren Guzel on 28/08/15.
//  Copyright (c) 2015 yeg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var cellArea:CellArea!
  
  var map:Map! {
    didSet {
      generateCellArea()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
  }
  
  func generateCellArea() {
    cellArea = CellArea(map: map)
    
    cellArea.setTranslatesAutoresizingMaskIntoConstraints(false)
    cellArea.backgroundColor = UIColor.lightGrayColor()
    view.addSubview(cellArea)
    
    var views = [
      "cellArea":cellArea
    ]
    
    view.addConstraints([
      NSLayoutConstraint(item: cellArea, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: cellArea, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
      ])
    
    view.addConstraints(NSLayoutConstraint
      .constraintsWithVisualFormat("H:|-20-[cellArea]-20-|", options: nil, metrics: nil, views: views))
    
    view.addConstraints(NSLayoutConstraint
      .constraintsWithVisualFormat("V:|-20-[cellArea]", options: nil, metrics: nil, views: views))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

