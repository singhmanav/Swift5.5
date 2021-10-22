import UIKit


//@asyncHandler func callAsyncFromSync() {
//  calculateInSync()
//}

//func runAsync() {
//  runAsyncAndBlock {
//      print("task started")
//      let data = try! await download()
//      print(String(data: data, encoding: .utf8)!)
//  }
//}


//Important: Making a function asynchronous doesn’t mean it magically runs concurrently with other code, which means unless you specify otherwise calling multiple async functions will still run them sequentially.
//All the `async` functions you’ve seen so far have in turn been called by other `async` functions, which is intentional


func calculateInSync() {
  Task {
    let x = await calculateFirstNumber()
    let y = await calculateSecondNumber()
    print(x)
    print(y)
  }
}

func calculateInAsync() {
  Task {
    async let x = calculateFirstNumber()
    async let y = calculateSecondNumber()
    await print( x + y)
  }
}

func calculateFirstNumber() async -> Int {
  return await withUnsafeContinuation { continuation in
    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
      continuation.resume(returning: .random(in: 1 ... 100))
      print("A")
    }
  }
}

func calculateSecondNumber() async -> Int {
  return await withUnsafeContinuation { continuation in
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      continuation.resume(returning: .random(in: 100 ... 200))
      print("B")
    }
  }
}





//Read-only computed properties and subscripts can now define their get accessor to be async and/or throws, by writing one or both of those keywords between the get and {.
//  Thus, these members can now make asynchronous calls or throw errors in the process of producing a value:

struct AccountManager{
  func getLastTransaction() async -> Transaction { return Transaction()}
  func getTransactions() async -> [Transaction] {return [Transaction()]}
}
enum BankError: Error {
  case notInYourFavor
}
struct Transaction {}
class BankAccount: FinancialAccount {
  var manager: AccountManager?

  var lastTransaction: Transaction {
    get async throws {
      guard manager != nil else { throw BankError.notInYourFavor }
      return await manager!.getLastTransaction()
    }
  }

  subscript(_ day: Date) -> [Transaction] {
    get async {
      return await manager?.getTransactions() ?? []
    }
  }
}

protocol FinancialAccount {
  associatedtype T
  var lastTransaction: T { get async throws }
  subscript(_ day: Date) -> [T] { get async }
}




