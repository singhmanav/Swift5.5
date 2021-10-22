import UIKit

/*:
The term “checked” continuation means that Swift is performing runtime checks on our behalf: are we calling `resume()` once and only once?
 
 This is important, because if you never resume the continuation then you will leak resources, but if you call it twice then you’re likely to hit problems.

 
 **Important:** To be crystal clear, you *must* resume your continuation exactly once.

 As there is a runtime performance cost of checking your continuations, Swift also provides a `withUnsafeContinuation()` function
 that works in exactly the same way except does *not* perform runtime checks on your behalf.
 This means Swift won’t warn you if you forget to resume the continuation, and if you call it twice then the behavior is undefined.
Because these two functions are called in the same way, you can switch between them easily. So, it seems likely people will use `withCheckedContinuation()` while writing their functions so Swift will emit warnings and even trigger crashes if the continuations are used incorrectly, but some may then switch over to `withUnsafeContinuation()` as they prepare to ship if they are affected by the runtime performance cost of checked continuations.



 func withUnsafeThrowingContinuation<T>(
     operation: (UnsafeThrowingContinuation<T, Error>) -> ()
 ) async throws -> T

 func withUnsafeContinuation<T>(
     operation: (UnsafeContinuation<T>) -> ()
 ) async -> T

 func withCheckedContinuation<T>(function: String = #function, _ body: (CheckedContinuation<T, Never>) -> Void) async -> T
 func withCheckedThrowingContinuation<T>(function: String = #function, _ body: (CheckedContinuation<T, Error>) -> Void) async throws -> T

*/


let msg = ["Swift 5.5 release", "Apple acquires Apollo"]

func fetchLatestNews(completion: @escaping ([String]) -> Void) {
    DispatchQueue.main.async {
        print("GCD ...")
        completion(msg)
    }
}
//       Suspends the current task,
//       then calls the given closure with a checked throwing continuation for the current task.
      
      
//      Async functions can now be suspended using the withUnsafeContinuation and withUnsafeThrowingContinuation functions. These both take a closure, and then suspend the current async task, executing that closure with a continuation value for the current task. The program must use that continuation at some point in the future to resume the task, passing in a value or error, which then becomes the result of the withUnsafeContinuation call in the resumed task.
      
//      The withCheckedThrowingContinuation(function:_:) method is marked as async, therefore we must call it using the await keyword. On top of that, since we are using the “throwing” variant of it, we need to use the try keyword as well (just like calling a normal function that throws).
//      We must call a resume method exactly once on every execution path throughout the async task. Resuming from a continuation more than once is undefined behavior. Whereas never resuming will leave the async task in a suspended state indefinitely, we call this continuation leak.
//      The return type of withCheckedThrowingContinuation(function:_:) method must match with the resume(returning:) method’s parameter data type, which is [Album].


func fetchLatestNews() async -> [String] {        // wapper
    await withCheckedContinuation { continuation in
        print("async / await ...")
        fetchLatestNews { items in                // the oringal code
            continuation.resume(returning: items) // Swift will check that is called once!
        }
    }
}
/*:
With that in place we can now get our original functionality in an async function, like this:
*/
func printNews() async {
    print("Start")
    let items = await fetchLatestNews()
    print("These are the items",items)
    
    print("End")
    for item in items {
        print(item)
    }
}

//print("These are the items")
//
//Task.init {
//    await printNews()
//}





