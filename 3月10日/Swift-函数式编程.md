# Swift-函数式编程

## 什么是函数式编程

简单地说，函数式编程是一种编程范式，它强调通过数学风格的函数、不可变性和表达性进行计算，并尽量减少对变量和状态的使用。
因为有最小的共享状态，每个功能就像你的应用海洋中的一个岛屿，它使事情更容易测试。函数式编程之所以流行起来，还因为它可以使并发和并行处理更容易使用。这是你的工具箱中提高多核设备性能的又一件事。


* 模块化： 相较于把程序认为是一系列赋值和方法调用，函数式开发者更倾向于强调每个程序都能够被反复分解为越来越小的模块单元，而所有这些块可以通过函数装配起来，以定义一个完整的程序。当然，只有当我们能够避免在两个独立组件之间共享状态时，才能将一个大型程序分解为更小的单元。这引出我们的下一个关注特质。

* 对可变状态的谨慎处理： 函数式编程有时候 (被半开玩笑地) 称为“面向值编程”。面向对象编程专注于类和对象的设计，每个类和对象都有它们自己的封装状态。然而，函数式编程强调基于值编程的重要性，这能使我们免受可变状态或其他一些副作用的困扰。通过避免可变状态，函数式程序比其对应的命令式或者面向对象的程序更容易组合。

* 类型： 最后，一个设计良好的函数式程序在使用类型时应该相当谨慎。精心选择你的“数据和函数的类型，将会有助于构建你的代码，这比其他东西都重要。Swift 有一个强大的类型系统，使用得当的话，它能够让你的代码更加安全和健壮。

### 举个🌰

普通版本筛选
``` swift
var evens = [Int]()
for i in 1...10 {
  if i % 2 == 0 {
    evens.append(i)
  }
}
println(evens)
```

函数式的删选
```swift
func isEven(number: Int) -> Bool {
  return number % 2 == 0
}
evens = Array(1...10).filter(isEven)
println(evens)
```
1. 通过range1...10创建一个整数数组
2. 将isEven函数作为参数传递到filter函数中

更简洁的版本
```swift
evens = Array(1...10).filter { (number) in number % 2 == 0 }
println(evens)
```

更进一步
```swift
evens = Array(1...10).filter { $0 % 2 == 0 }
println(evens)
```

## 函数式语言一些有趣的特性

1. 高阶函数：这种函数的参数一个函数，或者返回值是一个函数。在这个例子中，filter就是一个高阶函数，它可以接收一个函数作为参数
2. 一级函数：你可以将函数当做是任意变量，可以将它们赋值给变量，也可以将它们作为参数传给其他函数；
3. 闭包：实际上就是匿名函数；

### 高阶函数探索

#### map

假如我们需要写一个函数，它接受一个给定的整型数组，通过计算得到并返回一个新数组，新数组各项为原数组中对应的整型数据加一。这一切，仅仅只需要使用一个 for 循环就能非常容易地实现：

```swift
func increment(array: [Int]) -> [Int] {
    var result: [Int] = []
    for x in array {
        result.append(x + 1)
    }
    return result
}
```

现在假设我们还需要一个函数，用于生成一个每项都为参数数组对应项两倍的新数组。这同样能很容易地使用一个 for 循环来实现：

```swift
func double(array: [Int]) -> [Int] {
    var result: [Int] = []
    for x in array {
        result.append(x * 2)
    }
    return result
}
```

这两个函数有大量相同的代码，我们能不能将没有区别的地方抽象出来，并单独写一个体现这种模式且更通用的函数呢？像这样的函数需要追加一个新参数来接受一个函数，这个参数能根据各个数组项计算得到新的整型数值：

```swift
func compute(array: [Int], transform: (Int) -> Int) -> [Int] {
    var result: [Int] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}
```
代码仍然不像想象中的那么灵活。假设我们想要得到一个布尔型的新数组，用于表示原数组中对应的数字是否是偶数。我们可能会尝试编写一些像下面这样的代码：
```swift
func isEven(array: [Int]) -> [Bool] {
    return compute(array: array) { $0 % 2 == 0 }
}
```
不幸的是，这段代码导致了一个类型错误。问题在于，我们的 compute 函数接受一个 (Int) -> Int 类型的参数，也就是说，该参数是一个返回整型值的函数。而在 isEven 函数的定义中，我们传递了一个 (Int) -> Bool 类型的参数，于是导致了类型错误。
我们应该如何解决这个问题呢？泛型！

```swift
func genericCompute<T>(array: [Int], transform: (Int) -> T) -> [T] {
    var result: [T] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}
```

更进一步

```swift
func map<Element, T>(_ array: [Element], transform: (Element) -> T) -> [T] {
    var result: [T] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}
```
swift惯例：
```swift
extension Array {
    func map<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}
```

#### Filter

```swift
extension Array {
func filter(_ includeElement: (Element) -> Bool) -> [Element] {
    var result: [Element] = []
    for x in self where includeElement(x) {
        result.append(x)
    }
    return result
    }
}
```

#### Reduce

