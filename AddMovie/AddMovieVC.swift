//
//  ViewController.swift
//  AddMovie
//
//  Created by Denis Polishchuk on 31.08.2022.
//

import UIKit

class AddMovieVC: UIViewController {
    var textFieldNameMovie: UITextField!
    var textFieldYearMovie: UITextField!
    var buttonAddMovie: UIButton!
    var tableViewAllMovie: UITableView!
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.createTextField()
        self.createButtonAddMovie()
        self.createTableViewAllMovie()
        self.movies = CoreDataManager.shared.getMovie()
        self.tableViewAllMovie.reloadData()
    }
    
    private func createModelTextField(positionY: CGFloat, textPlaceholder: String) -> UITextField {
        let textField = UITextField()
        textField.frame.size.width = UIScreen.main.bounds.width * 0.93
        textField.frame.size.height = UIScreen.main.bounds.height * 0.06
        textField.center.x = self.view.center.x
        textField.frame.origin.y = positionY
        textField.layer.cornerRadius = textField.frame.height * 0.2
        textField.layer.borderWidth = 2.5
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: textField.frame.height / 4, height: 0))
        textField.leftViewMode = .always
        textField.placeholder = textPlaceholder
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.text = ""
        self.view.addSubview(textField)
        return textField
    }
    
    private func createTextField() {
        self.textFieldNameMovie = self.createModelTextField(positionY: UIScreen.main.bounds.width * 0.15, textPlaceholder: "Title")
        
        self.textFieldYearMovie = self.createModelTextField(positionY: self.textFieldNameMovie.frame.origin.y + self.textFieldNameMovie.frame.size.height * 1.2, textPlaceholder: "Year")
        self.textFieldYearMovie.autocapitalizationType = .none
    }
    
    private func createButtonAddMovie() {
        self.buttonAddMovie = UIButton()
        self.buttonAddMovie.frame.size.width = UIScreen.main.bounds.width * 0.22
        self.buttonAddMovie.frame.size.height = UIScreen.main.bounds.width * 0.13
        self.buttonAddMovie.center.x = UIScreen.main.bounds.width / 2
        self.buttonAddMovie.frame.origin.y = self.textFieldYearMovie.frame.origin.y + self.textFieldYearMovie.frame.height * 1.2
        self.buttonAddMovie.backgroundColor = .systemBlue
        self.buttonAddMovie.layer.cornerRadius = self.buttonAddMovie.frame.height / 5
        self.buttonAddMovie.setTitle("Add", for: .normal)
        self.buttonAddMovie.titleLabel!.font = UIFont.systemFont(ofSize: 26)
        self.view.addSubview(self.buttonAddMovie)
        self.buttonAddMovie.addTarget(self, action: #selector(addMovie), for: .touchUpInside)
    }
    
    @objc private func addMovie() {
        if CoreDataManager.shared.isReapeted(name: self.textFieldNameMovie.text!, year: self.textFieldYearMovie.text!) == true {
            
            let alert = UIAlertController(title: "Attention", message: "Repeating element", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        let movie = CoreDataManager.shared.createMovie()
        movie.name = self.textFieldNameMovie.text
        movie.year = self.textFieldYearMovie.text
        CoreDataManager.shared.saveContext()
        self.textFieldNameMovie.text = ""
        self.textFieldYearMovie.text = ""
        
        self.movies = CoreDataManager.shared.getMovie()
        let indexPath = IndexPath(row: self.movies.count - 1, section: 0)
        self.tableViewAllMovie.insertRows(at: [indexPath], with: .bottom)
    }
    
    private func createTableViewAllMovie() {
        self.tableViewAllMovie = UITableView()
        self.tableViewAllMovie.frame.size.width = UIScreen.main.bounds.width * 0.93
        self.tableViewAllMovie.frame.size.height = UIScreen.main.bounds.height - self.buttonAddMovie.frame.origin.y - self.buttonAddMovie.frame.height - self.textFieldNameMovie.frame.size.height * 0.2
        self.tableViewAllMovie.center.x = UIScreen.main.bounds.width / 2
        self.tableViewAllMovie.frame.origin.y = self.buttonAddMovie.frame.origin.y + self.buttonAddMovie.frame.height + self.textFieldNameMovie.frame.size.height * 0.2
        self.view.addSubview(self.tableViewAllMovie)
        self.tableViewAllMovie.dataSource = self
        self.tableViewAllMovie.delegate = self
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate -
extension AddMovieVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idCell = "v"
        var cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? LabelCell
        if cell == nil {
            cell = LabelCell.init(style: .default, reuseIdentifier: idCell)
        }
        let movie = self.movies[indexPath.row]
        cell?.label.text = "\(movie.name!) \(movie.year!)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LabelCell.heightLabelCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let movie = self.movies.remove(at: indexPath.row)
        CoreDataManager.shared.delete(movie: movie)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}
