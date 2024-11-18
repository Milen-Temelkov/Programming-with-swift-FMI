protocol Fillable {
    var color: String { set get }
}


protocol VisualComponent: Fillable {
    var boundingBox: Rect { get }
    var parent: VisualComponent? { set get }
    func draw()
}


protocol VisualGroup: VisualComponent {
    var numChildren: Int { get }
    var children: [VisualComponent] { get }
    mutating func add(child: VisualComponent)
    mutating func remove(child: VisualComponent)
    mutating func removeChild(at: Int)
}


struct Point {
    var x: Double
    var y: Double
}


extension Point: Equatable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func != (lhs: Point, rhs: Point) -> Bool {
        return !(lhs == rhs)
    }
}



struct Rect {
    var top:Point
    var width: Double
    var height: Double
    
    init(x: Double, y: Double, width: Double, height: Double) {
        top = Point(x: x, y: y)
        self.width = width
        self.height = height
    }
}


func isIn (lhs: Rect, rhs: Rect) -> Bool {
    let maxX_lhs = lhs.top.x + lhs.width
    let maxY_lhs = lhs.top.y + lhs.height

    let maxX_rhs = rhs.top.x + rhs.width
    let maxY_rhs = rhs.top.y + rhs.height
    
    return  lhs.top.x >= rhs.top.x &&
            lhs.top.y >= rhs.top.y &&
            maxX_lhs <= maxX_rhs &&
            maxY_lhs <= maxY_rhs
}

func extractBoundaries (minX: inout Double, maxX: inout Double, minY: inout Double, maxY: inout Double, point: Point) {
        if (point.x < minX) {
            minX = point.x
        }
        
        if (point.x > maxX) {
            maxX = point.x
        }
        
        if (point.y < minY) {
            minY = point.y
        }
        
        if (point.y > maxY) {
            maxY = point.y
        }
}


func == (lhs: VisualComponent, rhs: VisualComponent) -> Bool {
    switch lhs {
            case let circle as Circle: 
                if let circle2 = rhs as? Circle {
                    return circle == circle2
                }
                else {
                    return false
                }
            
            case let rectangle as Rectangle: 
                if let rectangle2 = rhs as? Rectangle {
                    return rectangle == rectangle2
                }
                else {
                    return false
                }
            
            case let triangle as Triangle: 
                if let triangle2 = rhs as? Triangle {
                    return triangle == triangle2
                }
                else {
                    return false
                }

            case let path as Path:
                if let path2 = rhs as? Path {
                    return path == path2
                } 
                else {
                    return false
                }

            case let hstack as HStack:
                if let hstack2 = rhs as? HStack {
                    return hstack == hstack2
                } 
                else {
                    return false
                }
                
            case let vstack as VStack:
                if let vstack2 = rhs as? VStack {
                    return vstack == vstack2
                } 
                else {
                    return false
                }
            
            case let zstack as ZStack:
                if let zstack2 = rhs as? ZStack {
                    return zstack == zstack2
                } 
                else {
                    return false
                }
            default: 
                return false
            
        }
}

func != (lhs: VisualComponent, rhs: VisualComponent) -> Bool {
    return !(lhs == rhs)
}


struct Path {
    private var _points: [Point]
    private var _color: String
    private var _boundingBox: Rect
    private var _parent: VisualComponent? = nil
    
    var points: [Point] {
        return self._points
    }
    
    init(points: [Point], color: String) {
        var minX = points[0].x, maxX = points[0].x
        var minY = points[0].y, maxY = points[0].y
        
        for point in points {
            extractBoundaries(minX: &minX, maxX: &maxX, minY: &minY, maxY: &maxY, point: point)
        }
        
        self._boundingBox = Rect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        self._color = color
        self._points = points
    }
}

