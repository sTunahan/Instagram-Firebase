

import UIKit
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class UploadVC: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary  // veriyi nereden alacağını söylüyoruz.
        present(pickerController, animated: true, completion: nil)
    }
    //after the election
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func makeAlertMessage(title:String,msg:String){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        // MARK: Step to reach storage in Firebase
        let storage = Storage.storage()
        let storageReference =  storage.reference() // folder reference to save
        let mediaFolder = storageReference.child("media")
        
        // MARK: step of converting the image to data and saving it as data
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString // each data should be recorded according to its own ID number
            
            let  imageReference = mediaFolder.child("\(uuid).jpg")
            
            
            imageReference.putData(data, metadata: nil) { metaData, metaError in
                
                if metaError != nil {
                    self.makeAlertMessage(title: "Error!", msg: metaError?.localizedDescription ?? "An Error Occurred While Loading The Database...")
                }else {
                    
                    imageReference.downloadURL { url, urlError in
                        
                       
                        if urlError == nil {
                            
                            let imageUrl = url?.absoluteString   // convert url to string
                            
                            // MARK: save to database
                             
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            
                            //Oluşturulan içerik
                            let firestorePost = ["imageUrl":imageUrl!,"postedBy": Auth.auth().currentUser!.email! ,"PostComment":self.commentText.text! , "date": FieldValue.serverTimestamp() ,"likes": 0] as [String : Any]
                            
                            
                             firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { Error in
                                
                                if Error != nil {
                                    self.makeAlertMessage(title: "Error!", msg: Error?.localizedDescription ?? "An Error Occurred While Uploading to Database")
                                }else {
                                    
                                    //if registration is ok
                                    
                                    // 1) screen cleaning process
                                    self.imageView.image = UIImage(named: "selectt.png")
                                    self.commentText.text = ""
                                    // 2) process to go to home screen
                                    self.tabBarController?.selectedIndex = 0  // take me to the page in the zero index of the tabbar when the registration process is complete
                                }
                            })
                        }
                    }
                    
                }
            }
            
        }
        
        
    }
    

}
