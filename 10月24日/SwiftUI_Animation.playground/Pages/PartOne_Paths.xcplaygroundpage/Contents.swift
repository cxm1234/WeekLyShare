/*:
 ## 高级 SwiftUI 动画 - Part 1: Paths
 ======================
 
 ## 目录
 
 * [Paths](PartOne_Paths)
 * [GeometryEffects](PartTwo_GeometryEffects)
 * [AnimatableModifier](PartThree_AnimatableModifier)
 */

/*:
 ### **显式动画 VS 隐式动画**
 --------------
 >隐式动画是你用 .animation() 修饰符指定的那些动画。每当视图上的可动画参数发生变化时，SwiftUI 就会从旧值到新值制作动画。一些可动画的参数包括大小(size)、偏移(offset)、颜色(color)、比例(scale)等。
 >
 >显式动画是使用 withAnimation{ … } 指定的动画闭包。只有那些依赖于 withAnimation 闭包中改变值的参数才会被动画化。
 
 *动画是如何工作的*
 
 - 在所有SwiftUI动画的背后，有一个名为 Animatable 的协议。
 - 它拥有一个计算属性，其类型遵守 VectorArithmetic 协议。这使得框架可以随意地插值。
 - 当给一个视图制作动画时，SwiftUI 实际上是多次重新生成该视图，并且每次都修改动画参数。这样，它就会从原点值渐渐走向最终值。
*/

import SwiftUI

let from:Double = 0.3
let to:Double = 0.8

for i in 0..<6 {
    let pct = Double(i) / 5
    
    var difference = to - from
    difference.scale(by: pct)
    
    let currentOpacity = from + difference
    
    print("currentOpacity = \(currentOpacity)")
}

/*:
 ### 形状路径的动画化
 
![Shape](shape.png "shape")
 
 **为了使动画发生，我们需要两件事:**

 1. 我们需要改变形状的代码，使其知道如何绘制边数为非整数的多边形。
 2. 让框架多次生成这个形状，并让可动画参数一点点变化。也就是说，我们希望这个形状被要求绘制多次，每次都有一个不同的边数数值：3、3.1、3.15、3.2、3.25，一直到 4。
 
 参考例子Example 3
 
 **创建可动画数据(animatableData)**
 
 - 为了使形状可动画化，我们需要 SwiftUI 多次渲染视图，使用从原点到目标数之间的所有边值。幸运的是，Shape已经符合了Animatable协议的要求。这意味着，有一个计算的属性（animatableData），我们可以用它来处理这个任务。然而，它的默认实现被设置为EmptyAnimatableData。所以它什么都不做。

 - 为了解决我们的问题，我们将首先改变边的属性的类型，从Int到Double。这样我们就可以有小数的数字。我们将在后面讨论如何保持该属性为Int，并仍然执行动画。但是现在，为了使事情简单，我们只使用Double。
 
        struct PolygonShape: Shape {
            var sides: Double
            var animatableData: Double {
                get { return sides }
                set { sides = newValue }
            }
            ...
        }
 
 
 **设置多个参数的动画**
 
 - 很多时候，我们会发现自己需要对一个以上的参数进行动画处理。单一的Double是不够的。在这些时候，我们可以使用AnimatablePair<First, Second>。这里，第一和第二都是符合VectorArithmetic的类型。例如AnimatablePair<CGFloat, Double>。
 
 - 如果你浏览一下 SwiftUI 的声明文件，你会发现该框架相当广泛地使用AnimatablePair。比如说。CGSize、CGPoint、CGRect。尽管这些类型不符合VectorArithmetic，但它们可以被动画化，因为它们确实符合Animatable。他们都以这样或那样的方式使用AnimatablePair：
        
        extension CGPoint : Animatable {
            public typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>
            public var animatableData: CGPoint.AnimatableData
        }

        extension CGSize : Animatable {
            public typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>
            public var animatableData: CGSize.AnimatableData
        }

        extension CGRect : Animatable {
            public typealias AnimatableData = AnimatablePair<CGPoint.AnimatableData, CGSize.AnimatableData>
            public var animatableData: CGRect.AnimatableData
        }
 
 参考例子Example4, Example5
 
 **使你自己的类型动画化（通过VectorArithmetic）**
 
 - 以下类型默认实现了 Animatable : Angle, CGPoint, CGRect, CGSize, EdgeInsets, StrokeStyle 和 UnitPoint。以下类型符合VectorArithmetic。AnimatablePair, CGFloat, Double, EmptyAnimatableData 和 Float。你可以使用它们中的任何一种来为你的形状制作动画。
 
 - 现有的类型提供了足够的灵活性来实现任何东西的动画。然而，如果你发现自己有一个想做动画的复杂类型，没有什么能阻止你添加自己的VectorArithmetic协议的实现。
 
 参考例子Example6
 
 */

/*:
 ### SwiftUI + Metal
 
 启用 Metal，是非常容易的。你只需要添加 .drawingGroup() 修饰符:
    FlowerView().drawingGroup()
 
 根据 WWDC 2019, Session 237（用SwiftUI构建自定义视图）：绘图组是一种特殊的渲染方式，但只适用于图形等东西。它基本上会将 SwiftUI 视图平铺到一个单一的 NSView/UIView 中，并用 Metal 进行渲染。
 
 参考例子Example7
 */

//: [Next](@next)