定义一个计算数组中所有整型值之和的函数非常简单：
```swift
func sum(integers: [Int]) -> Int {
    var result: Int = 0
    for x in integers {
        result += x
    }
    return result
}
```

我们也可以使用类似 sum 中的 for 循环来定义一个 product 函数，用于计算所有数组项相乘之积：
```swift
func product(integers: [Int]) -> Int {
    var result: Int = 1
    for x in integers {
        result = x * result
    }
    return result
}
```

同样地，我们可能想要连接数组中的所有字符串：
```swift
func concatenate(strings: [String]) -> String {
    var result: String = ""
    for string in strings {
        result += string
    }
    return result
}
```

或者说，我们可以选择连接数组中的所有字符串，并插入一个单独的首行，以及在每一项后面追加一个换行符：
```swift
func prettyPrint(strings: [String]) -> String {
    var result: String = "Entries in the array xs:\n"
    for string in strings {
        result = "  " + result + string + "\n"
    }
    return result
}
```

这些函数有什么共同点呢？它们都将变量 result 初始化为某个值。随后对输入数组的每一项进行遍历，最后以某种方式更新结果。为了定义一个可以体现所需类型的泛型函数，我们需要对两份信息进行抽象：赋给 result 变量的初始值，和用于在每一次循环中更新 result 的函数。

```swift
extension Array {
    func reduce<T>(_ initial: T, combine: (T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
}
```

“我们可以使用 reduce 来定义新的泛型函数。例如，假设有一个数组，它的每一项都是数组，而我们想将它展开为一个单一数组。可以使用 for 循环编写一个函数：
```swift
func flatten<T>(_ xss: [[T]]) -> [T] {
    var result: [T] = []
    for xs in xss {
        result += xs
    }
    return result
}
```

然而，若使用 reduce 则可以像下面这样编写这个函数：
```swift
func flattenUsingReduce<T>(_ xss: [[T]]) -> [T] {
    return xss.reduce([]) { result, xs in result + xs }
}
```

实际上，我们甚至可以使用 reduce 重新定义 map 和 filter：

```swift
extension Array {
    func mapUsingReduce<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) { result, x in
            return result + [transform(x)]
        }
    }

    func filterUsingReduce(_ includeElement: (Element) -> Bool) -> [Element] {
        return reduce([]) { result, x in
            return includeElement(x) ? result + [x] : result
        }
    }
}
```

## 柯里化
有两种等效的方式能够定义一个可以接受两个 (或更多) 参数的函数。对于大多数程序员来说，应该会觉得第一种风格更熟悉：

```swift
func add1(_ x: Int, _ y: Int) -> Int {
    return x + y
}
```
另一个版本

```swift
func add2(_ x: Int) -> (Int)->Int {
    return {y in x + y}
}
```
```swift
add(1,2)
add2(1)(2)
```
add1 和 add2 的例子向我们展示了如何将一个接受多参数的函数变换为一系列只接受单个参数的函数，这个过程被称为柯里化 (Currying)，它得名于逻辑学家 Haskell Curry；我们将 add2 称为 add1 的柯里化版本

那么，为什么说柯里化很有趣呢？正如迄今为止我们在本书中所看到的，在一些情况下，你可能想要将函数作为参数传递给其它函数。如果我们有像 add1 一样未柯里化的函数，那我们就必须同时用到它的全部两个参数来调用这个函数。然而，对于一个像 add2 一样被柯里化了的函数来说，我们有两个选择：可以使用一个或两个参数来调用。

### 柯里化泛型版本

函数组合运算符
```swift
infix operator >>>
func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { x in g(f(x)) }
}
```
这个函数的类型极具通用性，以至于它完全决定了函数自身被定义的形式。这里我们会尝试对此进行一些不太正式的说明和讨论。
我们需要得到的是一个 C 类型的值。由于我们并不知道其它任何有关 C 的信息，所以暂时没有能够返回的值。如果知道 C 是像 Int 或者 Bool 这样的具体类型的话，我们就可以返回一个该类型的值，例如分别返回 5 或 true。但是由于我们的函数必须要能处理任意类型的 C，所以不能轻率地返回具体值。在 >>> 运算符的参数中，只有 g: (B) -> C 函数提及了类型 C。因此，将 B 类型的值传递给函数 g 是我们能够触及类型 C 的唯一途径。
同样，要得到一个 B 类型值的唯一方法是将类型为 A 的值唯一出现的地方是在我们运算符要求返回的函数的输入参数里。因此，函数组合的定义只有这唯一一种可能，才能满足所要求的泛型类型。

```swift
func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { x in { y in f(x, y) } }
}
```

## 迭代器和序列

### 迭代器

在 Objective-C 和 Swift 中，我们常常使用数据类型 Array 来表示一组有序元素。虽然数组简单而又快捷，但总会有并不适合用数组来解决的场景出现。举个例子，在总数接近无穷的时候，你可能不想对数组中所有的元素进行计算；或者你并不想使用全部的元素。在这些情况下，你可能会更希望使用一个迭代器来代替数组。
为了说明问题，我们会首先利用与数组运算相似的例子，使你觉得迭代器或许会是更好的选择。
Swift 的 for 循环可以被用于迭代数组元素：
```swift
for x in array {
// do something with x
}
```

