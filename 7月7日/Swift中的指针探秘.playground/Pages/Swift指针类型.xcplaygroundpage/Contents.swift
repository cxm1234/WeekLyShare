//: [Previous](@previous)
/*:
 ## 指针分类
 ### Swift中的不可变指针类型
 ![stateble_pointer_01](stateble_pointer_01.png)
 ### Swift中的可变指针类型
 ![mutable_pointer_01](mutable_pointer_01.png)
 1. **Pointer**与**BufferPointer**: Pointer表示指向内存中的单个值，如：Int。BufferPointer表示指向内存中相同类型的多个值（集合）称为缓冲区指针，如[Int]
 2. **Type**与**Raw**: 类型化的指针Typed提供了解释指针指向的字节序列的类型。而非类型化的指针Raw访问最原始的字节序列，未提供解释字节序列的类型的能力。
 ### Swift 与OC指针对比
 ![swift_vs_oc_pointer](swift_vs_oc_pointer.png)
 */

/*:
 ### 使用非类型化（Raw）的指针
 *UnsafeRawBufferPointer表示内存区域中字节的集合，可用来以字节的形式访问内存*
 */

let count = 3
let stride = MemoryLayout<Int>.stride ///8个字节，每个实例的存储空间
let byteCount = stride * count
let alignment = MemoryLayout<Int>.alignment

do {
    ///通过指定的字节大小和对齐方式申请未初始化的内存
    let mutableRawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    defer {
        mutableRawPointer.deallocate()
    }
    /// 初始化内存
    mutableRawPointer.initializeMemory(as: Int.self, repeating: 0, count: byteCount)
    ///RawPointer 起始位置存储 整数15
    mutableRawPointer.storeBytes(of: 0xF, as: Int.self)
    ///将RawPointer 起始位置 偏移一个整数的位置（8个字节） 并在此位置存储一个整数 有以下两种方式：
    (mutableRawPointer + stride).storeBytes(of: 0xD, as: Int.self)
    mutableRawPointer.advanced(by: stride*2).storeBytes(of: 9, as: Int.self)
    ///通过`load` 查看内存中特定偏移地址的值
    mutableRawPointer.load(fromByteOffset: 0, as: Int.self) // 15
    mutableRawPointer.load(fromByteOffset: stride , as: Int.self) //13
    ///通过`UnsafeRawBufferPointer`以字节集合的形式访问内存
    let buffer = UnsafeRawBufferPointer.init(start: mutableRawPointer, count: byteCount)
    for (index,byte) in buffer.enumerated(){///遍历每个字节的值
        print("index:\(index),value:\(byte)")
    }
}

/*:
 ### 使用类型化的指针
 */
do {
    ///通过指定的字节大小和对齐方式申请未初始化的内存
    let mutableRawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    defer {
        mutableRawPointer.deallocate()
    }
    /// 初始化内存
    mutableRawPointer.initializeMemory(as: Int.self, repeating: 0, count: byteCount)
    ///RawPointer 起始位置存储 整数15
    mutableRawPointer.storeBytes(of: 0xF, as: Int.self)
    ///将RawPointer 起始位置 偏移一个整数的位置（8个字节） 并在此位置存储一个整数 有以下两种方式：
    (mutableRawPointer + stride).storeBytes(of: 0xD, as: Int.self)
    mutableRawPointer.advanced(by: stride*2).storeBytes(of: 9, as: Int.self)
    ///通过`load` 查看内存中特定偏移地址的值
    mutableRawPointer.load(fromByteOffset: 0, as: Int.self) // 15
    mutableRawPointer.load(fromByteOffset: stride, as: Int.self) //13
    ///通过`UnsafeRawBufferPointer`以字节集合的形式访问内存
    let buffer = UnsafeRawBufferPointer.init(start: mutableRawPointer, count: byteCount)
    for (index,byte) in buffer.enumerated(){///遍历每个字节的值
        print("index:\(index),value:\(byte)")
    }
}

/*:
 ### RawPointer转换为TypedPointer
 */

