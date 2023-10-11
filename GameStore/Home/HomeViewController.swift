import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var games: [GameModel] = []
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Game List"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGames()
    }
    
    private func getGames() {
        progressIndicator.startAnimating()
        let network = NetworkManager()
        network.getGameList(pageSize: 20) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                        self.games = data.toGameModel()
                        self.collectionView.reloadData()
                        self.progressIndicator.stopAnimating()
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
                    self.present(alert, animated: true)
                    NSLog(error.localizedDescription)
                    self.progressIndicator.stopAnimating()
                }
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "GameCollectionViewCell",
                for: indexPath
            ) as? GameCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setup(with: games[indexPath.row])
            return cell
        }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(
            withIdentifier: "GameDetailViewController"
        ) as? GameDetailViewController else {
            return
        }
        
        viewController.gameId = games[indexPath.row].id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
