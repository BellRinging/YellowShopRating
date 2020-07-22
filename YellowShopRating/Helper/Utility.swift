import SwiftEntryKit
import SwiftUI
import MBProgressHUD
typealias Action = () -> ()
import CoreLocation


class Utility {
    
    static var currentNonce : String?
    
    static var currentLocation : CLLocation?
    
      static func showProgress(){

        DispatchQueue.main.async {
            guard let mainWindow = UIApplication.shared.window else {return}
            let progressIcon = MBProgressHUD.showAdded(to: mainWindow, animated: true)
            progressIcon.labelText = "Loading"
            progressIcon.isUserInteractionEnabled = false
            //tempView
            let tempView = UIView(frame: (mainWindow.frame))
            tempView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            tempView.tag = 999
            mainWindow.addSubview(tempView)
            progressIcon.show(animated: true)
        }
    }
    
    static func hideProgress(){
        DispatchQueue.main.async {
            guard let mainWindow =  UIApplication.shared.window else {return}
            MBProgressHUD.hideAllHUDs(for: mainWindow, animated: true)
            let view = mainWindow.viewWithTag(999)
            view?.removeFromSuperview()
        }
    }
   
    static func showAlert(message : String , callBack : (Action)?  = nil){
           
        var alertView = CustomAlertView(message: message)
        if let callBack = callBack{
            alertView = CustomAlertView(message: message,callBack: callBack)
        }
        let customView = UIHostingController(rootView: alertView)
        var attributes = EKAttributes()
        attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .forward
        attributes.entryInteraction = .forward
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.positionConstraints.size = .init(width: .offset(value: 50), height: .intrinsic)
        let edgeWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: edgeWidth), height: .intrinsic)
        attributes.roundCorners = .all(radius: 10)
        SwiftEntryKit.display(entry: customView, using: attributes)
    }
    
   
    
    
    
}
