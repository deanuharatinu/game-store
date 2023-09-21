import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Profile"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.makeRounded()
    }
    
}
