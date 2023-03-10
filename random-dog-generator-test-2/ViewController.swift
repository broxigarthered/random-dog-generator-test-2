//
//  ViewController.swift
//  random-dog-generator-test-2
//
//  Created by Nikolay N. Dutskinov on 9.03.23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var numberTextField: UITextField! {
        didSet {
            numberTextField.keyboardType = .numberPad
            numberTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)

        }
    }
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.textColor = .systemRed
            errorLabel.text = "The number should be in range of 1 to 10"
            errorLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    var viewModel: DogGeneratorInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service: DogsImagesService = APIManager()
        viewModel = DogsImagesGenerator(dogService: service)
        viewModel?.output = self
    }

    @IBAction func didTapOnSubmit(_ sender: UIButton) {
        guard let number = Int(numberTextField.text ?? "") else { return }
        viewModel?.getImages(number: number)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateInput(text: textField.text ?? "")
    }
    
    private func validateInput(text: String) {
        if let number = Int(text) {
            guard number > 0 && number <= 10 else { setInvalidState()
                return }
            setValidState()
        } else {
            setInvalidState()
        }
    }
    
    private func setInvalidState() {
        errorLabel.isHidden = false
        submitButton.isEnabled = false
    }
    
    private func setValidState() {
        errorLabel.isHidden = true
        submitButton.isEnabled = true
    }
}

extension ViewController: DogGeneratorOutput {
    func didFetchRandomImage(image: UIImage) {
        self.dogImageView.image = image
    }
}

//extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//}
