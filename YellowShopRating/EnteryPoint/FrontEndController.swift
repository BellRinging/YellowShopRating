//import UIKit
//import SwiftUI
//import Combine
//import FirebaseAuth
//
//class FrontEndController: UIViewController {
//
//    private var tickets: [AnyCancellable] = []
//
//    var loginPageController : UIHostingController<LoginView>?
//    var mainViewController : UIHostingController<MainView>?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addEventListener()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.checkIfProfitSetup()
//    }
//    func addEventListener(){
//        NotificationCenter.default.publisher(for: .dismissSwiftUI)
//            .sink {[weak self] (_) in
//            self?.loginPageController?.dismiss(animated: true, completion: nil)
//        }.store(in: &tickets)
//
//        NotificationCenter.default.publisher(for: .dismissMainView)
//            .sink { [weak self] (_) in
//            self?.mainViewController?.dismiss(animated: true, completion: nil)
//        }.store(in: &tickets)
//    }
//
//    @objc func showLoginPage(){
////        let loginController = UIHostingController(rootView: LoginView())
////        loginPageController = loginController
////        loginController.modalPresentationStyle = .fullScreen
////        self.present(loginController, animated: true, completion: nil)
//    }
//
//    @objc func showMainPage(){
//        let vc = UIHostingController(rootView: MainView())
//        print("Show main page")
//        mainViewController = vc
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//      }
//
//    func checkIfProfitSetup(){
////        print("Check if user login ")
////        let loginFlag = UserDefaults.standard.integer(forKey: UserDefaultsKey.LoginFlag) ?? 0
////        let uid = Auth.auth().currentUser?.uid
////        if uid == nil || loginFlag == 0 {
////            print("User not login ,show login page")
////            perform(#selector(showLoginPage), with: self, afterDelay: 0.01)
////            return
////        }
//        perform(#selector(showMainPage), with: self, afterDelay: 0.01)
//    }
//}
