//
//  ScoresScreenViewController.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 20.08.2023.
//

import UIKit

class ScoresScreenViewController: UIViewController {

    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.image = UIImage(named: "ScoresBackground")

        return imageView
    }()

    private lazy var scoresTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.toAutoLayout()
        tableView.layer.cornerRadius = 8
        tableView.backgroundColor = .clear

        tableView.register(
            ScoreTableViewCell.self,
            forCellReuseIdentifier: ScoreTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewInitialSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false
    }

    private func viewInitialSettings() {
        self.title = "Highscores"
        // сделать заголовок экрана белым
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]

        setupSubviews()
        setupSubviewLayout()
    }

    private func setupSubviews() {
        view.addSubviews(
            backgroundImage,
            scoresTableView
        )
    }

    private func setupSubviewLayout() {
        backgroundImage.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }

        scoresTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

}


// MARK: - UITableViewDataSource

extension ScoresScreenViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        UserDefaultsManager.shared.scores.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScoreTableViewCell.identifier,
            for: indexPath
        ) as! ScoreTableViewCell

        let model = UserDefaultsManager.shared.scores[indexPath.section]
        cell.setupCell(with: model)

        return cell
    }


}

// MARK: - UITableViewDelegate

extension ScoresScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: .zero)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        4
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: .zero)
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        4
    }
}

