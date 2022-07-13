# Swift中的指针操作
### 指针基础知识
#### 地址

* 计算机以字节为单位访问可寻址存储器
* 存储器被视为一个非常大的字节数组，称为**虚拟存储器**
* 存储器每一个字节都有一个唯一的数字来标识，称为**地址**
* 所有这些地址的集合称为**虚拟地址空间**

#### 字

* 计算机以一组二进制序列为单元执行存储，传送或操作，该单元称为字。
* 字的二进制位数称为字长。
* CPU的字长决定了虚拟地址空间大小，字长n位，则虚拟地址空间大小为：0 ~ 2^n-1。
* 指针类型使用的是机器的全字长，即：32位4字节，64位8字节。
* 指针（地址）是虚拟存储器每个字节的唯一数字标识，n位机器虚拟地址空间最大地址标识可达 2^n-1位。

### Swift内存布局

#### 使用MemoryLayout查看Swift基本数据类型的大小，对齐方式

```swift
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
    
```

#### 使用MemoryLayout查看Swift枚举、结构体、类类型大小，对齐方式

```swift
///枚举类型
enum EmptyEnum {///空枚举
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
struct SampleStruct {
}
MemoryLayout<SampleStruct>.size //0
MemoryLayout<SampleStruct>.alignment //1 ，所有地址都能被1整除，故可存在于任何地址，
MemoryLayout<SampleStruct>.stride //1

struct SampleStruct {
    let b : Int
    let a : Bool
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
```

### Swift指针分类

#### Swift中的不可变指针类型：

|  | Pointer | BufferPointer |
| --- | --- | --- |
| Typed | UnsafePointer<T> | UnsafeBufferPointer<T> |
| Raw | UnsafeRawPointer | UnsafeRawBufferPointer |

#### Swift中的可变指针类型

|  | Pointer | BufferPointer |
| --- | --- | --- |
| Typed | UnsafeMutarblePointer<T> | UnsafeMutableBufferPointer<T> |
| Raw | UnsafeMutableRawPointer | UnsafeMutableRawBufferPointer |

1. Pointer与BufferPointer：Pointer表示指向内存中的单个值，如：Int。BufferPointer表示指向内存中相同类型的多个值（集合）称为缓冲区指针，如[Int]。
2. Typed与Raw：类型化的指针Typed提供了解释指针指向的字节序列的类型。而非类型化的指针Raw访问最原始的字节序列，未提供解释字节序列的类型的能力。
3. Mutable与Immutable：可变指针，可读可写。不可变指针，只读。

#### Swift与OC指针对比

| Swift | OC | 说明 |
| --- | --- | --- |
| UnsafePointer<T> | constT* | 指针不可变，指向的内容可变 |
| UnsafeMutablePointer<T> | T* | 指针及指向内容均可变 |
| UnsafeRawPointer | const void* | 指向未知类型的常量指针 |
| UnsafeMutableRawPointer | void* | 指向未知类型的指针 |

### 使用非类型化（Raw）的指针

##### 使用非类型化的指针访问内存并写入三个整数（Int）.

```swift
let count = 3
let stride = MemoryLayout<Int>.stride ///8个字节，每个实例的存储空间
let byteCount = stride * count
let alignment = MemoryLayout<Int>.alignment
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
mutableRawPointer.load(fromByteOffset: stride, as: Int.self) //9
///通过`UnsafeRawBufferPointer`以字节集合的形式访问内存
let buffer = UnsafeRawBufferPointer.init(start: mutableRawPointer, count: byteCount)
for (index,byte) in buffer.enumerated(){///遍历每个字节的值
    print("index:\(index),value:\(byte)")
}

```
*UnsafeRawBufferPointer 表示内存区域中字节的集合，可用来以字节的形式访问内存。*

### 使用类型化的指针

##### 使用类型化的指针访问内存并写入三个整数（Int）。

```swift
let count = 3
let stride = MemoryLayout<Int>.stride ///8个字节，每个实例的存储空间
let byteCount = stride * count
let alignment = MemoryLayout<Int>.alignment
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
mutableRawPointer.load(fromByteOffset: stride, as: Int.self) //9
///通过`UnsafeRawBufferPointer`以字节集合的形式访问内存
let buffer = UnsafeRawBufferPointer.init(start: mutableRawPointer, count: byteCount)
for (index,byte) in buffer.enumerated(){///遍历每个字节的值
    print("index:\(index),value:\(byte)")
}
```
### RawPointer转换为TypedPointer

```swift
///未类型化指针申请未初始化的内存，以字节为单位
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

```

*UnsafeBufferPointer<Element> 表示连续存储在内存中的Element集合，可用来以元素的形式访问内存。比如：Element的真实类型为Int16时，将会访问到内存中存储的Int16的值。*

### 调用以指针作为参数的函数

**调用以指针作为参数的函数时，可以通过隐式转换来传递兼容的指针类型，或者通过隐式桥接来传递指向变量的指针或指向数组的指针。**

#### 常量指针作为参数

当调用一个函数，它携带的指针参数为UnsafePointer<Type>时，我们可以传递的参数有：

* UnsafePointer<Type>，UnsafeMutablePointer<Type>或AutoreleasingUnsafeMutablePointer<Type>，根据需要会隐式转换为 UnsafePointer<Type>。
* 如果Type为Int8 或 UInt8，可以传String的实例；字符串会自动转换为UTF8,并将指向该UTF8缓冲区的指针传递给函数
* 该Type类型的可变的变量，属性或下标，通过在左侧添加取地址符&的形式传递给函数。(隐式桥接)
* 一个Type类型的数组（[Type]），会以指向数组开头的指针传递给函数。(隐式桥接)

