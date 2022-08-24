//
//  GameView.swift
//  SampleApp
//
//  Created by iMP on 2022-08-21.
//

import SwiftUI

struct GameView: View {
	
	@StateObject private var viewModel:GameViewModel = GameViewModel()
	
	var body: some View {
		GeometryReader { geometry in
			VStack {
				Spacer()
				VStack {
					LazyVGrid(columns: viewModel.columns, spacing: 5) {
						ForEach(0..<9) { i in
							ZStack {
								Circle()
									.foregroundColor(.red).opacity(0.8)
									.frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15)
								
								Image(systemName:viewModel.moves[i]?.indecator ?? "")
									.resizable()
									.frame(width: 40, height: 40)
									.foregroundColor(.white)
							}
							.onTapGesture {
								viewModel.processTapAction(for: i)
							}
						}
					}
				}
				Spacer()
			}
			.background(.black)
			.disabled(viewModel.isBoardDisabled)
			.padding()
			.alert(item: $viewModel.alertItem, content: { item in
				Alert(title: item.title, message: item.message, dismissButton: .default(item.buttonTitle, action: {
					viewModel.reset()
				}))
			})
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			GameView()
		}
	}
}
