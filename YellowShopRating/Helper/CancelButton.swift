import SwiftUI

struct CancelButton : View {
    @Binding var closeFlag : Bool
    
    init(_ closeFlag : Binding<Bool>){
        self._closeFlag = closeFlag
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.closeFlag.toggle()
            }
        }) {
            HStack{
                Text("Close").foregroundColor(Color.red)
            }
        }
    }
}

struct ConfirmButton : View {
    
    var action : ()->()
    
    var body: some View {
        Button(action: {
            self.action()
        }, label:{
            Text("確認")
                .foregroundColor(Color.red)
        }).padding()
    }
    
    
}


