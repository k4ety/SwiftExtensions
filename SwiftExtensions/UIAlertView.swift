//
//  UIAlertView.swift
//  SwiftExtensions
//
//  Created by Paul King on 8/14/18.
//

import Foundation

extension UIAlertController {
  // Adapted from https://oleb.net/2018/uialertcontroller-textfield/
  public enum TextInputResult {
    /// The user tapped Cancel.
    case cancel
    /// The user tapped the OK button. The payload is the text they entered in the text field.
    case ok(String)
  }

  public convenience init(title: String,
                          message: String? = nil,
                          cancelButtonTitle: String,
                          okButtonTitle: String,
                          allowEmptyText: Bool,
                          textFieldConfiguration: ((UITextField) -> Void)? = nil,
                          onCompletion: @escaping (TextInputResult) -> Void) {
    self.init(title: title, message: message, preferredStyle: .alert)

    var textFieldDidChangeObserver: Any?

    // Every `UIAlertAction` handler must eventually call this
    func finish(result: TextInputResult) {
      if let observer = textFieldDidChangeObserver {
        NotificationCenter.default.removeObserver(observer)
      }
      onCompletion(result)
    }

    let cancelAction = UIAlertAction(title: cancelButtonTitle,
      style: .cancel,
      handler: { _ in
        finish(result: .cancel)
      })
    let createAction = UIAlertAction(title: okButtonTitle,
      style: .default,
      handler: { [unowned self] _ in
        finish(result: .ok(self.textFields?.first?.text ?? ""))
      })
    addAction(cancelAction)
    addAction(createAction)
    preferredAction = createAction

    addTextField(configurationHandler: { textField in
      textFieldConfiguration?(textField)
      if allowEmptyText == false {
        // Monitor the text field to disable
        // the OK button for empty inputs
        textFieldDidChangeObserver = NotificationCenter.default
//          .addObserver(forName: .textDidChangeNotification,  // pre iOS12
          .addObserver(forName: UITextField.textDidChangeNotification,
            object: textField,
            queue: .main) { _ in
              createAction.isEnabled = !(textField.text?.isEmpty ?? true)
            }
      }
    })
    // Start with a disabled OK button if necessary
    if allowEmptyText == false {
      createAction.isEnabled = !(textFields?.first?.text?.isEmpty ?? true)
    }
  }

// Adapted from https://gist.github.com/dkarbayev/3e4bc6f5dc9fad3d7dcba0fad6a078a7
/// Creates a fully configured alert controller with one text field for text input, a Cancel and
/// and an OK button.
///
/// - Parameters:
///   - title: The title of the alert view.
///   - message: The message of the alert view.
///   - cancelButtonTitle: The title of the Cancel button.
///   - okButtonTitle: The title of the OK button.
///   - validationRegex: A regular expression in string format; the OK button will remain disabled
///     until the text does not match this regex.
///   - textFieldConfiguration: Use this to configure the text field (e.g. set placeholder text).
///   - onCompletion: Called when the user closes the alert view. The argument tells you whether
///     the user tapped the Close or the OK button (in which case this delivers the entered text).
  public convenience init(title: String, message: String? = nil,
                          cancelButtonTitle: String, okButtonTitle: String,
                          validationRegex: String,
                          textFieldConfiguration: ((UITextField) -> Void)? = nil,
                          onCompletion: @escaping (TextInputResult) -> Void) {
    self.init(title: title, message: message, preferredStyle: .alert)

    var textFieldDidChangeObserver: Any?

    // Every `UIAlertAction` handler must eventually call this
    func finish(result: TextInputResult) {
      if let observer = textFieldDidChangeObserver {
        NotificationCenter.default.removeObserver(observer)
      }
      onCompletion(result)
    }

    func isTextValid(text: String) -> Bool {
      return text.range(of: validationRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
      finish(result: .cancel)
    })
    let createAction = UIAlertAction(title: okButtonTitle, style: .default, handler: { [unowned self] _ in
      finish(result: .ok(self.textFields?.first?.text ?? ""))
    })
    addAction(cancelAction)
    addAction(createAction)
    preferredAction = createAction

    addTextField(configurationHandler: { textField in
      textFieldConfiguration?(textField)
      // Monitor the text field to disable the OK button when text does not match the regular expression
      textFieldDidChangeObserver = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { _ in
        createAction.isEnabled = isTextValid(text: textField.text ?? "")
      }
    })

    // Start with a disabled OK button if necessary
    if !isTextValid(text: self.textFields?.first?.text ?? "") {
      createAction.isEnabled = !(textFields?.first?.text?.isEmpty ?? true)
    }
  }
}
