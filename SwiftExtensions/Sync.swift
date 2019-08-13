//
//  Sync.swift
//  SwiftExtensions
//
//  Created by Paul King on 9/6/18.
//

/**
 *  Simple way to perform an asynchronous closure synchronously
 *
 *  Simply use the **run** method to execute the given closure that executes something with an
 *  asynchronous closure and signal when its complete.
 *
 *  Sync.run { sync in somethingWithAsyncCallback { sync.signal() } }
 */
public struct Sync {
  let semaphore = DispatchSemaphore(value: 0)
  var timeout: DispatchTime
  let closure: (Sync) -> Void

  private init(timeoutSeconds: Double?, closure: @escaping (Sync) -> Void) {
    let timeoutSeconds = timeoutSeconds ?? 0
    timeout = timeoutSeconds == 0 ? DispatchTime.distantFuture : DispatchTime.now() + DispatchTimeInterval.microseconds((Int(timeoutSeconds * 1000000)))
    self.closure = closure
  }
  
  /**
   Signal to wakeup waiters
   */
  public func signal() {
    semaphore.signal()
  }
  
  /**
   Convenience method that will execute the given closure and wait for completion. The Sync must
   be signalled from inside the closure.
   :param: closure Function to execute synchronously
   */
  public func execute(threadWarning: Bool) -> Sync {
    DispatchQueue.global().async {
      self.closure(self)
    }
    if Thread.isMainThread {
      if threadWarning {
        dlog("Warning! Using semaphores on the main thread would cause a deadlock! Skipping wait...")
        for entry in Thread.callStackSymbols {
          if let mangledName = entry.split(separator: "$").second?.split(separator: " ").first?.string {
            if let callerName = try? parseMangledSwiftSymbol(mangledName).text {
              dlogNoHeader(callerName)
            } else {
              dlogNoHeader(mangledName)
            }
          }
        }
      }
      return self
    }
    _ = semaphore.wait(timeout: timeout)
    return self
  }
  
  /**
   Convenience static method that will execute the given closure and wait for completion.
   :param: timeoutSeconds Maximum time in seconds. Passing a value of 0.0 will wait forever.
   :param: closure Function to execute synchronously
   */
  @discardableResult
  public static func execute(timeoutSeconds: Double?=nil, threadWarning: Bool=true, closure: @escaping (Sync) -> Void) -> Sync {
    let sync = Sync(timeoutSeconds: timeoutSeconds, closure: closure)
    return sync.execute(threadWarning: threadWarning)
  }
}
