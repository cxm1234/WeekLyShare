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
 Dictionary
 */

do {
    let dic = ["Tanner": "Swift"]
    let dic_pointer = unsafeBitCast(dic, to: UnsafeMutableRawPointer.self)
    print(dic_pointer)
}


/*:
 Protocol
 */

protocol Foo {
    func foo ()
}

struct A: Foo {
    var name: String
    
    func foo() {
        
    }
}


