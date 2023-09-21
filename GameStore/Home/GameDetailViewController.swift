import UIKit

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ratingIcon: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var platform: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var gameId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContentVisibility(isHidden: true)
        progressIndicator.startAnimating()
        
        let network = NetworkManager()
        network.getGameDetail(gameId: gameId) { [weak self] result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        let gameDetail = data.toGameDetailModel()
                        self?.gameTitle.text = gameDetail.title
                        self?.imageView.sd_setImage(with: URL(string: gameDetail.imageUrl))
                        self?.rating.text = String(gameDetail.rating)
                        self?.platform.text = "Platform: \(gameDetail.platform)"
                        self?.genre.text = "Genre: \(gameDetail.genre)"
                        self?.desc.text = gameDetail.description
                        self?.progressIndicator.stopAnimating()
                        self?.setContentVisibility(isHidden: false)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                        alert.addAction(dismissAction)
                        self?.present(alert, animated: true)
                        NSLog(error.localizedDescription)
                        self?.progressIndicator.stopAnimating()
                    }
            }
        }
    }
    
    private func setContentVisibility(isHidden: Bool) {
        self.gameTitle.isHidden = isHidden
        self.rating.isHidden = isHidden
        self.ratingIcon.isHidden = isHidden
        self.platform.isHidden = isHidden
        self.genre.isHidden = isHidden
        self.descriptionTitle.isHidden = isHidden
        self.desc.isHidden = isHidden
    }
    
}
