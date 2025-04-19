import UIKit
import SnapKit


class ChatViewController: UIViewController {
    
    private let chat: Chat
    private var messages: [ChatMessage] = []
    private var currentUserId: Int = 1
    private let presenter: ChatPresenter
    private var isShowingAlert = false
    private var isOtherUserOnline = false
    private var otherUserLastActive: Date?
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OutgoingMessageCell.self, forCellReuseIdentifier: "OutgoingMessageCell")
        tableView.register(IncomingMessageCell.self, forCellReuseIdentifier: "IncomingMessageCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 3
        return view
    }()
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 18
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        textView.placeholder = "Сообщение..."
        return textView
    }()
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.tintColor = .systemGreen
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        return button
    }()
    private let typingIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.isHidden = true
        return view
    }()
    private let typingLabel: UILabel = {
        let label = UILabel()
        label.text = "печатает..."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemGreen
        return indicator
    }()
    private let userStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 6
        view.isHidden = true
        return view
    }()
    private let userStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    init(chat: Chat) {
        self.chat = chat
        self.presenter = ChatPresenter(chatId: chat.id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActions()
        setupKeyboardObservers()
        
        if let userId = UserDefaults.standard.object(forKey: "current_user_id") as? Int {
            currentUserId = userId
        } else {
            currentUserId = chat.user1_id
        }
        
        title = chat.otherUserName
        presenter.view = self
        
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchChatDetails()
        presenter.fetchMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.connectToWebSocket()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.disconnectFromWebSocket()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        view.addSubview(activityIndicator)
        
        inputContainerView.addSubview(messageTextView)
        inputContainerView.addSubview(sendButton)
        
        view.addSubview(typingIndicatorView)
        typingIndicatorView.addSubview(typingLabel)
        
        view.addSubview(userStatusView)
        userStatusView.addSubview(userStatusLabel)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputContainerView.snp.top)
        }
        
        inputContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.greaterThanOrEqualTo(60)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.height.greaterThanOrEqualTo(36).priority(.high)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        typingIndicatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(inputContainerView.snp.top).offset(-8)
            make.height.equalTo(24)
        }
        
        typingLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
        }
        
        userStatusView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.height.equalTo(22)
        }
        
        userStatusLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .systemGreen
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        let avatarView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        avatarView.image = UIImage(systemName: "person.circle.fill")
        avatarView.tintColor = .systemGreen
        avatarView.contentMode = .scaleAspectFit
        avatarView.layer.cornerRadius = 15
        avatarView.clipsToBounds = true
        
        let nameLabel = UILabel(frame: CGRect(x: 40, y: 0, width: 160, height: 20))
        nameLabel.text = chat.otherUserName
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        let statusLabel = UILabel(frame: CGRect(x: 40, y: 22, width: 160, height: 18))
        statusLabel.text = "В сети"
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = .systemGray
        
        titleView.addSubview(avatarView)
        titleView.addSubview(nameLabel)
        titleView.addSubview(statusLabel)
        
        navigationItem.titleView = titleView
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.transform = CGAffineTransform.identity
        
        let backgroundImage = UIImageView()
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.1
        backgroundImage.image = UIImage(systemName: "bubble.left.and.bubble.right")
        backgroundImage.tintColor = .systemGray3
        
        tableView.backgroundView = backgroundImage
    }
    
    private func setupActions() {
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
        
        messageTextView.delegate = self
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func sendButtonTapped() {
        guard let messageText = messageTextView.text, !messageText.isEmpty else { return }
        
        presenter.sendMessage(content: messageText)
        
        // Clear the input field
        messageTextView.text = ""
        updateTextViewHeight()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let bottomInset = keyboardSize.height - view.safeAreaInsets.bottom
        
        UIView.animate(withDuration: 0.3) {
            self.inputContainerView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-bottomInset)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.inputContainerView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateTextViewHeight() {
        let fixedWidth = messageTextView.frame.size.width
        let newSize = messageTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let newHeight = min(max(newSize.height, 36), 100)
        
        // Используем remakeConstraints вместо updateConstraints для messageTextView
        messageTextView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.height.greaterThanOrEqualTo(newHeight).priority(.high)
        }
        
        // Обновляем высоту всего контейнера
        let containerHeight = newHeight + 20 // 10 сверху и 10 снизу
        
        inputContainerView.snp.updateConstraints { make in
            make.height.greaterThanOrEqualTo(containerHeight)
        }
        
        // Обновляем UI на main thread
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func updateUserStatusUI() {
        DispatchQueue.main.async {
            if self.isOtherUserOnline {
                self.userStatusLabel.text = "В сети"
                self.userStatusView.backgroundColor = .systemGreen.withAlphaComponent(0.2)
                self.userStatusLabel.textColor = .systemGreen
                
                // Обновляем статус в навигационной панели
                if let titleView = self.navigationItem.titleView,
                   let statusLabel = titleView.subviews.last as? UILabel {
                    statusLabel.text = "В сети"
                    statusLabel.textColor = .systemGreen
                }
            } else if let lastActive = self.otherUserLastActive {
                // Format the last active time
                let formatter = RelativeDateTimeFormatter()
                formatter.unitsStyle = .short
                let relativeTime = formatter.localizedString(for: lastActive, relativeTo: Date())
                let statusText = "Активен \(relativeTime)"
                self.userStatusLabel.text = statusText
                self.userStatusView.backgroundColor = .systemGray6
                self.userStatusLabel.textColor = .secondaryLabel
                
                // Обновляем статус в навигационной панели
                if let titleView = self.navigationItem.titleView,
                   let statusLabel = titleView.subviews.last as? UILabel {
                    statusLabel.text = statusText
                    statusLabel.textColor = .systemGray
                }
            } else {
                self.userStatusView.isHidden = true
                return
            }
            
            self.userStatusView.isHidden = false
            
            // Обновляем ширину, когда текст готов
            let labelWidth = self.userStatusLabel.intrinsicContentSize.width
            self.userStatusView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(4)
                make.height.equalTo(22)
                make.width.equalTo(labelWidth + 24)
            }
        }
    }
    
    // Helper method for safely showing alerts
    private func showAlertIfPossible(title: String, message: String) {
        guard !isShowingAlert,
              let rootVC = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        // Find the top view controller where we can show an alert
        var topVC = rootVC
        while let presentedVC = topVC.presentedViewController,
              !(presentedVC is UIAlertController) {
            topVC = presentedVC
        }
        
        // If an alert is already being shown, do nothing
        if topVC.presentedViewController is UIAlertController {
            return
        }
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
//            self.isShowingAlert = false
//        })
//        
//        isShowingAlert = true
//        topVC.present(alert, animated: true)
    }
    
    // Метод для прокрутки чата вниз к последнему сообщению
    private func scrollToBottom(animated: Bool = true) {
        guard !messages.isEmpty else { return }
        
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        let indexPath = IndexPath(row: lastRow, section: 0)
        
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
}

// MARK: - ChatViewProtocol

extension ChatViewController: ChatViewProtocol {
    func updateChatInfo(_ chat: Chat) {
        title = chat.otherUserName
        
        // Обновляем имя в навигационной панели
        if let titleView = navigationItem.titleView,
           let nameLabel = titleView.subviews[1] as? UILabel {
            nameLabel.text = chat.otherUserName
        }
    }
    
    func setMessages(_ messages: [ChatMessage]) {
        self.messages = messages
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.scrollToBottom(animated: false)
            
            // Mark all unread messages as read
            for message in self.messages where !message.is_read && message.sender_id != self.currentUserId {
                self.presenter.markMessageAsRead(messageId: message.id)
            }
        }
    }
    
    func addMessage(_ message: ChatMessage) {
        // Check if the message already exists
        if !messages.contains(where: { $0.id == message.id }) {
            // Add to the end of the array for standard table view
            messages.append(message)
            
            DispatchQueue.main.async {
                // Update UI
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                self.scrollToBottom()
                
                // Mark message as read if it's not from the current user
                if !message.is_read && message.sender_id != self.currentUserId {
                    self.presenter.markMessageAsRead(messageId: message.id)
                }
            }
        }
    }
    
    func showTypingIndicator(_ isTyping: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.typingIndicatorView.isHidden = !isTyping
            }
        }
    }
    
    func updateUserStatus(_ userId: Int, isOnline: Bool, lastActiveAt: Date?) {
        // Only update if it's the other user
        let otherUserId = currentUserId == chat.user1_id ? chat.user2_id : chat.user1_id
        if userId == otherUserId {
            isOtherUserOnline = isOnline
            otherUserLastActive = lastActiveAt
            updateUserStatusUI()
        }
    }
    
    func markMessageAsRead(_ messageId: Int) {
        // Find and update the message in the array
        if let index = messages.firstIndex(where: { $0.id == messageId }) {
            messages[index].is_read = true
            
            DispatchQueue.main.async {
                // Only refresh the specific row that changed
                if let visibleRows = self.tableView.indexPathsForVisibleRows,
                   visibleRows.contains(IndexPath(row: index, section: 0)) {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.tableView.isHidden = true
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.showAlertIfPossible(title: "Ошибка", message: message)
        }
    }
}

// MARK: - UITableView DataSource & Delegate

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.sender_id == currentUserId {
            // Outgoing messages
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as! OutgoingMessageCell
            cell.configure(with: message)
            return cell
        } else {
            // Incoming messages
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as! IncomingMessageCell
            cell.configure(with: message)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITextViewDelegate

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
        
        // Send typing notification
        presenter.sendTypingEvent(isTyping: !textView.text.isEmpty)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Сообщение..." {
            textView.text = ""
            textView.textColor = .label
        }
        presenter.sendTypingEvent(isTyping: !textView.text.isEmpty)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Сообщение..."
            textView.textColor = .placeholderText
        }
        presenter.sendTypingEvent(isTyping: false)
    }
}

// MARK: - UITextView+Placeholder

extension UITextView {
    var placeholder: String? {
        get {
            return nil
        }
        set {
            self.text = newValue
            self.textColor = .placeholderText
        }
    }
}
