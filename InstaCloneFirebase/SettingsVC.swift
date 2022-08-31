
import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logouthClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()  //Redirecting to login page after logout
            
            self.performSegue(withIdentifier: "toSecondVC", sender: nil)
        }catch{
            print("error")
        }
       
    }
    

}