do {
    let  mutableRawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    defer {
        mutableRawPointer.deallocate()
    }
    /// Raw 转化 Typed，以对应类型的字节数 为单位
    let mutableTypedPointer = mutableRawPointer.bindMemory(to: Int.self, capacity: count)
    /// 初始化,非必需
    mutableTypedPointer.initialize(repeating: 0, count: count)
    defer {
        ///只需反初始化即可，第一个`defer`会处理指针的`deallocate`
        mutableTypedPointer.deinitialize(count: count)
    }
    ///存储
    mutableTypedPointer.pointee = 10
    mutableTypedPointer.successor().pointee = 40
    (mutableTypedPointer + 1).pointee = 20
    mutableTypedPointer.advanced(by: 2).pointee = 30

    ///遍历，使用类型化的`BufferPointer`遍历
    let buffer = UnsafeBufferPointer.init(start: mutableTypedPointer, count: count)
    for item in buffer.enumerated() {
        print("index:\(item.0),value:\(item.1)")
    }

}
/*:
 ### 调用以指针作为参数的函数
 **调用以指针作为参数的函数时，可以通过隐式转换来传递兼容的指针类型，或者通过隐式桥接来传递指向变量的指针或者指向数组的指针。**
 1. 常量指针作为参数
 当调用一个函数，它携带的指针参数为UnsafePointer<Type>时，我们可以传递的参数有:
 * UnsafePointer<Type>, UnsafeMutablePointer<Type>或AutoreleasingUnsafeMutablePointer<Type>，根据需要会隐式转换为UnsafePointer<Type>。
 * 如果Type为Int8或者UInt8，可以传String的实例，字符串会自动转换为UTF8，并将指向该UTF8缓冲区的指针传递给函数
 * 该Type类型的可变的变量，属性或下标，通过在左侧添加取地址符&的形式传递给函数。（隐式桥接）
 * 一个Type类型的数组（[Type]），会以指向数组开头的指针传递给函数。（隐式桥接）
 */
do {
    ///定义一个接收`UnsafePointer<Int8>`作为参数的函数
    func functionWithConstTypePointer(_ p: UnsafePointer<Int8>) {
        //...
    }
    ///传递`UnsafeMutablePointer<Type>`作为参数
    let mutableTypePointer = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
    mutableTypePointer.initialize(repeating: 10, count: 1)
    defer {
        mutableTypePointer.deinitialize(count: 1)
        mutableTypePointer.deallocate()
    }
    functionWithConstTypePointer(mutableTypePointer)
    ///传递`String`作为参数
    let str = "abcd"
    functionWithConstTypePointer(str)
    ///传递输入输出型变量作为参数
    var a : Int8 = 3
    functionWithConstTypePointer(&a)
    ///传递`[Type]`数组
    functionWithConstTypePointer([1,2,3,4])
}

/*:
 *当调用一个函数，它携带的指针参数为UnsafeRawPointer时，可以传递与UnsafePointer<Type>相同的参数，只不过没有了类型的限制:*
 */
do {
    ///定义一个接收`UnsafeRawPointer`作为参数的函数
    func functionWithConstRawPointer(_ p: UnsafeRawPointer) {
        //...
    }
    ///传递`UnsafeMutablePointer<Type>`作为参数
    let mutableTypePointer = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
    mutableTypePointer.initialize(repeating: 10, count: 1)
    defer {
        mutableTypePointer.deinitialize(count: 1)
        mutableTypePointer.deallocate()
    }
    functionWithConstRawPointer(mutableTypePointer)
    ///传递`String`作为参数
    let str = "abcd"
    functionWithConstRawPointer(str)
    ///传递输入输出型变量作为参数
    var a = 3.0
    functionWithConstRawPointer(&a)
    ///传递任意类型数组
    functionWithConstRawPointer([1,2,3,4] as [Int8])
    functionWithConstRawPointer([1,2,3,4] as [Int16])
    functionWithConstRawPointer([1.0,2.0,3.0,4.0] as [Float])
}

/*:
 2. 可变指针作为参数
 *当调用一个函数，它携带的指针参数为UnsafeMutablePointer<Type>时，我们可以传递的参数有:*
 * UnsafeMutablePointer<Type>的值
 * 该Type类型的可变的变量，属性或下标，通过在左侧添加取地址符&的形式传递给函数。（隐式桥接）
 * 一个Type类型的可变数组（[Type]），会以指向数组开头的指针传递给函数。（隐式桥接）
 */

