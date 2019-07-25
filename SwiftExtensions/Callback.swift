//
//  Callback.swift
//  SwiftExtensions
//
//  Created by Paul King on 4/22/19.
//

public protocol CallbackProtocol: class {
  func operationCompleted(_ sender: AnyObject?)
  func operationErrored(_ sender: AnyObject?)
  func operationCancelled(_ sender: AnyObject?)
}

public extension CallbackProtocol {
  func operationErrored(_ sender: AnyObject?) { }
  func operationCancelled(_ sender: AnyObject?) { }
}

public protocol EntitySelectionProtocol: class {
  func selectedCell(_ selectedObject: AnyObject)
}
