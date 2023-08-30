//
//  ScoreTableViewCell.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 20.08.2023.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    private let spaceshipModelImage: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()

        return label
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        cellInitialSettings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func cellInitialSettings() {
        self.backgroundColor = .white.withAlphaComponent(0.5)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true

        setupSubviews()
        setupSubviewLayout()
    }

    func setupCell(with model: ScoreModel?) {
        guard let model = model else { return }

        spaceshipModelImage.image = UIImage(named: model.spaceshipModel)
        nicknameLabel.text = model.userNickname
        scoreLabel.text = "Score: \(model.userScore)"
    }

    override func prepareForReuse() {
        spaceshipModelImage.image = nil
        nicknameLabel.text = nil
        scoreLabel.text = nil
    }

    private func setupSubviews() {
        contentView.addSubviews(
            spaceshipModelImage,
            nicknameLabel,
            scoreLabel
        )
    }

    private func setupSubviewLayout() {
        spaceshipModelImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(8)
            make.height.width.equalTo(GameUIConstants.heroSide)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(spaceshipModelImage)
            make.leading.equalTo(spaceshipModelImage.snp.trailing).offset(8)
            make.trailing.equalTo(scoreLabel.snp.leading).offset(-8)
        }
        scoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(spaceshipModelImage)
            make.trailing.equalToSuperview().inset(8)
            make.width.lessThanOrEqualTo(100)
        }
    }
}
