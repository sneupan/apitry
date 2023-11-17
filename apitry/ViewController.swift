//
//  ViewController.swift
//  apitry
//
//  Created by Saskriti Neupane  on 11/16/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var activities = [ActivityData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadData()
    }

    func loadData() {
        guard let url = URL(string: "YOUR_API_ENDPOINT") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Invalid HTTP response")
                return
            }

            guard let jsonData = data else {
                print("Error: No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                let activitiesData = try decoder.decode([ActivityData].self, from: jsonData)
                DispatchQueue.main.async {
                    self?.activities = activitiesData
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let activity = activities[indexPath.row]
        cell.textLabel?.text = activity.activityOffering.name
        return cell
    }
}
