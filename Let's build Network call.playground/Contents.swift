import UIKit

func fetchAPI(url: URL, completion: @escaping (Result<String, Error>) -> ()) {
  URLSession.shared.dataTask(with: url) { data, response, error in
    if let error = error {
      completion(.failure(error))
      return
    }
    guard let data = data else {
      completion(.failure(NetworkError.dataNotFound))
      return
    }
    completion(.success(String(data: data, encoding: .utf8)!))
  }
  .resume()
}

func fetchDataUsingClosure(completion: @escaping (Result<String, Error>) -> ()) {
  fetchAPI(url: URL(string: "https://jsonplaceholder.typicode.com/users")!,completion: completion)
}

fetchDataUsingClosure { result in
  switch result {
  case .success(let value) :
    print(value)
  case .failure(let error):
    print(error)
  }
}




func fetchData(with url: URL) async throws -> String {
  return try await withCheckedThrowingContinuation { continuation in
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        continuation.resume(throwing: error)
      } else if let data = data {
        continuation.resume(returning: String(data: data, encoding: .utf8)!)
      } else {
        continuation.resume(throwing: NetworkError.dataNotFound)
      }
    }
    task.resume()
  }
}




func fetchData() {
  Task {
    do {
      let users: String = try await fetchData(with: URL(string: "https://jsonplaceholder.typicode.com/users")!)
      print(users)
    } catch {
      print(error)
    }
    
  }
}

fetchData()











enum NetworkError: Error {
  case invalidPassword
  case dataNotFound
  case urlError
  case unexpected(code: Int)
}

extension Data {
  var prettyPrintedJSONString: NSString? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
          let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
    
    return prettyPrintedString
  }
}
