//
//  StatusBarNotification.swift
//  SwiftExtensions
//
//  Created by Paul King on 1/25/17.
//
//  This is a derivitive of  CWStatusBarNotification.swift
//  https://github.com/cezarywojcik/CWStatusBarNotification
//

import UIKit

// MARK: - enums
@objc public enum NotificationStyle : Int {
  case statusBarNotification
  case navigationBarNotification
}

@objc public enum NotificationAnimationStyle : Int {
  case top
  case bottom
  case left
  case right
}

@objc public enum NotificationAnimationType : Int {
  case replace
  case overlay
}

public typealias DelayedClosureHandle = (Bool) -> Void

// MARK: - StatusBarNotification
public class StatusBarNotification : NSObject {

  // MARK: - Properties
  private let fontSize : CGFloat = 10
  
  private var tapGestureRecognizer: UITapGestureRecognizer!
  private var dismissHandle: DelayedClosureHandle?
  private var isCustomView = false
  
  private var label: ScrollLabel!
  private var statusBarView: UIView!
  private var supportedInterfaceOrientations: UIInterfaceOrientationMask = .all
  private var preferredStatusBarStyle: UIStatusBarStyle = .default
  private var notificationWindow: WindowContainer?
  private var notificationTappedClosure: (() -> Void)!
  private var notificationIsDismissing = false

  public var animationDuration: TimeInterval = 0.25
  public var style: NotificationStyle = .statusBarNotification
  public var inAnimationStyle: NotificationAnimationStyle = .bottom
  public var outAnimationStyle: NotificationAnimationStyle = .bottom
  public var animationType: NotificationAnimationType = .overlay
  public var backgroundColor: UIColor = .black
  public var textColor: UIColor = .white
  public var font = UIFont.systemFont(ofSize: 10.0)
  public var height: CGFloat = 0
  public var customView: UIView?
  public var multiline = false
  public var isShowing = false
  