do {
    ///定义一个接收`UnsafeMutablePointer<Int8>`作为参数的函数
    func functionWithMutableTypePointer(_ p: UnsafeMutablePointer<Int8>) {
        //...
    }
    ///传递`UnsafeMutablePointer<Type>`作为参数
    let mutableTypePointer = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
    mutableTypePointer.initialize(repeating: 10, count: 1)
    defer {
        mutableTypePointer.deinitialize(count: 1)
        mutableTypePointer.deallocate()
    }
    functionWithMutableTypePointer(mutableTypePointer)
    ///传递`Type`类型的变量
    var b : Int8 = 10
    functionWithMutableTypePointer(&b)
    ///传递`[Type]`类型的变量
    var c : [Int8] = [20,10,30,40]
    functionWithMutableTypePointer(&c)
}

/*:
 *同样的，当调用一个函数，它携带的指针参数为UnsafeMutableRawPointer时，可以传递与UnsafeMutablePointer<Type>相同的参数，只不过没有了类型的限制。*
 */

do {
    ///定义一个接收`UnsafeMutableRawPointer`作为参数的函数
    func functionWithMutableRawPointer(_ p: UnsafeMutableRawPointer) {
        //...
    }
    ///传递`UnsafeMutablePointer<Type>`作为参数
    let mutableTypePointer = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
    mutableTypePointer.initialize(repeating: 10, count: 1)
    defer {
        mutableTypePointer.deinitialize(count: 1)
        mutableTypePointer.deallocate()
    }
    functionWithMutableRawPointer(mutableTypePointer)
    ///传递任意类型的变量
    var b : Int8 = 10
    functionWithMutableRawPointer(&b)
    var d : Float = 12.0
    functionWithMutableRawPointer(&d)
    ///传递任意类型的可变数组
    var c : [Int8] = [20,10,30,40]
    functionWithMutableRawPointer(&c)
    var e : [Float] = [20.0,10.0,30.0,40.0]
    functionWithMutableRawPointer(&e)
}

/*:
 *通过隐式桥接实例或数组元素创建的指针只在被调用函数执行期间有效。 转义函数执行后要使用的指针是未定义的行为。 特别是，在调用UnsafePointer/UnsafeMutablePointer/UnsafeRawPointer/UnsafeMutableRawPointer initializer时，不要使用隐式桥接。*
 */

do {
    var number = 5
    let numberPointer = UnsafePointer<Int>(&number)
    // 访问 'numberPointer' 是未知行为.
}
do {
    var number = 5
    let numberPointer = UnsafeMutablePointer<Int>(&number)
    // 访问 'numberPointer' 是未知行为.
}
do {
    var number = 5
    let numberPointer = UnsafeRawPointer(&number)
    // 访问 'numberPointer' 是未知行为.
}
do {
    var number = 5
    let numberPointer = UnsafeMutableRawPointer(&number)
    // 访问 'numberPointer' 是未知行为.
}

/*:
 **未知行为可能会导致难以预知的bug**
 */

//MARK: 错误示范!
do {
    func functionWithPointer(_ p: UnsafePointer<Int>) {
        let mPointer = UnsafeMutablePointer<Int>.init(mutating: p)
        mPointer.pointee = 6;
    }
    var number = 5
    let numberPointer = UnsafePointer<Int>(&number)
    functionWithPointer(numberPointer)
    print(numberPointer.pointee) //6
    print(number)//6 会出现比较难以盘查的bug
    number = 7
    print(numberPointer.pointee) //7
    print(number)//7
}

/*:
 ### 访问指针
 **Swift中任意类型的值,Swift提供了全局函数直接访问它们的指针或内存中的字节。**
 * 通过下列函数，Swift可以访问任意值的指针。
 withUnsafePointer(to:_:) 只访问，不修改
 withUnsafeMutablePointer(to:_:) 可访问，可修改
 */

