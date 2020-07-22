import SwiftUI

struct FullscreenModalView<Presenting, Content>: View where Presenting: View, Content: View {

    @Binding var isShowing: Bool
    let parent: () -> Presenting
    let content: () -> Content

    @inlinable public init(isShowing: Binding<Bool>, parent: @escaping () -> Presenting, @ViewBuilder content: @escaping () -> Content) {
        self._isShowing = isShowing
        self.parent = parent
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.parent().zIndex(0)
                if self.$isShowing.wrappedValue {
                    self.content()
                    .background(Color.primary.colorInvert())
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)

                }
            }
        }
    }
}

extension View {

    func modal<Content>(isShowing: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content: View {
        FullscreenModalView(isShowing: isShowing, parent: { self }, content: content)
    }

}
