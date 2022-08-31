
import UIKit
import FirebaseFirestore
import SDWebImage  // for image

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userUrlImageArray = [String]()
    var documentIdArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
    }
    
    // MARK: method of getting from firebase
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by:"date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print("error received ")
            }else{
               
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                  
                    self.userUrlImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents{
                        
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("PostComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userUrlImageArray.append(imageUrl)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    
    //MARK:  TableView codes
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentText.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userUrlImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row] 
        return cell
    }

}
