/*:
    # Swift中的指针操作
 */

/*:
 ## Swift内存布局
 */

/*:
 ### 查看Swift基本数据类型大小
 */

//MemoryLayout<T>.size      // 类型T需要的内存大小
//MemoryLayout<T>.stride    // 类型T实际分配的内存大小(由于内存对齐原则，会多出空白的空间)
//MemoryLayout<T>.alignment  // 内存对齐的基数

do {
    MemoryLayout<Int>.size //Int类型，连续内存占用为8字节
    MemoryLayout<Int>.alignment // Int类型的内存对齐为8字节
    ///连续内存一个Int值的开始地址到下一个Int值开始地址之间的字节值
    MemoryLayout<Int>.stride // Int类型的步幅为8字节

    MemoryLayout<Optional<Int>>.size // 9字节，可选类型比普通类型多一个字节
    MemoryLayout<Optional<Int>>.alignment //8字节
    MemoryLayout<Optional<Int>>.stride //16

    MemoryLayout<Float>.size // 4字节
    MemoryLayout<Float>.alignment //4字节
    MemoryLayout<Float>.stride //4字节

    MemoryLayout<Double>.size // 8
    MemoryLayout<Double>.alignment //8
    MemoryLayout<Double>.stride //8

    MemoryLayout<Bool>.size //1
    MemoryLayout<Bool>.alignment //1
    MemoryLayout<Bool>.stride //1

    MemoryLayout<Int32>.size // 4
    MemoryLayout<Int32>.alignment //4
    MemoryLayout<Int32>.stride //4
}

/*:
 ### 查看Swift枚举、结构体、类类型大小、对齐方式
 */

do {
    ///枚举类型
    enum EmptyEnum {///空枚举
//        foo() {
//
//        }
    }
    MemoryLayout<EmptyEnum>.size //0
    MemoryLayout<EmptyEnum>.alignment //1 所有地址都能被1整除，故可存在于任何地址，
    MemoryLayout<EmptyEnum>.stride //1

    enum SampleEnum {
       case none
       case some(Int)
    }
//    enum SampleEnum {
//       case none
//       case some(Int)
//    }
    MemoryLayout<SampleEnum>.size //9
    MemoryLayout<SampleEnum>.alignment //8
    MemoryLayout<SampleEnum>.stride //16

    ///结构体
    struct emptyStruct {
    }
    
    MemoryLayout<emptyStruct>.size //0
    MemoryLayout<emptyStruct>.alignment //1 ，所有地址都能被1整除，故可存在于任何地址，
    MemoryLayout<emptyStruct>.stride //1
    
    struct SampleStruct {
        let b : Int
        let a : Bool
    }
//    struct SampleStruct {
//        let a : Bool
//        let b : Int
//    }
    
    MemoryLayout<SampleStruct>.size // 9 but b与a的位置颠倒后，便会是16
    MemoryLayout<SampleStruct>.alignment // 8
    MemoryLayout<SampleStruct>.stride // 16

    class EmptyClass {}
    MemoryLayout<EmptyClass>.size//8
    MemoryLayout<EmptyClass>.alignment//8
    MemoryLayout<EmptyClass>.stride//8

    class SampleClass {
        let b : Int = 2
        var a : Bool?
    }
    MemoryLayout<SampleClass>.size //8
    MemoryLayout<SampleClass>.alignment//8
    MemoryLayout<SampleClass>.stride//8
}

/*:
 ## 指针分类
 */

/*:
 ### 使用非类型化（Raw）的指针
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
    mutableRawPointer.load(fromByteOffset: stride , as: Int.self) //9
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
 ## 调用以指针作为参数的函数
 */

//MARK: 危险操作!
do {
//    var number = 5
//    let numberPointer = UnsafePointer<Int>(&number)
//    // 访问 'numberPointer' 是未知行为
//    var number = 5
//    let numberPointer = UnsafeMutablePointer<Int>(&number)
//    // 访问 'numberPointer' 是未知行为
//    var number = 5
//    let numberPointer = UnsafeRawPointer(&number)
//    // 访问 'numberPointer' 是未知行为
//    var number = 5
//    let numberPointer = UnsafeMutableRawPointer(&number)
    // 访问 'numberPointer' 是未知行为
}

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
 ## 访问字节
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
        mutableRawBuffer[0] = 0;
        mutableRawBuffer[1] = 0;
        mutableRawBuffer[2] = 0;
        mutableRawBuffer[3] = 0;
        //mutableRawBuffer[5] = 0;/// crash
    }
    print(temp) ///255
}

// MARK: 错误示例!
do {
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



