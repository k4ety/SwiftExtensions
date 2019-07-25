//
//  MKAnnotationView.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/6/16.
//

import MapKit

public extension MKAnnotationView {
  
  convenience init(annotation: MKAnnotation?, diameter: CGFloat, color: UIColor, reuseIdentifier: String?=nil) {
    self.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
    layer.cornerRadius = frame.width/2
    backgroundColor = .black
    
    let dot = UIView(frame: CGRect(x: 0.5, y: 0.5, width: diameter-1, height: diameter-1))
    dot.layer.cornerRadius = dot.frame.width/2
    dot.backgroundColor = .white
    addSubview(dot)
    bringSubviewToFront(dot)
    
    let aperature = min(7, diameter)
    let innerDot = UIView(frame: CGRect(x: 3, y: 3, width: diameter-aperature, height: diameter-aperature))
    innerDot.layer.cornerRadius = innerDot.frame.width/2
    innerDot.backgroundColor = .red
    dot.addSubview(innerDot)
    dot.bringSubviewToFront(innerDot)
  }
  
}