  // MARK: - Setup
  public override init() {
    super.init()
    DispatchQueue.main.async { [weak self] in
      if let tintColor = UIApplication.appDelegate.window??.tintColor {
        self?.backgroundColor = tintColor
      } else {
        self?.backgroundColor = .black
      }
      self?.textColor = .white
      self?.font = UIFont.systemFont(ofSize: self?.fontSize ?? 10)
      self?.height = 0.0
      self?.customView = nil
      self?.multiline = false
      if let orientations = UIApplication.app?.keyWindow?.rootViewController?.supportedInterfaceOrientations {
        self?.supportedInterfaceOrientations = orientations
      } else {
        self?.supportedInterfaceOrientations = .all
      }
      self?.animationDuration = 0.25
      self?.style = .statusBarNotification
      self?.inAnimationStyle = .bottom
      self?.outAnimationStyle = .bottom
      self?.animationType = .overlay
      self?.notificationIsDismissing = false
      self?.isCustomView = false
      self?.preferredStatusBarStyle = .default
      self?.dismissHandle = nil
      
      // create default tap closure
      self?.notificationTappedClosure = {
        if self?.notificationIsDismissing == false {
          self?.dismissNotification()
        }
      }
      
      // create tap recognizer
      self?.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self?.notificationTapped(recognizer:)))
    }
  }
  
  // MARK: - StatusBar/NavBar dimension helper methods
  private func statusBarHeight() -> CGFloat {
    if height > 0 {
      return height
    }
    
    var statusBarHeight = UIApplication.app?.statusBarFrame.size.height
    if systemVersionLessThan(value: "8.0.0") && (UIApplication.app?.statusBarOrientation ?? .portrait).isLandscape {
      statusBarHeight = UIApplication.app?.statusBarFrame.size.width
    }
    return (statusBarHeight ?? 0) > 0 ? statusBarHeight! : 20
  }
  
  private func statusBarWidth() -> CGFloat {
    if systemVersionLessThan(value: "8.0.0") && (UIApplication.app?.statusBarOrientation ?? .portrait).isLandscape {
      return UIScreen.main.bounds.size.height
    }
    return UIScreen.main.bounds.size.width
  }
  
  private func statusBarOffset() -> CGFloat {
    if statusBarHeight() == 40.0 {
      return -20.0
    }
    return 0.0
  }
  
  private func navigationBarHeight() -> CGFloat {
    if (UIApplication.app?.statusBarOrientation ?? .portrait).isPortrait || UI_USER_INTERFACE_IDIOM() == .pad {
      return 44.0
    }
    return 30.0
  }
  
  private func notificationLabelHeight() -> CGFloat {
    switch style {
    case .navigationBarNotification:
      return statusBarHeight() + navigationBarHeight()
    case .statusBarNotification:
      return statusBarHeight()
    }
  }
  
  private func notificationLabelTopFrame() -> CGRect {
    return CGRect.init(x: 0,
                       y: statusBarOffset() + -1 * notificationLabelHeight(),
                   width: statusBarWidth(),
                  height: notificationLabelHeight())
  }
  
  private func notificationLabelBottomFrame() -> CGRect {
    return CGRect.init(x: 0,
                       y: statusBarOffset() + notificationLabelHeight(),
                   width: statusBarWidth(),
                  height: 0)
  }
  
  private func notificationLabelLeftFrame() -> CGRect {
    return CGRect.init(x: -1 * statusBarWidth(),
                       y: statusBarOffset(),
                   width: statusBarWidth(),
                  height: notificationLabelHeight())
  }
  
  private func notificationLabelRightFrame() -> CGRect {
    return CGRect.init(x: statusBarWidth(),
                       y: statusBarOffset(),
                   width: statusBarWidth(),
                  height: notificationLabelHeight())
  }
  
  private func notificationLabelFrame() -> CGRect {
    return CGRect.init(x: 0,
                       y: statusBarOffset(),
                   width: statusBarWidth(),
                  height: notificationLabelHeight())
  }
  
  // MARK: - Screen orientation change
  @objc func updateStatusBarFrame() {
    if let view = isCustomView ? customView : label {
      view.frame = notificationLabelFrame()
    }
    if let statusBarView = statusBarView {
      statusBarView.isHidden = true
    }
  }
  
  // MARK: - on tap
  @objc func notificationTapped(recognizer: UITapGestureRecognizer) {
    notificationTappedClosure()
  }
  
  // MARK: - display helpers
  private func setupNotificationView(view : UIView) {
    view.clipsToBounds = true
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(tapGestureRecognizer)
    switch inAnimationStyle {
    case .top:
      view.frame = notificationLabelTopFrame()
    case .bottom:
      view.frame = notificationLabelBottomFrame()
    case .left:
      view.frame = notificationLabelLeftFrame()
    case .right:
      view.frame = notificationLabelRightFrame()
    }
  }
  
  private func createNotificationLabelWithMessage(message : String) {
    label = ScrollLabel()
    label.numberOfLines = multiline ? 0 : 1
    label.text = message
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = false
    label.font = font
    label.backgroundColor = backgroundColor
    label.textColor = textColor
    setupNotificationView(view: label)
  }
  
  private func createNotificationWithCustomView(view : UIView) {
    customView = UIView()
    // no autoresizing masks so that we can create constraints manually
    view.translatesAutoresizingMaskIntoConstraints = false
    customView?.addSubview(view)
    
    // setup auto layout constraints so that the custom view that is added
    // is constrained to be the same size as its superview, whose frame will
    // be altered
    customView?.addConstraint(NSLayoutConstraint(item: view,
                                                      attribute: .trailing, relatedBy: .equal, toItem: customView,
                                                      attribute: .trailing, multiplier: 1.0, constant: 0.0))
    customView?.addConstraint(NSLayoutConstraint(item: view,
                                                      attribute: .leading, relatedBy: .equal, toItem: customView,
                                                      attribute: .leading, multiplier: 1.0, constant: 0.0))
    customView?.addConstraint(NSLayoutConstraint(item: view,
                                                      attribute: .top, relatedBy: .equal, toItem: customView,
                                                      attribute: .top, multiplier: 1.0, constant: 0.0))
    customView?.addConstraint(NSLayoutConstraint(item: view,
                                                      attribute: .bottom, relatedBy: .equal, toItem: customView,
                                                      attribute: .bottom, multiplier: 1.0, constant: 0.0))
    
    if let customView = customView {
      setupNotificationView(view: customView)
    }
  }
  
  private func createNotificationWindow() {
    notificationWindow = WindowContainer(frame: UIScreen.main.bounds)
    notificationWindow?.backgroundColor = .clear
    notificationWindow?.isUserInteractionEnabled = true
    notificationWindow?.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleWidth, .flexibleHeight)
    notificationWindow?.windowLevel = UIWindow.Level.statusBar

    let rootViewController = ViewController()
    rootViewController.localSupportedInterfaceOrientations = supportedInterfaceOrientations
    rootViewController.localPreferredStatusBarStyle = preferredStatusBarStyle

    notificationWindow?.rootViewController = rootViewController
    notificationWindow?.notificationHeight = notificationLabelHeight()
  }
  
  private func createStatusBarView() {
    statusBarView = UIView(frame: notificationLabelFrame())
    statusBarView?.clipsToBounds = true
    if animationType == .replace {
      let statusBarImageView = UIScreen.main.snapshotView(afterScreenUpdates: true)
      statusBarView?.addSubview(statusBarImageView)
    }
    if let statusBarView = statusBarView {
      notificationWindow?.rootViewController?.view.addSubview(statusBarView)
      notificationWindow?.rootViewController?.view.sendSubviewToBack(statusBarView)
    }
  }
  
  // MARK: - frame changing
  private func firstFrameChange() {
    guard let view = isCustomView ? customView : label, statusBarView != nil else {return}
    view.frame = notificationLabelFrame()
    switch inAnimationStyle {
    case .top:
      statusBarView!.frame = notificationLabelBottomFrame()
    case .bottom:
      statusBarView!.frame = notificationLabelTopFrame()
    case .left:
      statusBarView!.frame = notificationLabelRightFrame()
    case .right:
      statusBarView!.frame = notificationLabelLeftFrame()
    }
  }
  
  private func secondFrameChange() {
    guard let view = isCustomView ? customView : label, statusBarView != nil else {return}
    switch outAnimationStyle {
    case .top:
      statusBarView!.frame = notificationLabelBottomFrame()
    case .bottom:
      statusBarView!.frame = notificationLabelTopFrame()
      view.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1.0)
      view.center = CGPoint.init(x: view.center.x, y: statusBarOffset() + notificationLabelHeight())
    case .left:
      statusBarView!.frame = notificationLabelRightFrame()
    case .right:
      statusBarView!.frame = notificationLabelLeftFrame()
    }
  }
  
  private func thirdFrameChange() {
    guard let view = isCustomView ? customView : label, statusBarView != nil else {return}
    statusBarView?.frame = notificationLabelFrame()
    switch outAnimationStyle {
    case .top:
      view.frame = notificationLabelTopFrame()
    case .bottom:
      view.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
    case .left:
      view.frame = notificationLabelLeftFrame()
    case .right:
      view.frame = notificationLabelRightFrame()
    }
  }
  
  // MARK: - display notification
  public func displayNotificationWithMessage(message : String, completion : @escaping () -> Void) {
    guard !isShowing else {return}
    isCustomView = false
    isShowing = true
    
    DispatchQueue.main.async { [weak self] in
      // create window
      self?.createNotificationWindow()
      
      // create label
      self?.createNotificationLabelWithMessage(message: message)
      
      // create status bar view
      self?.createStatusBarView()
      
      // add label to window
      guard let label = self?.label else {return}
      self?.notificationWindow?.rootViewController?.view.addSubview(label)
      self?.notificationWindow?.rootViewController?.view.bringSubviewToFront(label)
      self?.notificationWindow?.isHidden = false
      
      // checking for screen orientation change
      if let weakself = self {
        NotificationCenter.default.addObserver(weakself, selector: #selector(weakself.updateStatusBarFrame),
                                               name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
        
        // checking for status bar change
        NotificationCenter.default.addObserver(weakself, selector: #selector(weakself.updateStatusBarFrame),
                                               name: UIApplication.willChangeStatusBarFrameNotification, object: nil)
        
        // animate
        UIView.animate(withDuration: weakself.animationDuration,
                       animations: {[weak self] () -> Void in
                        self?.firstFrameChange()
          }, completion: {[weak self] (finished) -> Void in
          if let delayInSeconds = self?.label?.scrollTime() {
            _ = self?.performClosureAfterDelay(seconds: Double(delayInSeconds), closure: {() -> Void in
              completion()
            })
          }
        })
      }
    }
  }
  
  public func displayNotificationWithMessage(message : String, forDuration duration : TimeInterval) {
    displayNotificationWithMessage(message: message) {[weak self] () -> Void in
      self?.dismissHandle = self?.performClosureAfterDelay(seconds: duration, closure: {() -> Void in
        self?.dismissNotification()
      })
    }
  }
  
  public func displayNotificationWithAttributedString(attributedString : NSAttributedString, completion : @escaping () -> Void) {
    displayNotificationWithMessage(message: attributedString.string, completion: completion)
    label?.attributedText = attributedString
  }
  
  public func displayNotificationWithAttributedString(attributedString : NSAttributedString, forDuration duration : TimeInterval) {
    displayNotificationWithMessage(message: attributedString.string, forDuration: duration)
    label?.attributedText = attributedString
  }
  
  public func displayNotificationWithView(view : UIView, completion : @escaping () -> Void) {
    guard !isShowing else {return}
    isCustomView = true
    isShowing = true
    
    DispatchQueue.main.async { [weak self] in
      // create window
      self?.createNotificationWindow()
      
      // setup custom view
      self?.createNotificationWithCustomView(view: view)
      
      // create status bar view
      self?.createStatusBarView()
      
      // add view to window
      if let rootView = self?.notificationWindow?.rootViewController?.view,
        let customView = self?.customView {
        rootView.addSubview(customView)
        rootView.bringSubviewToFront(customView)
        self?.notificationWindow!.isHidden = false
      }
      
      if let weakself = self {
        // checking for screen orientation change
        NotificationCenter.default.addObserver(weakself, selector: #selector(weakself.updateStatusBarFrame),
                                               name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
        
        // checking for status bar change
        NotificationCenter.default.addObserver(weakself, selector: #selector(weakself.updateStatusBarFrame),
                                               name: UIApplication.willChangeStatusBarFrameNotification, object: nil)
        
        // animate
        UIView.animate(withDuration: weakself.animationDuration,
                       animations: {[weak self] () -> Void in
                        self?.firstFrameChange()
          }, completion: { (finished) -> Void in
          completion()
        })
      }
    }
  }
  
  public func displayNotificationWithView(view : UIView, forDuration duration : TimeInterval) {
    displayNotificationWithView(view: view) {[weak self] () -> Void in
      self?.dismissHandle = self?.performClosureAfterDelay(seconds: duration, closure: {[weak self] () -> Void in
        self?.dismissNotification()
      })
    }
  }
  
  public func dismissNotificationWithCompletion(completion : (() -> Void)?) {
    cancelDelayedClosure(delayedHandle: dismissHandle)
    notificationIsDismissing = true
    secondFrameChange()
    UIView.animate(withDuration: animationDuration,
    animations: {[weak self] () -> Void in
      self?.thirdFrameChange()
      }, completion: {[weak self] (finished) -> Void in
      guard let view = self?.isCustomView == true ? self?.customView : self?.label else {return}
      view.removeFromSuperview()
      self?.statusBarView?.removeFromSuperview()
      self?.notificationWindow?.isHidden = true
      self?.notificationWindow = nil
      self?.customView = nil
      self?.label = nil
      self?.isShowing = false
      self?.notificationIsDismissing = false
      NotificationCenter.default.removeObserver(self as Any)
      completion?()
    })
  }
  
  public func dismissNotification() {
    dismissNotificationWithCompletion(completion: nil)
  }

  private func cancelDelayedClosure(delayedHandle : DelayedClosureHandle?) {
    delayedHandle?(true)
  }

  private func performClosureAfterDelay(seconds : Double, closure: (() -> Void)?) -> DelayedClosureHandle? {
    var delayHandleCopy : DelayedClosureHandle?
    
    let delayHandle : DelayedClosureHandle = { (cancel : Bool) -> Void in
      if !cancel {
        DispatchQueue.main.async {
          closure?()
        }
      }
      delayHandleCopy = nil
    }
    
    delayHandleCopy = delayHandle
    DispatchQueue.main.asyncAfter(seconds: seconds, execute: {
      delayHandleCopy?(false)
    })
    
    return delayHandleCopy
  }
}

// MARK: - helper functions
private func systemVersionLessThan(value : String) -> Bool {
  return UIDevice.current.systemVersion.compare(value, options: .numeric) == .orderedAscending
}

// MARK: - ScrollLabel
private  class ScrollLabel : UILabel {
  // MARK: - Properties
  private let padding : CGFloat = 10.0
  private let scrollSpeed : CGFloat = 40.0
  private let scrollDelay : CGFloat = 1.0
  private var textImage : UIImageView!
  
  // MARK: - Setup
  override init(frame: CGRect) {
    super.init(frame: frame)
    textImage = UIImageView()
    addSubview(textImage)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func drawText(in rect: CGRect) {
    guard scrollOffset() > 0 else {
      textImage = nil
      super.drawText(in: rect.insetBy(dx: padding, dy: 0))
      return
    }
    guard let textImage = textImage else {return}
    var frame = rect
    frame.size.width = fullWidth() + padding * 2
    
    let renderer = UIGraphicsImageRenderer(bounds: frame)
    let image = renderer.image { (context) in
      super.drawText(in: frame)
    }
    textImage.image = image
    textImage.sizeToFit()
    UIView.animate(withDuration: TimeInterval(scrollTime() - scrollDelay), delay: TimeInterval(scrollDelay),
                        options: UIView.AnimationOptions(arrayLiteral: UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseInOut),
                     animations: {[weak self] () -> Void in
                       if let scrollOffset = self?.scrollOffset() {
                         textImage.transform = CGAffineTransform(translationX: -1 * scrollOffset, y: 0)
                       }
                     }, completion: nil)
  }
  
  // MARK: - methods
  private func fullWidth() -> CGFloat {
    guard let content = text else {return 0.0}
    let size = NSString(string: content).size(withAttributes: [NSAttributedString.Key.font: font!])
    return size.width
  }
  
  private func scrollOffset() -> CGFloat {
    guard numberOfLines == 1 else {return 0.0}
    let insetRect = bounds.insetBy(dx: padding, dy: 0.0)
    return max(0, fullWidth() - insetRect.size.width)
  }
  
  public func scrollTime() -> CGFloat {
    return scrollOffset() > 0 ? scrollOffset() / scrollSpeed + scrollDelay : 0
  }
}

// MARK: - WindowContainer
private class WindowContainer : UIWindow {
  var notificationHeight : CGFloat = 0.0
  
  override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    var height : CGFloat = 0.0
    if systemVersionLessThan(value: "8.0.0") && (UIApplication.app?.statusBarOrientation ?? .portrait).isLandscape {
      height = UIApplication.app?.statusBarFrame.size.width ?? 0
    } else {
      height = UIApplication.app?.statusBarFrame.size.height ?? 0
    }
    if point.y > 0 && point.y < (notificationHeight != 0.0 ? notificationHeight : height) {
      return super.hitTest(point, with: event)
    }
    return nil
  }
}

// MARK: - ViewController
private class ViewController : UIViewController {
  var localPreferredStatusBarStyle : UIStatusBarStyle = .default
  var localSupportedInterfaceOrientations : UIInterfaceOrientationMask = []
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return localPreferredStatusBarStyle
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return localSupportedInterfaceOrientations
  }
  
  override var prefersStatusBarHidden: Bool {
    let statusBarHeight = UIApplication.app?.statusBarFrame.size.height
    return !(statusBarHeight > 0)
  }
}
