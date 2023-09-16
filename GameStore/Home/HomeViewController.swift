import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var games: [GameModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGames()
    }
    
    private func getGames() {
        let network = NetworkManager()
        network.getGameList(pageSize: 20) { result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.games = data.toGameModel()
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    NSLog(error.localizedDescription)
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(with: games[indexPath.row])
        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
