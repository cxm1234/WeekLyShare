/*:
    # Swift中的指针操作
 */

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