在这样一个 for 循环中，数组会被从头遍历到尾。不过，如果你想要用不同的顺序对数组进行遍历呢？这时，迭代器就可能派上

从概念上来说，一个迭代器是每次根据请求生成数组新元素的“过程”。任何类型只要遵守以下协议，那么它就是一个迭代器：

```swift
protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}
```
这个协议需要一个由 IteratorProtocol 定义的关联类型：Element，以及一个用于产生新元素的 next 方法，如果新元素存在就返回元素本身，反之则返回 nil。

举个例子，下文的迭代器会从数组的末尾开始生成序列值，一直到 0。Element 的类型可以由方法 next 推断出来，我们不必显式地指定：
```swift
struct ReverseIndexIterator: IteratorProtocol {
    var index: Int
    init<T>(array: [T]) {
        index = array.endIndex-1
    }
    mutating func next() -> Int? {
        guard index >= 0 else { return nil }
        defer { index -= 1 }
        return index
    }
}
```

我们声明了一个输入参数为数组的构造方法，然后使用数组的最后一个合法序列值初始化 index 。
我们可以使用 ReverseIndexIterator 来倒序地遍历数组：

```swift
let letters = ["A", "B", "C"]
()
var iterator = ReverseIndexIterator(array: letters)
while let i = iterator.next() {
    print("Element \(i) of the array is \(letters[i])")
}
```

/*
 Element 2 of the array is C
 Element 1 of the array is B
 Element 0 of the array is A
*/”

在某些情况下，迭代器并不需要生成 nil 值。比如，我们可以定义一个迭代器用来生成“无数个”二的幂值 (直到该值变为某个极大值，致使 NSDecimalNumber 溢出)：
```swift
struct PowerIterator: IteratorProtocol {
    var power: NSDecimalNumber = 1
    mutating func next() -> NSDecimalNumber? {
        power = power.multiplying(by: 2)
        return power
    }
}
```

```swift
extension PowerIterator {
    mutating func find(where predicate: (NSDecimalNumber) -> Bool) -> NSDecimalNumber? {
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        return nil
    }
}
```

### 序列
迭代器为 Swift 另一个协议提供了基础类型，这个协议就是序列。迭代器提供了一个“单次触发”的机制以反复地计算出下一个元素。这种机制不支持返查或重新生成已经生成过的元素，我们想要做到这个的话就只能再创建一个新的迭代器。协议 SequenceType 则为这些功能提供了一组合适的接口：
```swift
protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    func makeIterator() -> Iterator
    // ...
}
```
每一个序列都有一个关联的迭代器类型和一个创建新迭代器的方法。我们可以据此使用该迭代器来遍历序列。举个例子，我们可以使用 ReverseIndexIterator 定义一个序列，用于生成某个数组的一系列倒序序列值：
```swift
struct ReverseArrayIndices<T>: Sequence {
    let array: [T]
    init(array: [T]) {
        self.array = array
    }
    func makeIterator() -> ReverseIndexIterator {
        return ReverseIndexIterator(array: array)
    }
}
```

每当我们希望遍历 ReverseArrayIndices 结构体中存储的数组时，我们可以调用 makeIterator 方法来生成一个需要的迭代器。下面的例子展示了如何将上述的片段组合在一起：

```swift
var array = ["one", "two", "three"]
let reverseSequence = ReverseArrayIndices(array: array)
var reverseIterator = reverseSequence.makeIterator()
while let i = reverseIterator.next() {
    print("Index \(i) is \(array[i])")
}
/*
 Index 2 is three
 Index 1 is two
 Index 0 is one
*/
```
Swift 在处理序列时有一个特别的语法。不同于创建一个序列的关联迭代器，你可以编写一个 for 循环。比如，我们也可以将以上的代码片段写成这样：

```swift
for i in ReverseArrayIndices(array: array) {
    print("Index \(i) is \(array[i])")
}
/*
 Index 2 is three
 Index 1 is two
 Index 0 is one
*/
```

实际上，Swift 所做的只是使用 makeIterator() 方法生成了一个迭代器，然后重复地调用其 next 方法直到返回 nil。

## what's more 函子、适用函子与单子

### 函子

```swift
extension Array {
    func map<R>(transform: (Element) -> R) -> Array<R>
}
extension Optional {
    func map<R>(transform: (Wrapped) -> R) -> Optional<R>
}
extension Parser {
    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T>
}
```

Optional 与 Array 都是需要一个泛型作为参数来构建具体类型的类型构造体 (Type Constructor)。对于一个实例来说，Array<T> 与 Optional<Int> 是合法的类型，而 Array 本身却并不是。每个 map 方法都需要两个参数：一个即将被映射的数据结构，和一个类型为 (T) -> U 的函数 transform。对于数组或可选值参数中所有类型为 T 的值，map 方法会使用 transform 将它们转换为 U。这种支持 map 运算的类型构造体 —— 比如可选值或数组 —— 有时候也被称作函子 (Functor)。

### 适用函子

### 单子























