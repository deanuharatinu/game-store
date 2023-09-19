import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Profile"
    }
    
}