extension Path: Equatable {
    static func == (lhs: Path, rhs: Path) -> Bool {
        
        let len = lhs.points.count

        if len != rhs.points.count {
            return false
        }

        for i in 0..<len {
            if lhs.points[i] != rhs.points[i] {
                return false
            }
        }
        return true
    }
    
    static func != (lhs: Path, rhs: Path) -> Bool {
        return !(lhs == rhs)
    }

    static func == (lhs: Path, rhs: VisualComponent) -> Bool {
        return false
    }

    static func == (lhs: VisualComponent, rhs: Path) -> Bool {
        return false
    }

    static func != (lhs: Path, rhs: VisualComponent) -> Bool {
        return true
    }

    static func != (lhs: VisualComponent, rhs: Path) -> Bool {
        return true
    }
}

extension Path: Fillable {    
    var color: String {
        get {
            return self._color
        }
        
        set (newColor) {
            self._color = newColor
        }
    }
}

extension Path: VisualComponent {
    
    var boundingBox: Rect {
            return self._boundingBox
    }
    
    var parent: VisualComponent? {
        get {
            return _parent
        }
        
        set (newParent) {
            self._parent = newParent
        }
    }
    
    func draw() {
        print("Path")
        print("Top left corner coordinates: (\(_boundingBox.top.x), \(_boundingBox.top.y))")
        print("Height: \(_boundingBox.height)")
        print("Width: \(_boundingBox.width)")
    }
}



struct Triangle {
    private var _a: Point
    private var _b: Point
    private var _c: Point
    private var _color: String
    private var _boundingBox: Rect
    private var _parent: VisualComponent? = nil

    var a: Point {
        return self._a
    }
    
    var b: Point {
        return self._b
    }
    
    var c: Point {
        return self._c
    }

    init(a: Point, b: Point, c: Point, color: String) {
        var minX = a.x, maxX = a.x
        var minY = a.y, maxY = a.y
        
        //b extract
        extractBoundaries(minX: &minX, maxX: &maxX, minY: &minY, maxY: &maxY, point: b)
        
        //c extract
        extractBoundaries(minX: &minX, maxX: &maxX, minY: &minY, maxY: &maxY, point: c)
        
        self._boundingBox = Rect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        self._color = color
        self._a = a
        self._b = b
        self._c = c
    }
}

extension Triangle: Equatable {
    static func == (lhs: Triangle, rhs: Triangle) -> Bool {
        return  lhs.a == rhs.a &&
                lhs.b == rhs.b &&
                lhs.c == rhs.c 
    }
    
    static func != (lhs: Triangle, rhs: Triangle) -> Bool {
        return !(lhs == rhs)
    }
    
    static func == (lhs: Triangle, rhs: VisualComponent) -> Bool {
        return false
    }

    static func == (lhs: VisualComponent, rhs: Triangle) -> Bool {
        return false
    }
    
    static func != (lhs: Triangle, rhs: VisualComponent) -> Bool {
        return true
    }
    static func != (lhs: VisualComponent, rhs: Triangle) -> Bool {
        return true
    }
}

extension Triangle: Fillable {
    var color: String {
        get {
            return self._color
        }
        
        set (newColor) {
            self._color = newColor
        }
    }
}

extension Triangle: VisualComponent {
    var boundingBox: Rect {
            return self._boundingBox
    }
    
    var parent: VisualComponent? {
        get {
            return _parent
        }
        
        set (newParent) {
            self._parent = newParent
        }
    }
    
    func draw() {
        print("Triangle")
        print("Top left corner coordinates: (\(_boundingBox.top.x), \(_boundingBox.top.y))")
        print("Height: \(_boundingBox.height)")
        print("Width: \(_boundingBox.width)")
    }
}



struct Rectangle {
    private var _p: Point
    private var _height: Double
    private var _width: Double
    private var _color: String
    private var _boundingBox: Rect
    private var _parent: VisualComponent? = nil
    
    var p: Point {
        return self._p
    }
    
    var height: Double {
        return self._height
    }
    
