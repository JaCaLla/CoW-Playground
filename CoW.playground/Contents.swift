import UIKit

final class Wrapper {
    var data: [Int]
    
    init(data: [Int]) {
        self.data = data
    }
}

struct CoWExample {
    private var storage: Wrapper

    init(data: [Int]) {
        self.storage = Wrapper(data: data)
    }

    mutating func modifyData() {
        print("Memory @ before updating: \(Unmanaged.passUnretained(storage).toOpaque())")
        
        if !isKnownUniquelyReferenced(&storage) {
            print("Making a copy of the data before modifying it.")
            storage = Wrapper(data: storage.data) // Created a copy
        } else {
            print("Update without copy, unique reference.")
        }

        storage.data.append(4)  // Modify array from class inside
        print("@ Memory after updaing: \(Unmanaged.passUnretained(storage).toOpaque())")
    }

    func printData(_ prefix: String) {
        print("\(prefix) Data: \(storage.data) | Memory @: \(Unmanaged.passUnretained(storage).toOpaque())")
    }
}

// Use  Copy-on-Write
var obj1 = CoWExample(data: [1, 2, 3])
var obj2 = obj1  // Both instances share same memory @

print("Before updating obj2:")
obj1.printData("obj1:")
obj2.printData("obj2:")

print("\nUpdating obj2:")
obj2.modifyData() // Here will take place copy when there's a new reference

print("\nAfter updating obj1:")
obj1.printData("obj1:")
obj2.printData("obj2:")
