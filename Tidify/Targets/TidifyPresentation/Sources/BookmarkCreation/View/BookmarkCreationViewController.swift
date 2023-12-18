//
//  BookmarkCreationViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Combine
import TidifyDomain
import UIKit

import SnapKit

final class BookmarkCreationViewController: BaseViewController, Coordinatable, Alertable, LoadingIndicatable {

  // MARK: - Properties
  weak var coordinator: DefaultBookmarkCreationCoordinator?
  private let viewModel: BookmarkCreationViewModel
  private let creationType: CreationType
  private let originBookmark: Bookmark?
  private let urlTextFieldView: TidifyTextFieldView
  private let titleTextFieldView: TidifyTextFieldView
  private var scrollWorkItem: DispatchWorkItem?
  private var scrollOffset: CGFloat = 0
  private var selectedFolderID: Int = 0

  var indicatorView: UIActivityIndicatorView = {
    let indicatorView: UIActivityIndicatorView = .init()
    indicatorView.color = .t_blue()
    return indicatorView
  }()

  private let topEffectView: UIVisualEffectView = {
    let blurEffect: UIBlurEffect = .init(style: .regular)
    let view: UIVisualEffectView = .init(effect: blurEffect)
    view.backgroundColor = .t_background().withAlphaComponent(0.01)
    return view
  }()

  private let bottomEffectView: UIVisualEffectView = {
    let blurEffect: UIBlurEffect = .init(style: .regular)
    let view: UIVisualEffectView = .init(effect: blurEffect)
    view.backgroundColor = .t_background()
    view.alpha = 0.76
    return view
  }()

  private lazy var scrollView: UIScrollView = {
    let scrollView: UIScrollView = .init()
    scrollView.backgroundColor = .clear
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.delegate = self
    return scrollView
  }()

  private lazy var contentView: UIView = {
    let contentView: UIView = .init()
    contentView.backgroundColor = .clear
    return contentView
  }()

  private let folderTitleLabel: UILabel = {
    let label: UILabel = .init()
    label.textColor = .t_ashBlue(weight: 800)
    label.font = .t_EB(20)
    label.text = "    폴더"
    label.backgroundColor = .white
    label.cornerRadius([.topLeft, .topRight], radius: 15)
    return label
  }()

  private lazy var folderTableView: UITableView = {
    let tableView: UITableView = .init()
    tableView.t_registerCellClass(cellType: FolderTableViewCell.self)
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .white
    tableView.cornerRadius([.bottomLeft, .bottomRight], radius: 15)
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()

  private lazy var saveButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .t_ashBlue(weight: 100)
    button.setTitle("저장", for: .normal)
    button.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    button.titleLabel?.font = .t_SB(18)
    button.cornerRadius(radius: 10)
    button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()

  // MARK: Initializer
  init(viewModel: BookmarkCreationViewModel, creationType: CreationType, originBookmark: Bookmark? = nil) {
    self.viewModel = viewModel
    self.creationType = creationType
    self.originBookmark = originBookmark
    self.urlTextFieldView = .init(type: .bookmarkURL)
    self.titleTextFieldView = .init(type: .bookmarkTitle)
    super.init(nibName: nil, bundle: nil)
    title = creationType == .create ? "북마크 생성" : "북마크 편집"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    viewModel.action(.viewDidLoad)
    super.viewDidLoad()
    setupLayoutConstraints()
    bindState()
    setupOriginBookmark()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    registerKeyboardNotification()
    urlTextFieldView.setFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeKeyboardNotification()
    coordinator?.didFinish()
  }

  override func setupViews() {
    super.setupViews()

    view.addSubview(indicatorView)
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(urlTextFieldView)
    contentView.addSubview(titleTextFieldView)
    contentView.addSubview(folderTitleLabel)
    contentView.addSubview(folderTableView)
    view.addSubview(topEffectView)
    view.addSubview(bottomEffectView)
    view.addSubview(saveButton)
  }
}

// MARK: - private
private extension BookmarkCreationViewController {
  func setupLayoutConstraints() {
    guard let navigationBarHeight = navigationController?.navigationBar.frame.height else {
      return
    }

    topEffectView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Self.topPadding + navigationBarHeight)
    }