    var width: Double {
        return self._width
    }
    
    init(x: Double, y: Double, width: Double, height: Double, color: String) {
        self._color = color
        self._boundingBox = Rect(x: x, y: y, width: width, height: height)
        self._p = Point(x: x, y: y)
        self._height = height
        self._width = width
    }
}

extension Rectangle: Equatable {
    static func == (lhs: Rectangle, rhs: Rectangle) -> Bool {
        return  lhs.p == rhs.p &&
                lhs.height == rhs.height &&
                lhs.width == rhs.width
    }
    
    static func != (lhs: Rectangle, rhs: Rectangle) -> Bool {
        return  !(lhs == rhs)
    }
    
    static func == (lhs: Rectangle, rhs: VisualComponent) -> Bool {
        return false
    }
    
    static func == (lhs: VisualComponent, rhs: Rectangle) -> Bool {
        return false
    }

    static func != (lhs: Rectangle, rhs: VisualComponent) -> Bool {
        return true
    }

    static func != (lhs: VisualComponent, rhs: Rectangle) -> Bool {
        return true
    }
}

extension Rectangle: Fillable {
    var color: String {
        get {
            return self._color
        }
        
        set (newColor) {
            self._color = newColor
        }
    }
}

extension Rectangle: VisualComponent {
    var boundingBox: Rect {
            return self._boundingBox
    }
    
    var parent: VisualComponent? {
        get {
            return _parent
        }
        
        set (newParent) {
            self._parent = newParent
        }
    }
    
    func draw() {
        print("Rectangle")
        print("Top left corner coordinates: (\(_boundingBox.top.x), \(_boundingBox.top.y))")
        print("Height: \(_boundingBox.height)")
        print("Width: \(_boundingBox.width)")
    }
}



struct Circle {
    private var _center: Point
    private var _radius: Double
    private var _color: String
    private var _boundingBox: Rect
    private var _parent: VisualComponent? = nil
    
    var center: Point {
        return self._center
    }
    
    var radius: Double {
        return self._radius
    }

    init(x: Double, y: Double, r: Double, color: String) {
        self._color = color
        self._boundingBox = Rect(x: x - r, y: y - r, width: 2 * r, height: 2 * r)
        self._center = Point(x: x, y: y)
        self._radius = r
    }
}

extension Circle: Equatable {
    static func == (lhs: Circle, rhs: Circle) -> Bool {
        return  lhs.center == rhs.center &&
                lhs.radius == rhs.radius
    }
    
    static func != (lhs: Circle, rhs: Circle) -> Bool {
        return  !(lhs == rhs)
    }
    
    static func == (lhs: Circle, rhs: VisualComponent) -> Bool {
        return false
    }

    static func == (lhs: VisualComponent, rhs: Circle) -> Bool {
        return false
    }
    
    static func != (lhs: Circle, rhs: VisualComponent) -> Bool {
        return true
    }

    static func != (lhs: VisualComponent, rhs: Circle) -> Bool {
        return true
    }
}

extension Circle: Fillable {
    var color: String {
        get {
            return self._color
        }
        
        set (newColor) {
            self._color = newColor
        }
    }
}

extension Circle: VisualComponent {
    var boundingBox: Rect {
            return self._boundingBox
    }
    
    var parent: VisualComponent? {
        get {
            return _parent
        }
        
        set (newParent) {
            self._parent = newParent
        }
    }
    
    func draw() {
        print("Circle")
        print("Top left corner coordinates: (\(_boundingBox.top.x), \(_boundingBox.top.y))")
        print("Height: \(_boundingBox.height)")
        print("Width: \(_boundingBox.width)")
    }
}



struct HStack {
    private var _color: String
    private var _boundingBox: Rect
    private var _parent: VisualComponent? = nil
    private var _numChildren: Int
    private var _children: [VisualComponent]
    
