class List<T> {
    var value: T
    var next: List<T>? = nil
    
    init(_ items: T...) {
        
        self.value = items[0]
        var curr = self
        
        for item in items.dropFirst() {
            let newNode = List<T>(item)
            curr.next = newNode
            curr = curr.next!
            
        }
    }
}

extension List {
    subscript(index: Int) -> T? {
        var curr: List<T>? = self
        for _ in 0..<index {
            curr = curr!.next
        }
        
        return curr!.value
    }
}

extension List {
    var length: Int {
        if(next == nil) {
            return 1
        }
        var curr: List<T>? = self
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
        var curr: List<T>? = self
        var values: [T] = []
        
        while(curr != nil) {
            values.append(curr!.value)
            curr = curr!.next
        }
        curr = self
        while(curr != nil) {
            curr!.value = values.removeLast()
            curr = curr!.next
        }
    }
}

extension List where T: Hashable{
    func toSet() {
        var unique: [T] = [self.value]
        
        var curr: List<T>? = self
        var next: List<T>? = self.next

        while next != nil {
            let val = next!.value
            
            if unique.contains(val) {
                curr!.next = next!.next
                next = curr!.next
            }
            
            else {
                unique.append(val) 
                
                curr = curr!.next
                next = curr!.next
            }
            
        }
    }
}

extension List where T == Any {
    func flatten() -> List {
        let res: List<Any> = List<Any>(0)
        var optRes: List<Any>? = res
        
        flattenHelper(list:self, result: &optRes)
        
        return res.next!
    }
    
    private func flattenHelper(list: List<Any>?, result: inout List<Any>?) {

        var curr: List<Any>? = list

        while curr != nil {

            if let inner = curr!.value as? List<Any> {
                flattenHelper(list: inner, result: &result)
            }
            else {
                result!.next = List<Any>(curr!.value)
                result = result!.next
            }
            curr = curr!.next
        }
    }
}

extension List {
    func append(list: List<T>) {
        var curr: List<T>? = self
        var next: List<T>? = self.next
        while next != nil {
            curr = curr!.next
            next = curr!.next
        }
        
        curr!.next = list
    }

    func append(elem: T) {
        self.append(List<T>(elem))
    }
}