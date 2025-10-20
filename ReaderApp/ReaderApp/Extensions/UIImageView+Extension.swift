//
//  UIImageView+Extension.swift
//  ReaderApp
//
//  Created by Sambhav Oraon on 19/10/25.
//

import Foundation
import UIKit

//For caching
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(from urlString: String?, completion: ((UIImage?) -> Void)? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let key = urlString as NSString
        if let cached = imageCache.object(forKey: key) {
            self.image = cached
            completion?(cached)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _ , _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            imageCache.setObject(image, forKey: key)
            DispatchQueue.main.async {
                self.image = image
                completion?(image)
            }
        }.resume()
    }
}
