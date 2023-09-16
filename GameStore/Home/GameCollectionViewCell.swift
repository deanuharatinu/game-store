import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    
    func setup(with game: GameModel) {
        gameTitle.text = game.title
        releaseYear.text = game.releaseYear
        ImageLoader.shared.loadImage(from: game.imageUrl) { [weak self] image in
            guard let self = self else { return }
            self.gameImageView.image = image
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !(gameImageView.layer.sublayers?.first is CAGradientLayer) {
            self.gameImageView.addGradient()
        }
    }
}
