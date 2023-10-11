import UIKit
import SDWebImage

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var platform: UILabel!

    func setup(with game: GameModel) {
        gameTitle.text = game.title
        // format to "yyyy" only
        releaseYear.text = game.releaseYear.toDateFormattedString(from: "yyyy-MM-dd", to: "yyyy")
        gameImageView.sd_setImage(with: URL(string: game.imageUrl))
        platform.text = game.platform
        rating.text = String(game.rating)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !(gameImageView.layer.sublayers?.first is CAGradientLayer) {
            self.gameImageView.addGradient()
        }
    }
}