    init() {
        self._color = "Transparent"
        self._numChildren = 0
        self._children = []
        self._boundingBox = Rect(x: 0, y: 0, width: 0, height: 0)
    }
    
    mutating func recalculateBoundingBox() {
        var max: Double = 0
        
        for child in self._children {
            if child.boundingBox.height > max {
                max = child.boundingBox.height 
            }
        }
        
        self._boundingBox.height = max
    }
}

extension HStack: Equatable {
    static func == (lhs: HStack, rhs: HStack) -> Bool {
        if lhs.numChildren != rhs.numChildren {
            return false
        }

        for i in 0..<lhs.numChildren {
            if lhs.children[i] != rhs.children[i] {
                return false
            }
        }

        return true
    }

    static func != (lhs: HStack, rhs: HStack) -> Bool {
        return !(lhs == rhs)
    }

    static func == (lhs: HStack, rhs: VisualComponent) -> Bool {
        return false
    }

    static func == (lhs: VisualComponent, rhs: HStack) -> Bool {
        return false
    }
    
    static func != (lhs: HStack, rhs: VisualComponent) -> Bool {
        return true
    }

    static func != (lhs: VisualComponent, rhs: HStack) -> Bool {
        return true
    }
}

extension HStack: Fillable {
    var color: String {
        get {
            return self._color
        }
        
        set (newColor) {
            self._color = newColor
        }
    }
}

extension HStack: VisualComponent {
    var boundingBox: Rect {
            return self._boundingBox
    }
    
    var parent: VisualComponent? {
        get {
            return _parent
        }
        
        set (newParent) {
            self._parent = newParent
        }
    }
    
    func draw() {
        print("Horizontal stack")
        print("Top left corner coordinates: (\(_boundingBox.top.x), \(_boundingBox.top.y))")
        print("Height: \(_boundingBox.height)")
        print("Width: \(_boundingBox.width)")
    }
}

extension HStack: VisualGroup {
    var numChildren: Int {
        return self._numChildren
    }
    
    var children: [VisualComponent] {
        return self._children
    }
    
    mutating func add(child: VisualComponent) {
        self._numChildren += 1
        var copy = child
        copy.parent = self
        self._children.append(copy)
        
        if child.boundingBox.height > self._boundingBox.height {
            self._boundingBox.height = child.boundingBox.height
        }
        
        self._boundingBox.width += child.boundingBox.width
    }
    
    mutating func remove(child: VisualComponent) {
        for i in 0..<self._numChildren {
            if child == self.children[i] {
                removeChild(at: i)
                return
            }
        }
    }
    
    mutating func removeChild(at: Int) {
        if at < 0 || at >= self._numChildren {
            return
        }
        
        let child = self._children.remove(at: at)
        self._numChildren -= 1
        
        if child.boundingBox.height == self._boundingBox.height {
            recalculateBoundingBox()
        }
        
        self._boundingBox.width -= child.boundingBox.width
    } 
}



struct VStack {
    private var _color: String
    private var _boundingBox: Rect
    private var _parent: VisualComponent? = nil
    private var _numChildren: Int
    private var _children: [VisualComponent]
    
    init() {
        self._color = "Transparent"
        self._numChildren = 0
        self._children = []
        self._boundingBox = Rect(x: 0, y: 0, width: 0, height: 0)
    }
    
    mutating func recalculateBoundingBox() {
        var max: Double = 0
        
        for child in self._children {
            if child.boundingBox.width > max {
                max = child.boundingBox.width 
            }
        }
        
        self._boundingBox.width = max
    }
}

extension VStack: Equatable {
    static func == (lhs: VStack, rhs: VStack) -> Bool {
        if lhs.numChildren != rhs.numChildren {
            return false
        }

        for i in 0..<lhs.numChildren {
            if lhs.children[i] != rhs.children[i] {
                return false
            }
        }

        return true
    }

