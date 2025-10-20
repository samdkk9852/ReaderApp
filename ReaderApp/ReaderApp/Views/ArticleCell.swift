//
//  ArticleCell.swift
//  ReaderApp
//
//  Created by Sambhav Oraon on 20/10/25.
//

import Foundation
import UIKit

class ArticleCell: UITableViewCell {
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let bookmarkButton = UIButton(type: .system)
    private var bookmarkAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnailImageView)
        
        titleLabel.numberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        authorLabel.numberOfLines = 1
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = .secondaryLabel
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(authorLabel)
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bookmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 44),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            objc_setAssociatedObject(self, "bookmarkAction", nil, .OBJC_ASSOCIATION_RETAIN)
//            bookmarkButton.removeTarget(self, action: #selector(didTapBookmark), for: .touchUpInside)
        }
    
    func configure(with article: Article, isBookmarked: Bool, bookmarkAction: @escaping () -> Void) {
        titleLabel.text = article.title
        authorLabel.text = article.author ?? "Unknown"
        thumbnailImageView.loadImage(from: article.urlToImage)
        bookmarkButton.setImage(UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark"), for: .normal)
        bookmarkButton.addTarget(self, action: #selector(didTapBookmark), for: .touchUpInside)
        //Use obj_setAssociatedObject
//        objc_setAssociatedObject(self, "bookmarkAction", bookmarkAction, .OBJC_ASSOCIATION_RETAIN)
        self.bookmarkAction = bookmarkAction
    }
    
//    @objc private func didTapBookmark() {
//        print("Bookmark button tapped")
//        if let action = objc_getAssociatedObject(self, "bookmarkAction") as? () -> Void {
//            print("Bookmark toogle performed")
//            action()
//        } else {
//            print("Failed to retrieve bookmark action")
//        }
//    }
    
    @objc private func didTapBookmark() {
        print("Bookmark button tapped")
        if let action = bookmarkAction {
            print("Bookmark toggle performed")
            action()
        }
    }
}

