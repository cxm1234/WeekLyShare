/*:
 ## 高级 SwiftUI 动画 - Part 2: GeometryEffects
 ======================
 
 ## 目录
 
 * [Paths](PartOne_Paths)
 * [GeometryEffects](PartTwo_GeometryEffects)
 * [AnimatableModifier](PartThree_AnimatableModifier)
 * [TimelineView](PartFour_TImelineView)
 */

/*:
 ### GeometryEffect
 
 >   对变换矩阵进行动画处理
 >
 > GeometryEffect是一个符合Animatable和ViewModifier的协议。为了符合GeometryEffect协议，你需要实现以下方法：
 
          func effectValue(size: CGSize) -> ProjectionTransform
 
 假设你的类叫SkewEffect，为了把它应用到一个视图上，你会这样使用它：
 
           Text("Hello").modifier(SkewEfect(skewValue: 0.5))
 
 Text("Hello")将被转换为由SkewEfect.effectValue()方法创建的矩阵。就这么简单。请注意，这些变化将影响视图，但不会影响其祖先或后代的布局。

 因为GeometryEffect也符合Animatable，你可以添加一个animatableData属性，然后你就有了一个可动的效果。
 
 如果你曾经使用过.offset()，你实际上是在使用GeometryEffect。让我告诉你它是如何实现的：
 
 */

/*
public extension View {
    func offset(x: CGFloat, y: CGFloat) -> some View {
        return modifier(_OffsetEffect(offset: CGSize(width: x, height: y)))
    }
    
    func offset(_ offset: CGSize) -> some View {
        return modifier(_OffsetEffect(offset: offset))
    }
}

struct _OffsetEffect: GeometryEffect {
    var offset: CGSize
    
    var animatableData: CGSize.AnimatableData {
        get { CGSize.AnimatableData(offset.width, offset.height) }
        set { offset = CGSize(width: newValue.first, height: newValue.second) }
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: offset.width, y: offset.height))
    }
}
*/

/*:
 ### Animation Keyframes
 大多数动画框架都有关键帧的概念。它是一种告诉动画引擎将动画分成若干块的方式。虽然 SwiftUI 没有这些功能，但我们可以模拟它。在下面的例子中，我们将创建一个水平移动视图的效果，但它也会在开始时倾斜，在结束时取消倾斜：
 
 参考例子Example 8
 
 */

/*:
 ### 动画反馈
 我们将创建一个效果，让我们进行三维旋转。虽然SwiftUI已经有了一个修饰符，即.rotrotation3DEffect()，但这个修饰符将是特别的。
 
 参考例子Example 9
 
 */

/*:
 ### 让视图遵循一个路径
 接下来，我们将建立一个完全不同的GeometryEffect。在这个例子中，我们的效果将通过一个任意的路径移动一个视图。这个问题有两个主要挑战:

 1. 如何获取路径中特定点的坐标。

 2. 如何在通过路径移动时确定视图的方向。在这个特定的案例中，我们如何知道飞机的机头指向哪里（扰流板警告，一点三角函数就可以了）。
 
 参考例子Example 10
 */

/*:
 ### Ignored By Layout
 > Returns an effect that produces the same geometry transform as this effect, but only applies the transform while rendering its view.
 >
 > 返回一个产生与此效果相同的几何变换的效果，但只在渲染其视图时应用该变换。
 >
 > Use this method to disable layout changes during transitions. The view ignores the transform returned by this method while the view is performing its layout calculations.
 >
 > 使用此方法可以在转换期间禁用布局更改。在视图执行布局计算时，视图将忽略此方法返回的变换。
 
 参考例子Example 11
 */

//: [Next](@next)