    static func != (lhs: VStack, rhs: VStack) -> Bool {
        return !(lhs == rhs)
    }

    static func == (lhs: VStack, rhs: VisualComponent) -> Bool {
        return false
    }

    static func == (lhs: VisualComponent, rhs: VStack) -> Bool {
        return false
    }
    
    static func != (lhs: VStack, rhs: VisualComponent) -> Bool {
        return true
    }

    static func != (lhs: VisualComponent, rhs: VStack) -> Bool {
        return true
    }
}

extension VStack: Fillable {
    var color: String {
        get {
            return self._color
        }
        
        set (newColor) {
            self._color = newColor
        }
    }
}

extension VStack: VisualComponent {
    var boundingBox: Rect {
            return self._boundingBox
    }
    
    var parent: VisualComponent? {
        get {
            return _parent
        }
        
        set (newParent) {
            self._parent = newParent
        }
    }
    
    func draw() {
        print("Vertical stack")
        print("Top left corner coordinates: (\(_boundingBox.top.x), \(_boundingBox.top.y))")
        print("Height: \(_boundingBox.height)")
        print("Width: \(_boundingBox.width)")
    }
}

extension VStack: VisualGroup {
    var numChildren: Int {
        return self._numChildren
    }
    
    var children: [VisualComponent] {
        return self._children
    }
    
    mutating func add(child: VisualComponent) {
        self._numChildren += 1
        var copy = child
        copy.parent = self
        self._children.append(copy)
        
        if child.boundingBox.width > self._boundingBox.width {
            self._boundingBox.width = child.boundingBox.width
        }
        
        self._boundingBox.height += child.boundingBox.height
        
        //ADD SET PARENT
    }
    
    mutating func remove(child: VisualComponent) {
        for i in 0..<self._numChildren {
            if child == self.children[i] {
                removeChild(at: i)
                return
            }
        }
    }
    
    mutating func removeChild(at: Int) {
        if at < 0 || at >= self._numChildren {
            return
        }
        
        let child = self._children.remove(at: at)
        self._numChildren -= 1
        
        if child.boundingBox.width == self._boundingBox.width {
            recalculateBoundingBox()
        }
        
        self._boundingBox.height -= child.boundingBox.height
    }
}



struct ZStack {
    private var _color: String
    private var _boundingBox: Rect
    private var _parent: VisualComponent? = nil
    private var _numChildren: Int
    private var _children: [VisualComponent]
    
    init() {
        self._color = "Transparent"
        self._numChildren = 0
        self._children = []
        self._boundingBox = Rect(x: 0, y: 0, width: 0, height: 0)
    }
    
    mutating func recalculateBoundingBox() {
        if self._numChildren == 0 {
            self._boundingBox = Rect(x: 0, y: 0, width: 0, height: 0)
            return
        }
        var minX: Double = self._children[0].boundingBox.top.x
        var maxX: Double = minX + self._children[0].boundingBox.width
        var minY: Double = self._children[0].boundingBox.top.y
        var maxY: Double = minY + self._children[0].boundingBox.height

        for child in self._children {
            if child.boundingBox.top.x < minX {
                minX = child.boundingBox.top.x
            }

            if child.boundingBox.top.y < minY {
                minY = child.boundingBox.top.y
            }

            if child.boundingBox.width + child.boundingBox.top.x > maxX {
                maxX = child.boundingBox.width + child.boundingBox.top.x
            }

            if child.boundingBox.height + child.boundingBox.top.y > maxY {
                maxY = child.boundingBox.height + child.boundingBox.top.y
            }
        }

        self._boundingBox = Rect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}

extension ZStack: Equatable {
    static func == (lhs: ZStack, rhs: ZStack) -> Bool {
        if lhs.numChildren != rhs.numChildren {
            return false
        }

        for i in 0..<lhs.numChildren {
            if lhs.children[i] != rhs.children[i] {
                return false
            }
        }

        return true
    }

