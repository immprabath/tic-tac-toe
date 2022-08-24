//
//  Move.swift
//  SampleApp
//
//  Created by Madusanka Prabath on 2022-08-23.
//

import Foundation

enum Player {
	case human, computer
}

struct Move {
	let player:Player
	let movedIndex: Int
	
	var indecator:String {
		return player == Player.human ? "xmark" : "circle"
	}
}
