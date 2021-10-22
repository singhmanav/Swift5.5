import UIKit



/*  [SE-0296](https://github.com/apple/swift-evolution/blob/main/proposals/0296-async-await.md)   - introduces asynchronous (async) functions into Swift,
    allowing us to run complex asynchronous code almost is if it were synchronous.
    This is done in two steps: marking async functions with the new `async` keyword,
      then calling them using the `await` keyword, similar to other languages such as C# and JavaScript.
*/

// Example of synchronous

public func dummyFunc() {
  print("A")
  print("B")
  DispatchQueue.main.async {
    print("C")
  }
  print("D")
}

//    We have been writing synchronous functions and methods
//    Outcome of sync - run to completion, throw an error, or never return
//    But we cannot suspend and resume these as per our convenience
//    An asynchronous function or method still does one of those three things,
//      but it can also pause in the middle when it’s waiting for something.

public func asyncFunc() {
  Task {
    
  }
}




