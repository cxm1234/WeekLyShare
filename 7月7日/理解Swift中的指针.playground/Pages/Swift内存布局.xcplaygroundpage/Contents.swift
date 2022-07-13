//: [Previous](@previous)

/*:
 ## Swift内存布局
 */

/*:
 ### 查看Swift基本数据类型大小
 */

//MemoryLayout<T>.size      // 类型T需要的内存大小
//MemoryLayout<T>.stride    // 类型T实际分配的内存大小(由于内存对齐原则，会多出空白的空间)
//MemoryLayout<T>.alignment  // 内存对齐的基数

import Foundation

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
    MemoryLayout<SampleEnum>.size //9
    MemoryLayout<SampleEnum>.alignment //8
    MemoryLayout<SampleEnum>.stride //16

    ///结构体
    struct emptyStruct {
    }
    
    MemoryLayout<emptyStruct>.size //0
    MemoryLayout<emptyStruct>.alignment //1 ，所有地址都能被1整除，故可存在于任何地址，
    MemoryLayout<emptyStruct>.stride //1
    
//    struct SampleStruct {
//        let b : Int
//        let a : Bool
//    }
    struct SampleStruct {
        let a : Bool
        let b : Int
    }
    
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

//: [Next](@next)
