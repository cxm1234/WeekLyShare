/*:
 ## 高级 SwiftUI 动画 - Part 4: TimelineView
 ======================
 
 ## 目录
 
 * [Paths](PartOne_Paths)
 * [GeometryEffects](PartTwo_GeometryEffects)
 * [AnimatableModifier](PartThree_AnimatableModifier)
 * [TimelineView](PartFour_TImelineView)
 */

/*:
 ### TimelineView 的组件
 
 TimelineView 是一个容器视图，它以相关调度程序确定的频率重新评估其内容：
 
            TimelineView(.periodic(from: .now, by: 0.5)) {  timeline in
                ViewToEvaluatePeriodically()
            }
 
 TimelineView 接收调度程序作为参数。
 
            TimelineView(<#T##schedule: TimelineSchedule##TimelineSchedule#>, content: <#T##(TimelineView<TimelineSchedule, View>.Context) -> View#>)
 
 另一个参数是一个内容闭包，它接收一个看起来像这样的 TimelineView.Context 参数：
 
            struct Context {
                let cadence: Cadence
                let date: Date

                enum Cadence: Comparable {
                    case live
                    case seconds
                    case minutes
                }
            }
 
 Cadence 是一个枚举类型，我们可以使用它来决定在我们的视图中显示什么。可能的值是：live、seconds 和 minutes。以此为提示，避免显示与 Cadence 无关的信息。典型的例子，是避免在具有秒或分钟节奏的调度程序的时钟上显示毫秒。

 请注意，Cadence 不是你可以更改的东西，而是反映设备状态的东西。文档仅提供了一个例子。在 watchOS 上，降低手腕时 Cadence 会减慢。
 
 参考例子 Example 17
 */

