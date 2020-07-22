import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    init(closeFlag:Binding<Bool>,loginFlag:Binding<Int>){
        viewModel = LoginViewModel(closeFlag: closeFlag,loginFlag:loginFlag)
    }
    
    var body: some View {
        NavigationView{
            VStack {
                loginArea.padding()
                loginButton.padding()
                HStack{
                    //                googleButton
                    Spacer()
                }.padding()
                Spacer()
            }
            .navigationBarTitle("Login")
            .navigationBarItems(trailing: CancelButton(self.viewModel.$closeFlag))
        }
    }
    
    var loginButton : some View{
        Button(action: {
            self.viewModel.normalLogin()
        }){
            HStack(alignment: .center) {
                Text("Login")
                    .textStyle(size: 16 , color: Color.white)
                    .frame(maxWidth:.infinity)
            }.padding()
        }
        .background(Color.greenColor)
            .padding()
            .shadow(radius: 5)
    }
    
    var loginArea : some View{
        VStack{
            TextField("Email", text: $viewModel.email)
                .font(MainFont.forPlaceHolder())
                .padding()
                .cornerRadius(10)
                .background(Color.whiteGaryColor)
            .autocapitalization(.none)

            SecureField("Password", text: $viewModel.password)
                .font(MainFont.forPlaceHolder())
                .padding()
                .cornerRadius(10)
                .background(Color.whiteGaryColor)
            .autocapitalization(.none)
            HStack{
                Text("Register Account")
                    .font(MainFont.forPlaceHolder())
                    .foregroundColor(SwiftUI.Color.redColor)
                    .onTapGesture {
                        withAnimation {                       
                            self.viewModel.showRegisterPage = true
                        }
                    }
                Spacer()
                Text("Forget Password")
                    .font(MainFont.forPlaceHolder())
                    .foregroundColor(SwiftUI.Color.redColor)
                .onTapGesture {
                    withAnimation {
                        self.viewModel.showForgetPassword = true
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    var googleButton : some View {
        Circle()
            .fill(Color.init(red: 219/255, green: 68/255, blue: 55/255))
            .frame(width: 50, height: 50)
            .overlay(
                Image("icon-google")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 30, height: 30)
        ).shadow(radius: 5)
            .onTapGesture {
                SocialLogin().attemptLoginGoogle()
        }
    }
    
}

