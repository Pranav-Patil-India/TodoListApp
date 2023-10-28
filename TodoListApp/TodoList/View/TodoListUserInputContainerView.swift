//
//  UserInputContainerView.swift
//  TodoListApp
//
//  Created by Pranav Patil on 27/10/23.
//

import UIKit

protocol TodoListUserInputContainerViewDelegate: NSObjectProtocol {

    func saveButtonTapped(inputText: String)

}

class TodoListUserInputContainerView: UIView {

    // MARK: - Constants

    private static let inputViewHorizontalPadding = 12.0
    private static let inputTextViewTextContainerInset = UIEdgeInsets(
        top: 12.0,
        left: inputViewHorizontalPadding,
        bottom: -12.0,
        right: inputViewHorizontalPadding)
    private static let inputTextViewTextHeight = 18.0

    // MARK: - Private properties

    private weak var delegate: TodoListUserInputContainerViewDelegate?

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Add to-do"
        label.textColor = UIColor.lightGray
        label.backgroundColor = .clear
        return label
    }()

    private lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        let configuration = UIImage.SymbolConfiguration(
            pointSize: 30,
            weight: .regular,
            scale: .medium)
        saveButton.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 30/2
        saveButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return saveButton
    }()

    lazy var inputTextView: UITextView = {
        let textview = UITextView()
        textview.isScrollEnabled = false
        textview.font = UIFont.systemFont(ofSize: Self.inputTextViewTextHeight)
        textview.textContainerInset = Self.inputTextViewTextContainerInset
        textview.backgroundColor = .clear
        textview.delegate = self
        return textview
    }()

    // MARK: - Inits

    init(delegate: TodoListUserInputContainerViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = UIColor.colorFromRGB(rgbValue: 0xF5F7F8)
        setupUserInputContainerView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public helper

    func resetInputView() {
        inputTextView.text = nil
        placeholderLabel.isHidden = false
    }

    // MARK: - Private methods

    private func setupUserInputContainerView() {
        // InputTextView
        addSubview(inputTextView)
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputTextView.topAnchor.constraint(equalTo: topAnchor),
            inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            inputTextView.heightAnchor.constraint(
                equalToConstant: Self.inputTextViewTextHeight + 2 * Self.inputTextViewTextContainerInset.top)
        ])

        // SaveButton
        addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: topAnchor),
            saveButton.leadingAnchor.constraint(equalTo: inputTextView.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            saveButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Self.inputViewHorizontalPadding)
        ])

        // PlaceholderLabel
        inputTextView.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(
                equalTo: inputTextView.topAnchor,
                constant: Self.inputTextViewTextContainerInset.top),
            placeholderLabel.leadingAnchor.constraint(
                equalTo: inputTextView.leadingAnchor,
                constant: Self.inputTextViewTextContainerInset.left+5),
            placeholderLabel.bottomAnchor.constraint(
                equalTo: inputTextView.bottomAnchor,
                constant: Self.inputTextViewTextContainerInset.bottom),
            placeholderLabel.trailingAnchor.constraint(
                equalTo: inputTextView.trailingAnchor,
                constant: Self.inputTextViewTextContainerInset.right)
        ])
    }

    @objc private func addButtonTapped() {
        if let inputText = inputTextView.text, !inputText.isEmpty {
            delegate?.saveButtonTapped(inputText: inputText)
        }
    }

}

// MARK: - UITextViewDelegate

extension TodoListUserInputContainerView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

}
