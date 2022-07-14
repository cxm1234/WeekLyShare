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

//: [Next](@next)
