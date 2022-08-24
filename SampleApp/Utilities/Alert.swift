//
//  Alert.swift
//  SampleApp
//
//  Created by iMP on 2022-08-23.
//

import SwiftUI

struct AlertItem:Identifiable {
	let id = UUID()
	var title: Text
	var message: Text
	var buttonTitle: Text
}


struct AlertContext {
	static let humanWin = AlertItem(title: Text("You Win!"),
									message: Text("You are amazing"),
									buttonTitle: Text("Win again"))
	
	static let computerWin = AlertItem(title: Text("AI Wins!"),
									   message: Text("AI is better than you this time"),
									   buttonTitle: Text("Hard luck"))
	
	static let draw = AlertItem(title: Text("Draw!"),
								message: Text("What a battle"),
								buttonTitle: Text("Try again"))
}
