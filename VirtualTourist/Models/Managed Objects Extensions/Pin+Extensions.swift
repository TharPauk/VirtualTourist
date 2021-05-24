//
//  Pin+Extensions.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 24/05/2021.
//

import Foundation
import CoreData

extension Pin {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
}