    static func != (lhs: ZStack, rhs: ZStack) -> Bool {
        return !(lhs == rhs)
    }

    static func == (lhs: ZStack, rhs: VisualComponent) -> Bool {
        return false
    }

    static func == (lhs: VisualComponent, rhs: ZStack) -> Bool {
        return false
    }
    
    static func != (lhs: ZStack, rhs: VisualComponent) -> Bool {
        return true
    }

    static func != (lhs: VisualComponent, rhs: ZStack) -> Bool {
        return true
    }
}

extension ZStack: Fillable {
    var color: String {
        get {
            return self._color
        }
        
        set (newColor) {
            self._color = newColor
        }
    }
}

extension ZStack: VisualComponent {
    var boundingBox: Rect {
        return self._boundingBox
    }
    
    var parent: VisualComponent? {
        get {
            return _parent
        }
        
        set (newParent) {
            self._parent = newParent
        }
    }
    
    func draw() {
        print("Z axis stack")
        print("Top left corner coordinates: (\(_boundingBox.top.x), \(_boundingBox.top.y))")
        print("Height: \(_boundingBox.height)")
        print("Width: \(_boundingBox.width)")
    }
}

extension ZStack: VisualGroup {
    var numChildren: Int {
        return self._numChildren
    }
    
    var children: [VisualComponent] {
        return self._children
    }
    
    mutating func add(child: VisualComponent) {
        self._numChildren += 1
        var copy = child
        copy.parent = self
        self._children.append(copy)
        
        if !isIn(lhs: child.boundingBox, rhs: self.boundingBox) {
            recalculateBoundingBox()
        }
        
    }
    
    mutating func remove(child: VisualComponent) {
        for i in 0..<self._numChildren {
            if child == self.children[i] {
                removeChild(at: i)
                return
            }
        }
    }
    
    mutating func removeChild(at: Int) {
        if at < 0 || at >= self._numChildren {
            return
        }
        
        self._children.remove(at: at)
        self._numChildren -= 1
        
        recalculateBoundingBox()
    }
}

//task 2
func depth(root: VisualComponent?) -> Int {

    if root == nil {
        return 0
    }
    
    else if root is Circle || root is Rectangle || root is Triangle || root is Path {
        return 1
    }
    
    if case let r as HStack = root {
        return 1 + r.children.map { depth(root: $0) }.max()!
    } else if case let r as VStack = root {
        return 1 + r.children.map { depth(root: $0) }.max()!
    } else if case let r as ZStack = root {
        return 1 + r.children.map { depth(root: $0) }.max()!
    }
    
    return 0;
}

//task3
func count(root: VisualComponent?, level: Int) -> Int {
    if root == nil {
        return 0
    }
    
    if level < 0 {
        return 0
    }
    
    if level == 1 {
        return 1
    }
    
    else if level == 2 {
        
        if root is Circle || root is Rectangle || root is Triangle || root is Path {
            return 0
        }
    
        if case let r as HStack = root {
            return r.numChildren
        } else if case let r as VStack = root {
            return r.numChildren
        } else if case let r as ZStack = root {
            return r.numChildren
        }
    }
    
    else {
        if root is Circle || root is Rectangle || root is Triangle || root is Path {
            return 0
        }
    
        if case let r as HStack = root {
            return r.children.map { count(root: $0, level: level - 1) }.reduce(0, { x, y in x + y })
        } else if case let r as VStack = root {
            return r.children.map { count(root: $0, level: level - 1) }.reduce(0, { x, y in x + y })
        } else if case let r as ZStack = root {
            return r.children.map { count(root: $0, level: level - 1) }.reduce(0, { x, y in x + y })
        }
    }
    
    return 0
}

//task4
func cover(root: VisualComponent?) -> Rect {
    if root != nil {
        return root!.boundingBox
    }
    
    return Rect(x: 0, y: 0, width: 0, height: 0)
}