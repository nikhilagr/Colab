//
//  Note.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/11/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation

class Note{
    // can be read from outside, but cant't be written
    private(set) var note_id: String!
    private(set) var user_id: String!
    private(set) var note_desc: String!
    private(set) var note_title: String!
    
    
    init(noteId: String, userId: String, noteDesc: String, noteTitle: String) {
        self.note_id = noteId
        self.user_id = userId
        self.note_desc = noteDesc
        self.note_title = noteTitle
    }

    
}