do {
    ///只访问，不修改
    var temp : UInt32 = UInt32.max
    withUnsafeBytes(of: temp) { rawBufferPointer in
        for item in rawBufferPointer.enumerated() {
            print("index:\(item.0),value:\(item.1)")
        }
    }
}

do {
    ///规范方式：访问&修改，
    var temp : [Int8] = [1,2,3,4]
    withUnsafeMutablePointer(to: &temp) { mPointer in
        mPointer.pointee = [6,5,4];
    }
    print(temp) ///[6, 5, 4]
}

/*:
 *Swift的值，如果需要通过指针的方式改变，则必须为变量，并且调用上述方法时必须将变量标记为inout参数，即变量左侧添加&。常量值，不能以inout参数的形式访问指针。*
 */

// MARK: 错误示例一
do {
    ///错误方式：访问&修改
    var temp : [Int8] = [1,2,3,4]
    withUnsafePointer(to: &temp) { point in
        let mPointer = UnsafeMutablePointer<[Int8]>.init(mutating: point)
        mPointer.pointee = [6,5,4];
    }
}

/*:
 *一个闭包，它的唯一参数是一个指向值的指针。如果闭包有一个返回值，该值也被用作withUnsafePointer(to:_:)函数的返回值。 指针参数仅在函数执行期间有效。 试图通过将指针参数转换为UnsafeMutablePointer或任何其他可变指针类型来改变指针参数是未定义的行为。 如果需要通过指针改变参数，请使用withUnsafeMutablePointer(to:_:)代替。*
 */

// MARK: 错误示例二:
do {
    var tmp : [Int8] = [1,2,3,4]
    ///错误1
    let pointer = withUnsafePointer(to: &tmp, {$0})
    let mPointer = UnsafeMutablePointer<[Int8]>.init(mutating: pointer)
    mPointer.pointee = [7,8,9]
    ///错误2
    let mutablePointer = withUnsafeMutablePointer(to: &tmp) {$0}
    mutablePointer.pointee = [6,5,4,3]
}

/*:
 *使用上述方法访问内存时，切记不要返回或者存储闭包参数body中的指针，供以后使用。*
 */

/*:
 ### 访问字节
 *通过下列函数，Swift可以访问任意值的在内存中的字节。*
 withUnsafeBytes(of:_:) 只访问，不修改
 withUnsafeMutableBytes(of:_:) 可访问，可修改
 */

do {
    ///只访问，不修改
    var temp : UInt32 = UInt32.max
    withUnsafeBytes(of: temp) { rawBufferPointer in
        for item in rawBufferPointer.enumerated() {
            print("index:\(item.0),value:\(item.1)")
        }
    }
}

do {
    ///规范方式：访问&修改，
    var temp : UInt32 = UInt32.max //4294967295
    withUnsafeMutableBytes(of: &temp) { mutableRawBuffer in
        mutableRawBuffer[1] = 0;
        mutableRawBuffer[2] = 0;
        mutableRawBuffer[3] = 0;
        //mutableRawBuffer[5] = 0;/// crash
    }
}

// MARK: 错误示例：
do {
    ///访问&修改，此方式有风险，需要重点规避
    var temp : UInt32 = UInt32.max //4294967295
    withUnsafeBytes(of: &temp) { rawBufferPointer in
        let mutableRawBuffer = UnsafeMutableRawBufferPointer.init(mutating: rawBufferPointer)
        ///小端序
        mutableRawBuffer[1] = 0;
        mutableRawBuffer[2] = 0;
        mutableRawBuffer[3] = 0;
        for item in mutableRawBuffer.enumerated() {
            print("index:\(item.0),value:\(item.1)")
        }
    }
    print(temp) ///255
}

/*:
 *一个闭包，它的唯一参数是指向值字节的原始缓冲区指针。 如果闭包有返回值，该值也被用作withUnsafeBytes(of:_:)函数的返回值。 缓冲区指针参数仅在闭包执行期间有效。 试图通过转换为UnsafeMutableRawBufferPointer或任何其他可变指针类型来通过指针进行变异是未定义的行为。 如果你想通过指针来改变一个值，请使用withUnsafeMutableBytes(of:_:)来代替。*
 */
