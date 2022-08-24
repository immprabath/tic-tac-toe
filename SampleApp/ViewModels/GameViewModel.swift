//
//  GameViewModel.swift
//  SampleApp
//
//  Created by iMP on 2022-08-23.
//

import SwiftUI

final class GameViewModel:ObservableObject {
	
	let winMoves:Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
	
	let columns:[GridItem] = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),]
	
	@Published var moves:[Move?] = Array(repeating: nil, count: 9)
	@Published var isBoardDisabled = false
	@Published var alertItem:AlertItem?
	
	
	func processTapAction(for position:Int)  {
		
		if isCircleOccupied(in: moves, forIndex: position) {return}
		
		moves[position] = Move(player: .human, movedIndex: position)
		isBoardDisabled.toggle()
		
		if checkWinPattern(for: .human, in: moves) {
			alertItem = AlertContext.humanWin
			return
		}
		
		if checkDrawPattern(in: moves) {
			alertItem = AlertContext.draw
			return
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
			let computerMoveIndex = determineComputerMovePosition(in: moves)
			
			if (computerMoveIndex != -1) {
				moves[computerMoveIndex] = Move(player: .computer, movedIndex: computerMoveIndex)
				
			}
			
			if checkWinPattern(for: .computer, in: moves) {
				alertItem = AlertContext.computerWin
				return
			}
			
			if checkDrawPattern(in: moves) {
				alertItem = AlertContext.draw
				return
			}
			isBoardDisabled.toggle()
		}
	}
	
	func isCircleOccupied(in move:[Move?], forIndex index:Int) -> Bool {
		return moves.contains {
			$0?.movedIndex == index
		}
	}
	
	func determineComputerMovePosition(in moves:[Move?]) -> Int {
		
		// if can win then win
		let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
		let computerPositions = Set(computerMoves.map{ $0.movedIndex })
		
		for pattern in winMoves {
			let nextMovePosition = pattern.subtracting(computerPositions)
			
			if nextMovePosition.count == 1 {
				let isCircleAvailable = isCircleOccupied(in: moves, forIndex: nextMovePosition.first!)
				if !isCircleAvailable {
					return nextMovePosition.first!
				}
			}
		}
		
		
		// if cannot win then block
		let playerMoves = moves.compactMap { $0 }.filter { $0.player == .human }
		let playerPositions = Set(playerMoves.map{ $0.movedIndex })
		
		for pattern in winMoves {
			let nextMovePosition = pattern.subtracting(playerPositions)
			
			if nextMovePosition.count == 1 {
				let isCircleAvailable = isCircleOccupied(in: moves, forIndex: nextMovePosition.first!)
				if !isCircleAvailable {
					return nextMovePosition.first!
				}
			}
		}
		
		// if cannot block take middle
		let middleCircle = 4
		
		if !isCircleOccupied(in: moves, forIndex: middleCircle) {
			return middleCircle
		}
		
		// if cannot take middle squre guess a available number
		
		var randomInt = Int.random(in: 0..<9)
		if moves.filter({ $0 == nil}).count > 0 {
			while isCircleOccupied(in: moves, forIndex: randomInt) {
				randomInt = Int.random(in: 0..<9)
			}
			return randomInt
		}
		return -1;
	}
	
	func checkWinPattern(for player:Player, in moves:[Move?]) -> Bool {
		let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
		let playerPositions = Set(playerMoves.map{ $0.movedIndex })
		
		for pattern in winMoves where pattern.isSubset(of: playerPositions) {
			return true
		}
		return false
	}
	
	func checkDrawPattern(in moves: [Move?]) -> Bool {
		if moves.compactMap({ $0 }).count == 9 {
			return true
		}
		return false
	}
	
	func reset() -> Void {
		moves = Array(repeating: nil, count: 9)
		isBoardDisabled.toggle()
	}
}
