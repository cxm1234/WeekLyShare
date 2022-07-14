//
//  main.swift
//  Swift内存布局
//
//  Created by xiaoming on 2022/7/6.
//

import Foundation

/*:
 Struct
 */
do {
    struct Foo {
        let a: Int8 = 2
        let b: Int16 = 4
        let c: Int32 = 6
        let d: Int = 8
        let e: Int32 = 10
        
        func foo() {
            print("Hello")
        }
    }

    let foo = Foo()

    print(MemoryLayout<Foo>.size)
    print(MemoryLayout<Foo>.alignment)
    print(MemoryLayout<Foo>.stride)
}

//可以看到foo的内存结构，每一个属性都会根据对应的类型分配好对应的内存大小。虽然Foo只需要分配15个字节，但由于有内存对齐原则，还是给Foo分配了16个字节。对于结构体内部的方法，并不会在结构体内部储存函数的信息。其实在编译后，在调用的地方(foo.foo()), 会直接跳转到具体的函数实现的位置(call foo(伪编译后名字))，对于遵循协议的方法，会通过witness_table得到函数指针去后，在跳转到具体的实现地址

/*:
 String
 */
do {
    struct Foo2 {
        let str = "hello world hahhahahahhahahahhahha"
    }
    let foo2 = Foo2()
    print(MemoryLayout<Foo2>.size)

    struct FooStr {
        let a: Int8 = 1
        let str = "hello world"
    }

    let fooStr = FooStr()
    print(fooStr)
}


/*:
 Array
 */
do {
    let arr = ["Tanner", "Jin"]

    print(arr)


    let array  = [1, 2]
    unsafeBitCast(array, to: UnsafeMutableRawPointer.self).advanced(by: 32).assumingMemoryBound(to: Int.self).initialize(to: 3)
    print(array)  // [3, 2]
}

/*:
 Enum
 */

do {
    enum Foo: String {
        case a = "Tanner"
        case b = "Jin"
    }
    
    struct Foo1 {
        let a = Foo.a
        let b = Foo.b
    }
    
    struct Foo2 {
        let a = Foo.a.rawValue
        let b = Foo.b
    }
    
    print("Foo1 Size", MemoryLayout<Foo1>.size)
    print("Foo2 Size", MemoryLayout<Foo2>.size)
    
    let foo1 = Foo1()
    let foo2 = Foo2()
    
    print("===end===")
}

/**
 可以看到foo1分配了2个字节的内存，并且值是0和1.而foo2占用了17个字节的内存，一个是a(16 bytes), 一个是b(1byte)。事实上，对于Foo2的属性a，其实已经是一个字符串类型了，不是枚举类型了。
 而对于枚举来说，编译器分配的值是0, 1, 2, 3, 4…(按照定义的顺序),即占用一个字节空间。而对于枚举的rawValue, 编译器会根据rawValue具体的类型分配具体的内存大小。
 */

do {
    enum Foo<T> {
        case a
        case b(T)
        case c
        case d
        case e
    }

    var foo = Foo<Int8>.a
    var foo2 = Foo<Int8>.b // 实际上是一个Block，占用16个字节
    var foo3 = Foo<Int8>.b(5)
    var foo4 = Foo<String>.b("Tanner")
    var foo5 = Foo<Int16>.c
    var foo6 = Foo<Int32>.d
    var foo7 = Foo<Int64>.e

    print(MemoryLayout.size(ofValue: foo))   // 1 + 1 bytes
    print(MemoryLayout.size(ofValue: foo2))  // block (16 bytes)
    print(MemoryLayout.size(ofValue: foo3))  // 1 + 1 bytes
    print(MemoryLayout.size(ofValue: foo4))  // 16 bytes
    print(MemoryLayout.size(ofValue: foo5))  // 2 + 1 bytes
    print(MemoryLayout.size(ofValue: foo6))  // 4 + 1 bytes
    print(MemoryLayout.size(ofValue: foo7))  // 8 + 1 bytes
    print(type(of: foo2))

    print("===end===")
}

/**
 通过打印信息可以看到，具有关联对象的枚举，每一个枚举值分配的内存大小是枚举类型中枚举的关联值类型占用的空间大小加上一个字节(事实上是枚举关联值类型的最大类型，即一个枚举关联了Int8类型，另一个枚举关联了Int64类型，那么就按照Int64类型占用的大小)。
 而对于foo2, 实际上并有具体的值，他其实是一个Block，而Swift中的Block占用的是16个字节。
 */

do {
    enum Foo<T> {
        case a
        case b(T)
        case c
        case d(T)
        case e
        case f
        case g(T)
    }

    var fooa = Foo<Int8>.a
    var foob = Foo<Int8>.b(5)
    var fooc = Foo<Int8>.c
    var food = Foo<Int8>.d(4)
    var fooe = Foo<Int8>.e
    var foof = Foo<Int8>.f
    var foog = Foo<Int8>.g(3)

    print(MemoryLayout.size(ofValue: fooa))
    print(MemoryLayout.size(ofValue: foob))

    func memory<T>(value: inout T) -> UnsafeMutableRawPointer  {
        return withUnsafeMutablePointer(to: &value, { (pointer) -> UnsafeMutableRawPointer in
            return UnsafeMutableRawPointer(pointer)
        })
    }

    let fooaPointer = memory(value: &fooa)
    let foobPointer = memory(value: &foob)
    let foocPointer = memory(value: &fooc)
    let foodPointer = memory(value: &food)
    let fooePointer = memory(value: &fooe)
    let foofPointer = memory(value: &foof)
    let foogPointer = memory(value: &foog)

    print(fooaPointer)
    print(foobPointer)
    print(foocPointer)
    print(foodPointer)
    print(fooePointer)
    print(foofPointer)
    print(foogPointer)
    
    print("===end===")
}

/**
 通过Xcode的View Memory功能可以得到指针指向的内存空间信息为：
 fooaPointer: 00 03
 foobPointer: 05 00 (关联值为5 Int8)
 foocPointer: 01 03
 foodPointer: 04 01 (关联值为4 Int8)
 fooePointer: 02 03
 foofPointer: 03 03
 foogPointer: 03 02 (关联值为3 Int8)

 将有关联值的枚举和没有关联值的枚举分开看，就能看到一些规律了：
 没有关联值
 fooaPointer: 00 03
 foocPointer: 01 03
 fooePointer: 02 03
 foofPointer: 03 03

 具有关联值
 foobPointer: 05 00 (关联值为5 Int8)
 foodPointer: 04 01 (关联值为4 Int8)
 foogPointer: 03 02 (关联值为3 Int8)

 可以看到没有关联值的枚举值中，00, 01, 02, 03 是正常枚举的值(按照顺序定义赋值)，而03是该枚举类型中具有关联值的枚举值的个数(这个是我猜测的，不过也是通过许多的例子推测出来的)。

 对于有关联值的枚举，05，04，03是关联值的值。00，01，02是有关联值的枚举中的值(也是按照定义顺序)
 */
