
import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: user login
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { AuthData, AuthError in
                if AuthError != nil {
                    self.makeAlert(title: "Error!", msg: AuthError?.localizedDescription ?? "Error")
                    
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            makeAlert(title: "Error", msg: "Username/Password may not be entered, please check.")
        }
        
    }
    // MARK: user registration
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, authError in
                
                
                if authError != nil {
                    self.makeAlert(title: "Error", msg: authError?.localizedDescription ?? "Error")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            makeAlert(title: "Error", msg: "Username/Password may not be entered, please check.")

        }
       
        
    }
    //MARK: ALERT FUNC
    func makeAlert(title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