```swift
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
```

当调用一个函数，它携带的指针参数为UnsafeRawPointer时，可以传递与UnsafePointer<Type>相同的参数，只不过没有了类型的限制：

```swift
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
```

#### 可变指针作为参数

当调用一个函数，它携带的指针参数为UnsafeMutablePointer<Type>时，我们可以传递的参数有：

* UnsafeMutablePointer<Type>的值。
* 该Type类型的可变的变量，属性或下标，通过在左侧添加取地址符&的形式传递给函数。(隐式桥接)
* 一个Type类型的可变数组（[Type]），会以指向数组开头的指针传递给函数。(隐式桥接)

```swift
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
```

同样的，当调用一个函数，它携带的指针参数为UnsafeMutableRawPointer时，可以传递与UnsafeMutablePointer<Type>相同的参数，只不过没有了类型的限制。

```swift
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
```

**通过隐式桥接实例或数组元素创建的指针只在被调用函数执行期间有效。 转义函数执行后要使用的指针是未定义的行为。 特别是，在调用*UnsafePointer*/*UnsafeMutablePointer*/*UnsafeRawPointer*/*UnsafeMutableRawPointer* initializer时，不要使用隐式桥接。**



```swift
var number = 5
let numberPointer = UnsafePointer<Int>(&number)
// 访问 'numberPointer' 是未知行为.
var number = 5
let numberPointer = UnsafeMutablePointer<Int>(&number)
// 访问 'numberPointer' 是未知行为.
var number = 5
let numberPointer = UnsafeRawPointer(&number)
// 访问 'numberPointer' 是未知行为.
var number = 5
let numberPointer = UnsafeMutableRawPointer(&number)
// 访问 'numberPointer' 是未知行为.
```

**未知行为可能会导致难以预知的bug**

```swift
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
```

### 内存访问
***Swift中任意类型的值,Swift提供了全局函数直接访问它们的指针或内存中的字节。***
#### 访问指针

通过下列函数，Swift可以访问任意值的指针。

示例：

```swift
/// withUnsafePointer(to:_:) 只访问，不修改
/// withUnsafeMutablePointer(to:_:) 可访问，可修改

/// 只访问
let temp : [Int8] = [1,2,3,4] 
withUnsafePointer(to: temp) { point in
    print(point.pointee)
}
///规范方式：访问&修改
var temp : [Int8] = [1,2,3,4]
withUnsafeMutablePointer(to: &temp) { mPointer in
    mPointer.pointee = [6,5,4];
}
print(temp) ///[6, 5, 4]
```

*Swift的值，如果需要通过指针的方式改变，则必须为变量，并且调用上述方法时必须将变量标记为inout参数，即变量左侧添加&。常量值，不能以inout参数的形式访问指针。*

错误示例一：

```swift
///错误方式：访问&修改
var temp : [Int8] = [1,2,3,4]
withUnsafePointer(to: &temp) { point in
    let mPointer = UnsafeMutablePointer<[Int8]>.init(mutating: point)
    mPointer.pointee = [6,5,4];
}
```

***一个闭包，它的唯一参数是一个指向值的指针。 如果闭包有一个返回值，该值也被用作withUnsafePointer(to:_:)函数的返回值。 指针参数仅在函数执行期间有效。 试图通过将指针参数转换为UnsafeMutablePointer或任何其他可变指针类型来改变指针参数是未定义的行为。 如果需要通过指针改变参数，请使用withUnsafeMutablePointer(to:_:)代替。 ***

错误示例二：

```swift
var tmp : [Int8] = [1,2,3,4]
///错误1
let pointer = withUnsafePointer(to: &tmp, {$0})
let mPointer = UnsafeMutablePointer<[Int8]>.init(mutating: pointer)
mPointer.pointee = [7,8,9]
///错误2
let mutablePointer = withUnsafeMutablePointer(to: &tmp) {$0}
mutablePointer.pointee = [6,5,4,3]
```

***使用上述方法访问内存时，切记不要返回或者存储闭包参数body中的指针，供以后使用。***

#### 访问字节

通过下列函数，Swift可以访问任意值的在内存中的字节。

```swift
// withUnsafeBytes(of:_:) 只访问，不修改
// withUnsafeMutableBytes(of:_:) 可访问，可修改

///只访问，不修改
var temp : UInt32 = UInt32.max
withUnsafeBytes(of: temp) { rawBufferPointer in
    for item in rawBufferPointer.enumerated() {
        print("index:\(item.0),value:\(item.1)")
    }
}
//输出
index:0,value:255
index:1,value:255
index:2,value:255
index:3,value:255

///规范方式：访问&修改，
var temp : UInt32 = UInt32.max //4294967295
withUnsafeMutableBytes(of: &temp) { mutableRawBuffer in
    mutableRawBuffer[1] = 0;
    mutableRawBuffer[2] = 0;
    mutableRawBuffer[3] = 0;
    //mutableRawBuffer[5] = 0;/// crash
}
print(temp) ///255

```

错误示例：

```swift
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
```

***一个闭包，它的唯一参数是指向值字节的原始缓冲区指针。 如果闭包有返回值，该值也被用作withUnsafeBytes(of:_:)函数的返回值。 缓冲区指针参数仅在闭包执行期间有效。 试图通过转换为UnsafeMutableRawBufferPointer或任何其他可变指针类型来通过指针进行变异是未定义的行为。 如果你想通过指针来改变一个值，请使用withUnsafeMutableBytes(of:_:)来代替。***














