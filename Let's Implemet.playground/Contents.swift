import UIKit

func makeAPICall() throws -> String? {
  let path = "https://jsonplaceholder.typicode.com/users"
  
  guard let url = URL(string: path) else {
    throw NetworkError.urlError
  }
  
  var result: String?
  var error: NetworkError?
  let semaphore = DispatchSemaphore(value: 0)
  
  URLSession.shared.dataTask(with: url) { (data, _, _) in
    if let data = data {
      result = String(data: data, encoding: .utf8)
    } else {
      error = NetworkError.dataNotFound
    }
    semaphore.signal()
  }.resume()
  
  _ = semaphore.wait(wallTimeout: .distantFuture)
  
  if let error = error { throw error }
  return result
}

func fetchData() {
  DispatchQueue.global(qos: .utility).async {
    do{
      let result = try makeAPICall()
      print(result ?? "")
    }
    catch {
      print(error)
    }
  }
}
load()



enum NetworkError: Error {
  case invalidPassword
  case dataNotFound
  case urlError
  case unexpected(code: Int)
}
