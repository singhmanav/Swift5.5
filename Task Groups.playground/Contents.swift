import UIKit

var greeting = "Hello, playground"


func publish() {
  let group = DispatchGroup()
  var anyError: Error?
  
  for _ in 1...3 {
    group.enter()
    downloadImage { result in
      group.leave()
    }
  }
  group.notify(queue: .main) {
  }
  
}

func publish() async {
  
  // withTaskGroup
  await withThrowingTaskGroup(of: UIImage.self) { taskGroup in
    for _ in 1...3 {
      taskGroup.addTask { await downloadImage()! }
    }
  }
  
}

class Tasks {
  func getTask() {
    Task.init(priority: .background) {
      await publish()
    }
  }
}





func downloadImage(completion:(UIImage) -> Void) {
  completion(UIImage())
}

func downloadImage() async -> UIImage? {
  await withCheckedContinuation { countinuation in
    countinuation.resume(returning: UIImage())
  }
}

publish()
Tasks.init().getTask()
