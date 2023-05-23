import Foundation

class MulticastDelegate <T> {
  private var delegates = [WeakWrapper]()

  func add(delegate: T) {
    // If delegate is a class, add it to our weak reference array
    delegates.append(WeakWrapper(value: delegate as AnyObject))
  }
  
  func remove(delegate: T) {
    // If delegate is an object, let's loop through weakDelegates to find it.
    for (index, delegateInArray) in delegates.enumerated().reversed() {
      // If we have a match, remove the delegate from our array
      if delegateInArray.value === delegate as AnyObject {
        delegates.remove(at: index)
      }
    }
  }
  
  func invoke(invocation: (T) -> ()) {
    // Enumerating in reverse order prevents a race condition from happening when removing elements.
    for (index, delegate) in delegates.enumerated().reversed() {
      // Since these are weak references, "value" may be nil
      // at some point when ARC is 0 for the object.
      // Else, ARC killed it, get rid of the element from our array
      if let delegate = delegate.value as? T {
        invocation(delegate)
      }
      else {
        delegates.remove(at: index)
      }
    }
  }
}

func += <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
  left.add(delegate: right)
}

func -= <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
  left.remove(delegate: right)
}

private class WeakWrapper {
  weak var value: AnyObject?
  
  init(value: AnyObject) {
    self.value = value
  }
}
