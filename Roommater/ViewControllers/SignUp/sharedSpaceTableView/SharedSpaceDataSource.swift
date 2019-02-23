//
//  SharedSpaceDataSource.swift
//  Roommater
//
//  Created by Greg Hughes on 1/23/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class SharedSpaceDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let testSpaces = [1, 2, 3, 5]

    var place: Place?
    var parentVC: AddHomeDetailsTableViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
        if let spaces = place?.spaces {
            return spaces.count + 2
        }
//
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath) as? SharedSpaceTableViewCell
        
//        if let spaces = place?.spaces {
//
//            if indexPath.row <= spaces.count - 1 {
//            cell?.delegate = parentVC
//            let space = place?.spaces?[indexPath.row]
//            cell?.space = space
//
//            return cell ?? UITableViewCell()
//            }
//        }
                return cell ?? UITableViewCell()
    }

    
}
