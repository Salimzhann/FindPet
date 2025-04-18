//
//  MyPetViewController.swift
//  SDUPM
//
//  Created by Manas Salimzhan on 01.04.2025.
//

// File path: SDUPM/Modules/MyPets/MyPetViewController.swift

// File path: SDUPM/Modules/MyPets/MyPetViewController.swift

import UIKit
import SnapKit

protocol IMyPetViewController: AnyObject {
    var myPetsArray: [MyPetModel] { get set }
    
    func showLoading()
    func hideLoading()
    func showError(message: String)
}

class MyPetViewController: UIViewController, IMyPetViewController {
    
    private let presenter: IMyPetPresenter = MyPetPresenter()
    
    var myPetsArray: [MyPetModel] = [] {
        didSet {
            // Ensure UI updates happen on the main thread
            if Thread.isMainThread {
                collectionView.reloadData()
                updateEmptyState()
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                    self?.updateEmptyState()
                }
            }
        }
    }
    
    // MARK: - UI Components
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pawprint.circle"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No pets found"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private let emptyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Add your first pet by tapping the button below"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Pet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .systemBackground
        cv.register(MyPetCell.self, forCellWithReuseIdentifier: MyPetCell.identifier)
        return cv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemGreen
        return indicator
    }()
    
    private let errorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try Again", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
        
        (presenter as? MyPetPresenter)?.view = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "My Pets"
        
        // Add empty state view
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyLabel)
        emptyStateView.addSubview(emptyDescriptionLabel)
        
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        emptyDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // Add collection view
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
        // Add activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Add error view
        view.addSubview(errorView)
        errorView.addSubview(errorLabel)
        errorView.addSubview(refreshButton)
        
        errorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        // Add button
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addPetTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
    }
    
    private func updateEmptyState() {
        // Thread-safe check for UI updates
        if Thread.isMainThread {
            emptyStateView.isHidden = !myPetsArray.isEmpty
            collectionView.isHidden = myPetsArray.isEmpty
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.emptyStateView.isHidden = !self.myPetsArray.isEmpty
                self.collectionView.isHidden = self.myPetsArray.isEmpty
            }
        }
    }
    
    // MARK: - Data Loading
    
    private func fetchData() {
        presenter.fetchUserPets()
    }
    
    // MARK: - IMyPetViewController Methods (Thread-Safe Implementations)
    
    func showLoading() {
        if Thread.isMainThread {
            activityIndicator.startAnimating()
            errorView.isHidden = true
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.startAnimating()
                self?.errorView.isHidden = true
            }
        }
    }
    
    func hideLoading() {
        if Thread.isMainThread {
            activityIndicator.stopAnimating()
            updateEmptyState()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.updateEmptyState()
            }
        }
    }
    
    func showError(message: String) {
        if Thread.isMainThread {
            errorLabel.text = message
            errorView.isHidden = false
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.errorLabel.text = message
                self?.errorView.isHidden = false
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func addPetTapped() {
        presenter.createPet(from: self)
    }
    
    @objc private func refreshTapped() {
        if Thread.isMainThread {
            errorView.isHidden = true
            fetchData()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.errorView.isHidden = true
                self?.fetchData()
            }
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension MyPetViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPetsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPetCell.identifier, for: indexPath) as! MyPetCell
        cell.configure(with: myPetsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pet = myPetsArray[indexPath.row]
        let detailVC = MyPetDetailViewController(model: pet)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
