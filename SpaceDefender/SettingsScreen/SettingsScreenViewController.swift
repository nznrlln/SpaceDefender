//
//  SettingsScreenViewController.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 19.08.2023.
//

import UIKit
import SnapKit

enum Spaceships {
    static let models = ["Red Spaceship", "Green Spaceship", "Blue Spaceship"]
}

final class SettingsScreenViewController: UIViewController {

    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.image = UIImage(named: "SettingsBackground")

        return imageView
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "Nickname: "
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        return label
    }()

    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.toAutoLayout()
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter your nickname",
            attributes: [.foregroundColor : UIColor.black]
        )
        textField.text = UserDefaultsManager.shared.currentUserNickname
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        textField.textColor = .white
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        textField.delegate = self

        return textField
    }()

    private let nicknameView: UIView = {
        let view = UIView()
        view.toAutoLayout()

        return view
    }()

    private let spaceshipModelLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = UserDefaultsManager.shared.currentSpaceshipModel
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center

        return label
    }()

    private let spaceshipModelImage: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.image = UIImage(named: UserDefaultsManager.shared.currentSpaceshipModel)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.setImage(
            UIImage(named: "LeftArrow")?.withTintColor(.white),
            for: .normal
        )
        button.addTarget(self, action: #selector(modelChanged), for: .touchUpInside)

        return button
    }()

    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.setImage(
            UIImage(named: "RightArrow")?.withTintColor(.white),
            for: .normal
        )
        button.addTarget(self, action: #selector(modelChanged), for: .touchUpInside)

        return button
    }()

    private let spaceshipView: UIView = {
        let view = UIView()
        view.toAutoLayout()

        return view
    }()

    private let speedLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "Choose your game speed: "
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center

        return label
    }()

    private let currentSpeedLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = String(round(UserDefaultsManager.shared.currentGameSpeed * 100)/100)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center

        return label
    }()

    private lazy var speedSlider: UISlider = {
        let slider = UISlider()
        slider.toAutoLayout()
        slider.value = UserDefaultsManager.shared.currentGameSpeed
        slider.minimumValue = 0.5
        slider.maximumValue = 2.0
        slider.minimumValueImage = UIImage(named: "Snail")?.withTintColor(.systemBlue)
        slider.maximumValueImage = UIImage(named: "Swift")
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)

        return slider
    }()

    private let speedView: UIView = {
        let view = UIView()
        view.toAutoLayout()

        return view
    }()

    private lazy var viewTapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeybord))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewInitialSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewLastSettings()
    }

    private func viewInitialSettings() {
        self.title = "Settings"
        // сделать заголовок экрана белым
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]

        setupSubviews()
        setupSubviewLayout()
        setupGestures()
    }

    private func viewLastSettings() {
        self.navigationController?.navigationBar.isHidden = false
        speedSlider.value = UserDefaultsManager.shared.currentGameSpeed
    }

    private func setupSubviews() {
        view.addSubviews(
            backgroundImage,
            nicknameView,
            spaceshipView,
            speedView
        )

        nicknameView.addSubviews(
            nicknameLabel,
            nicknameTextField
        )

        spaceshipView.addSubviews(
            spaceshipModelLabel,
            spaceshipModelImage,
            leftButton,
            rightButton
        )

        speedView.addSubviews(
            speedLabel,
            currentSpeedLabel,
            speedSlider
        )
    }

    private func setupSubviewLayout() {
        //main view blocks
        backgroundImage.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }

        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        spaceshipView.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
        }

        speedView.snp.makeConstraints { make in
            make.top.equalTo(spaceshipView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            make.height.equalTo(100)
        }

        // details
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(16)
        }

        spaceshipModelLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        spaceshipModelImage.snp.makeConstraints { make in
            make.top.equalTo(spaceshipModelLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        leftButton.snp.makeConstraints { make in
            make.top.equalTo(spaceshipModelLabel.snp.bottom).offset(16)
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(spaceshipModelImage.snp.leading).offset(-16)
        }
        rightButton.snp.makeConstraints { make in
            make.top.equalTo(spaceshipModelLabel.snp.bottom).offset(16)
            make.leading.equalTo(spaceshipModelImage.snp.trailing).offset(16)
            make.trailing.bottom.equalToSuperview().inset(16)
        }

        speedLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        currentSpeedLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualTo(nicknameLabel.snp.trailing).offset(16)
        }
        speedSlider.snp.makeConstraints { make in
            make.top.equalTo(speedLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }

    }

    private func setupGestures() {
        view.addGestureRecognizer(viewTapGR)
    }

    private func leftButtonTap() {
        guard let text = spaceshipModelLabel.text else { return }
        guard let index = Spaceships.models.firstIndex(of: text) else { return }
        if index > 0 {
            updateSpaceship(Spaceships.models[index - 1])
        } else {
            updateSpaceship(Spaceships.models[Spaceships.models.count - 1])
        }
    }

    private func rightButtonTap() {
        guard let text = spaceshipModelLabel.text else { return }
        guard let index = Spaceships.models.firstIndex(of: text) else { return }
        if index < Spaceships.models.count - 1 {
            updateSpaceship(Spaceships.models[index + 1])
        } else {
            updateSpaceship(Spaceships.models[0])

        }
    }

    private func updateSpaceship(_ model: String) {
        spaceshipModelLabel.text = model
        spaceshipModelImage.image = UIImage(named: model)
        UserDefaultsManager.shared.currentSpaceshipModel = model
    }

    @objc private func modelChanged(_ sender: UIButton) {
        switch sender {
        case leftButton:
            leftButtonTap()
        case rightButton:
            rightButtonTap()
        default:
            return
        }
//
//        if let text = spaceshipModelLabel.text,
//           Spaceships.models.contains(text) {
//
//        }
    }

    @objc private func textFieldChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        UserDefaultsManager.shared.currentUserNickname = text
    }

    @objc private func sliderChanged() {
        let rounded = round(speedSlider.value * 100)/100
        currentSpeedLabel.text = String(rounded)
        UserDefaultsManager.shared.currentGameSpeed = rounded
    }

    @objc private func hideKeybord() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension SettingsScreenViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