    indicatorView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    contentView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
      $0.height.equalToSuperview().priority(.low)
    }

    urlTextFieldView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Self.topPadding + navigationBarHeight + 15)
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalTo(Self.viewHeight * 0.13)
    }

    titleTextFieldView.snp.makeConstraints {
      $0.top.equalTo(urlTextFieldView.snp.bottom).offset(15)
      $0.leading.trailing.height.equalTo(urlTextFieldView)
    }

    folderTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleTextFieldView.snp.bottom).offset(15)
      $0.leading.trailing.equalTo(titleTextFieldView)
      $0.height.equalTo(urlTextFieldView).multipliedBy(0.545)
    }

    folderTableView.snp.makeConstraints {
      $0.top.equalTo(folderTitleLabel.snp.bottom)
      $0.leading.trailing.equalTo(folderTitleLabel)
      $0.height.equalTo(0)
      $0.bottom.equalToSuperview().offset(-190)
    }

    saveButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(25)
      $0.bottom.equalToSuperview().offset(-60)
      $0.height.equalTo(Self.viewHeight * 0.066)
    }

    bottomEffectView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(saveButton).offset(-20)
    }
  }

  func bindState() {
    viewModel.$state
      .map { $0.isLoading }
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink(receiveValue: { [weak self] isLoading in
        self?.setIndicatorView(isLoading: isLoading)
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.folders }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] folders in
        self?.folderTableView.reloadData()
        self?.updateConstraints(by: folders)
      })
      .store(in: &cancellable)

    urlTextFieldView.textFieldSubject
      .sink(receiveValue: { [weak saveButton] text in
        let isEnable = !text.isEmpty
        saveButton?.isEnabled = isEnable
        saveButton?.backgroundColor = isEnable ? .t_blue() : .t_ashBlue(weight: 100)
        saveButton?.setTitleColor(isEnable ? .t_ashBlue(weight: 50) : .t_ashBlue(weight: 300), for: .normal)
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.isSuccess }
      .filter { $0 }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] _ in
        self?.coordinator?.didFinish()
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.bookmarkError }
      .compactMap { $0 }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] error in
        self?.presentAlert(type: .bookmarkCreationError)
      })
      .store(in: &cancellable)
  }

  func setupOriginBookmark() {
    guard let originBookmark = originBookmark else {
      return
    }

    urlTextFieldView.setupText(text: originBookmark.urlString ?? "")
    titleTextFieldView.setupText(text: originBookmark.name)
    selectedFolderID = originBookmark.folderID ?? 0
  }

  func updateConstraints(by folders: [Folder]) {
    folderTitleLabel.isHidden = folders.isEmpty

    guard !folders.isEmpty else {
      return
    }

    folderTableView.snp.updateConstraints {
      $0.height.equalTo(60 * folders.count + 20)
    }
  }

  @objc func didTapSaveButton() {
    let requestDTO: BookmarkRequestDTO = .init(
      folderID: selectedFolderID,
      url: urlTextFieldView.textFieldSubject.value,
      name: titleTextFieldView.textFieldSubject.value
    )

    if creationType == .edit {
      guard let originBookmark = originBookmark else {
        return
      }
      viewModel.action(.didTapUpdateBookmarkButton(id: originBookmark.id, requestDTO: requestDTO))
    } else {
      viewModel.action(.didTapCreateBookmarkButton(requestDTO))
    }
  }

  //MARK: - Keyboard
  func registerKeyboardNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  func removeKeyboardNotification() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }
    let keyboardHeight = keyboardFrame.cgRectValue.height
    let safeAreaBottomHeight = view.safeAreaInsets.bottom

    saveButton.transform = CGAffineTransform(
      translationX: 0,
      y: safeAreaBottomHeight - keyboardHeight
    )
    bottomEffectView.transform = CGAffineTransform(
      translationX: 0,
      y: safeAreaBottomHeight - keyboardHeight
    )
  }

  @objc func keyboardWillHide(_ sender: Notification) {
    saveButton.transform = .identity
    bottomEffectView.transform = .identity
  }
}

extension BookmarkCreationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.state.folders.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let folder = viewModel.state.folders[safe: indexPath.row] else {
      return .init()
    }

    let cell: FolderTableViewCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
    cell.configure(folder: folder)

    if let originBookmarkFolderID = originBookmark?.folderID,
       originBookmarkFolderID == folder.id {
      cell.setSelected(isSelected: true)
      tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }

    return cell
  }
}

extension BookmarkCreationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let folder = viewModel.state.folders[safe: indexPath.row] else {
      return
    }

    guard let cell = tableView.cellForRow(at: indexPath) as? FolderTableViewCell else {
      return
    }
    selectedFolderID = folder.id
    cell.setSelected(isSelected: true)
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? FolderTableViewCell else {
      return
    }
    cell.setSelected(isSelected: false)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    view.endEditing(true)
    let contentSizeHeight = scrollView.contentSize.height
    let paginationY = scrollView.contentOffset.y + scrollView.frame.height
    scrollOffset = scrollView.contentOffset.y

    guard paginationY + 100 > contentSizeHeight,
          scrollWorkItem == nil else {
      return
    }

    viewModel.action(.didScroll)
    let workItem = DispatchWorkItem { [weak self] in
      self?.scrollWorkItem?.cancel()
      self?.scrollWorkItem = nil
      if self?.scrollOffset != scrollView.contentOffset.y {
        self?.viewModel.action(.didScroll)
      }
    }

    scrollWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
  }
}
