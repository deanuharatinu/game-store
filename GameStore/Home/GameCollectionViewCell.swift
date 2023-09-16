import UIKit
import SDWebImage

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    
    func setup(with game: GameModel) {
        gameTitle.text = game.title
        releaseYear.text = game.releaseYear
        gameImageView.sd_setImage(with: URL(string: game.imageUrl))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !(gameImageView.layer.sublayers?.first is CAGradientLayer) {
            self.gameImageView.addGradient()
        }
    }
}
