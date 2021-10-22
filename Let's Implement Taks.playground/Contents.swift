import UIKit

public struct Task<Success: Sendable, Failure: Error>: Sendable {
  public var result: Result<Success, Failure> {
      get async {
        do {
          return .success(try await value)
        } catch {
          return .failure(error as! Failure) 
        }
      }
    }
  
  public var value: Success
//  {
//      get async throws {
//        return try await
//      }
//    }
  
  public func cancel() {
      
    }
  
}

//TaskPriority
//
//public static let high
//
// public static var medium
// public static let low
//
// public static let userInitiated
// public static let utility
// public static let background
//
// @available(*, deprecated, renamed: "medium")
// public static let `default`



/*
 Sendable and @Sendable Closures :-
 SE-0302 adds support for sendable data. Sendable data is a data that can safely be transferred to another thread. This is accomplished through a new Sendable protocol, and an @Sendable attribute for functions.
 We can send many things safely to threads like, Swift’s core value types, including Bool,Int,String, and similar, Standard library collections, Tuples, etc.
 Swift lets us use the @Sendable attribute on functions or closure to mark them as working concurrently.
 */


