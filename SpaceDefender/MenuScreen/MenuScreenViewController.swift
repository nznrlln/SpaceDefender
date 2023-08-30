//
//  MenuScreenViewController.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 19.08.2023.
//

import UIKit
import SnapKit

class MenuScreenViewController: UIViewController {

    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.image = UIImage(named: "MenuBackground")

        return imageView
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.setBackgroundImage(
            UIImage(named: "Play"),
            for: .normal
        )
        button.addTarget(self, action: #selector(playButtonTap), for: .touchUpInside)

        return button
    }()

    private lazy var scoresButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.setBackgroundImage(
            UIImage(named: "Goblet"),
            for: .normal
        )
        button.addTarget(self, action: #selector(scoresButtonTap), for: .touchUpInside)

        return button
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.setBackgroundImage(
            UIImage(named: "Gear"),
            for: .normal
        )
        button.addTarget(self, action: #selector(settingsButtonTap), for: .touchUpInside)

        return button
    }()

    private let spaceshipImage: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.image = UIImage(named: UserDefaultsManager.shared.currentSpaceshipModel)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewInitialSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        spaceshipImage.image = UIImage(named: UserDefaultsManager.shared.currentSpaceshipModel)

        spaceshipImage.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(GameUIConstants.heroSide)
        }
    }

    private func viewInitialSettings() {
        // скрыть текст у кнопки назад в навигейщн баре
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // сделать кнопку белой
        self.navigationController?.navigationBar.tintColor = .white

        setupSubviews()
        setupSubviewLayout()
    }

    private func setupSubviews() {
        view.addSubviews(
            backgroundImage,
            spaceshipImage,
            scoresButton,
            settingsButton,
            playButton
        )
    }

    private func setupSubviewLayout() {

        backgroundImage.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }

        scoresButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.equalToSuperview().inset(16)
            make.height.width.equalTo(44)
        }

        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(44)
        }

        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(200)
        }

        spaceshipImage.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(GameUIConstants.heroSide)
        }

    }

    @objc private func playButtonTap() {
        UIView.animate(withDuration: 0.8) {
            self.spaceshipImage.center.y = self.view.frame.minY - 100
        } completion: { completed in
            if completed {
                let vc = GameViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }


    }

    @objc private func settingsButtonTap() {
        let vc = SettingsScreenViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func scoresButtonTap() {
        let vc = ScoresScreenViewController()
        navigationController?.pushViewController(vc, animated: true)

//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
