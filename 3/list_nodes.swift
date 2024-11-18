class Node<T> {
    var value: T
    var next: Node<T>? = nil
    
    init(value: T) {
        self.value = value
    }
    
    func addNext(nxt: Node<T>) {
        self.next = nxt
    }
}

class List<T> {
    var head: Node<T>? = nil
    
    init(_ items: T...) {
        if items.count == 0 {
            return
        }
        
        let value: T = items[0]
        self.head = Node<T>(value: value)
        var curr = head
        for item in items.dropFirst() {
            let newNode = Node(value: item)
            curr!.next = newNode
            curr = newNode
        }
    }
}


extension List {
    subscript(index: Int) -> T? {
        var curr: Node<T>? = head
        for _ in 0..<index {
            curr = curr!.next
        }
        
        return curr!.value
    }
}

extension List {
    var length: Int {
        if(head == nil) {
            return 0
        }
        var curr: Node<T>? = head
        var counter = 1
        while (curr!.next != nil) {
            counter += 1
            curr = curr!.next
        }
        return counter
    }
}

extension List {
    func reverse() {
        let len = self.length
        
        if len < 2 {
            return
        }
        
        if len == 2 {
            let curr: Node<T>? = self.head
            let next: Node<T>? = curr!.next
            next!.next = curr
            curr!.next = nil
            self.head = next
        }
        
        else {
            var prev: Node<T>? = nil
            var curr: Node<T>? = self.head
            var next: Node<T>? = nil
            
            while curr != nil {
                next = curr!.next
                curr!.next = prev
                prev = curr
                curr = next
            }
            
            self.head = prev
        }
    }
}


// // l.reverse()
// // for i in 0..<len {
// //     print(l[i]!)
// // }

 
// // var l = [1,2,3,4]
// // print(l.contains(1))
// // l.push(5)
// // print(l.contains(5))


// extension List {
//     func toSet() {
//         var unique: [T] = []
        
//         var curr: Node<T>? = self.head
//         var next: Node<T>? = nil
        
//         let len = self.length
        
//         for _ in 0..<len {
//             let val = curr!.value
//             if unique.contains(val) {
//                 unique.append(curr!.value)
//                 curr!.next = next!.next
//                 next = nil
//             }
//             curr = curr!.next
//             next = curr!.next
//         }
        
//     }
// }

// // var list: List<String> = List("Hello", "World", "!")
// // print(list[0]!)
// // print(list[1]!)
// // print(list[2]!)

// // print(list.length)




//_________________________________________

//ne trqbva da equatable
extension List {
    func flatten() -> List {
        
        return self
    }
    
    private func flattenHelper(list: List<T>?, result: inout List<Any>?) {

        var curr: List<T>? = list

        while curr != nil {

            if let list = curr.value as? List<Any> {
                flattenHelper(list: list, result: &result)
            } 
            else {
                result.next = List<Any>(curr.value)
            }
            curr = curr!.next
        }
    }
    
}


private func flattenHelper(list: List<T>?, result: inout [Any]) {
    var curr: List<T>? = list
    while curr != nil {
        if let list = curr?.value as? List<Any> {
            flattenHelper(node: list, result: &result)
        } 
        else if let list = current?.value as? List<T> {
            flattenHelper(node: list as? List<Any>, result: &result)
        } 
        else {
            result.append(current!.value)
        }
        current = current?.next
    }
}