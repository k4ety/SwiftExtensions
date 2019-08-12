//
//  PassThroughView.swift
//
//  Created by Paul King on 6/28/19.
//  Copyright © 2019 Paul King. All rights reserved.
//

import UIKit

class PassThroughView: UIView {
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return false
  }
  
}
