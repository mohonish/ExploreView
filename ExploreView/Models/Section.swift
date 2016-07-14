//
//  Section.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 15/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import Foundation

public class Section {
    
    var sectionIndex: Int!
    var sectionTitle: String!
    var active: Bool!
    
    init(index: Int, title: String, active: Bool) {
        self.sectionIndex = index
        self.sectionTitle = title
        self.active = active
    }
    
}