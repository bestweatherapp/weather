//
//  PreferencesTableViewController.swift
//  READING
//
//  Created by Валентина on 10.05.18.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit

class PreferencesTableViewController: UITableViewController {
    var PreferencesBase = [String]()
    var selectedCity = ""
    var CityFromSearch = ""
    @IBOutlet var PreferencesTableView: UITableView!
    
    override func viewDidLoad() {
        if (UserDefaults.standard.array(forKey: "Cities") != nil)
        {  self.PreferencesBase = UserDefaults.standard.array(forKey: "Cities") as! [String]}
        if (self.CityFromSearch != "")
       {
        self.PreferencesBase.append(self.CityFromSearch)
         UpdatePreferences()
        }
        if (UserDefaults.standard.array(forKey: "Cities") != nil)
        {  self.PreferencesBase = UserDefaults.standard.array(forKey: "Cities") as! [String]}
        super.viewDidLoad()
        
    }

    @IBAction func GoToSearchButton(_ sender: Any) {
        performSegue(withIdentifier: "GoToSearch", sender: Any?.self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PreferencesBase.count
    }

    func UpdatePreferences ()
    {
        UserDefaults.standard.removeObject(forKey: "Cities")
        UserDefaults.standard.set(self.PreferencesBase, forKey: "Cities")
      
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PreferencesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       // cell.textLabel?.text = self.PreferencesBase[indexPath.row]
        cell.textLabel?.text = UserDefaults.standard.array(forKey: "Cities")?[indexPath.row] as! String
            return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ReturnToMain"){
            var transfData : ViewController =  (segue.destination as? ViewController)!
            transfData.citySelectedFromPreferences = self.selectedCity
        }
        if (segue.identifier == "GoToSearch")
        {
            var dataFromSearch : SearchingViewController =  (segue.destination as? SearchingViewController)!
            dataFromSearch.AllPreferences = self.PreferencesBase
        }
    }//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCity = (PreferencesTableView.cellForRow(at: indexPath)?.textLabel?.text!)!
        performSegue(withIdentifier: "ReturnToMain", sender: Any?.self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            self.PreferencesBase.remove(at: indexPath.row)
            PreferencesTableView.reloadData()
            UpdatePreferences()
            
        }
    }

}
