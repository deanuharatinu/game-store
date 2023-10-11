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
    private var favoriteBarButtonItem: UIBarButtonItem?
    
    var gameId: String = ""
    
    private lazy var gameProvider: GameProvider = GameProvider()
    private var gameDetail: GameDetailModel?
    private var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar()
        setContentVisibility(isHidden: true)
        initData()
    }
    
    @objc private func didAddFavorite() {
        guard let gameDetail = self.gameDetail else { return }
        self.gameProvider.saveGameDetail(gameDetail: gameDetail) { isSuccess in
            DispatchQueue.main.async {
                if isSuccess {
                    print("favorite true")
                    self.isFavorite = true
                    self.setFavoriteButton()
                } else {
                    print("favorite false")
                    self.isFavorite = false
                    self.setFavoriteButton()
                    self.gameProvider.deleteGameDetailById(gameDetail.id) {}
                }
            }
        }
    }
    
    private func initData() {
        let network = NetworkManager()
        
        progressIndicator.startAnimating()
        network.getGameDetail(gameId: gameId) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.gameDetail = data.toGameDetailModel()
                    guard let gameDetail = self?.gameDetail else { return }
                        
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
                    let alert = UIAlertController(
                        title: "Error",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                    alert.addAction(dismissAction)
                    self?.present(alert, animated: true)
                    NSLog(error.localizedDescription)
                    self?.progressIndicator.stopAnimating()
                }
            }
        }
        
        getFavoriteDetail()
    }
    
    private func getFavoriteDetail() {
        self.gameProvider.getGameDetailById(gameId) { gameDetailModel in
            if gameDetailModel != nil {
                self.isFavorite = true
                self.setFavoriteButton()
            } else {
                self.isFavorite = false
                self.setFavoriteButton()
            }
        }
    }
    
    private func setFavoriteButton() {
        if isFavorite {
            self.favoriteBarButtonItem?.image = UIImage(systemName: "heart.fill")
            self.favoriteBarButtonItem?.tintColor = .red
        } else {
            self.favoriteBarButtonItem?.image = UIImage(systemName: "heart")
            self.favoriteBarButtonItem?.tintColor = .white
        }
    }
    
    private func initNavigationBar() {
        favoriteBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(didAddFavorite))
        self.navigationItem.rightBarButtonItem  = favoriteBarButtonItem
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
