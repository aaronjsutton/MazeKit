//
//  Generator.swift
//  MazeKit
//
//  Created by Aaron Sutton on 6/19/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import UIKit

/// An internal class the implements stack based generation.
internal class Generator {

	/// The step size of the generator. Internal use only.
	static var step = 2

	/// The currently selected point
	private var current: MazePoint

	//	var visited: [MazePoint] = []
	var track: [MazePoint] = []
	/// Directions that have been searched.
	private var directions: Set<Direction> = []

	internal init(_ point: MazePoint) {
		self.current = point
		track.append(current)
	}

	/// Generate a maze.
	///
	/// - Parameters:
	///   - point: The point at which generation will begin.
	///   - maze: The maze object to generate
	internal func generate(_ maze: inout Maze) {
		track.reserveCapacity(maze.spaces)
		maze[current] = .passable

		while track.count > 0  {
			/// The direction to search. If every direction has been exhausted,
			/// unwind the stack and retry.
			guard let direction = Direction.random(exclude: directions) else {
				directions.removeAll()
				current = track.removeLast()
				continue
			}

			/// The point that could be moved to.
			let destination = current.offsetting(in: direction, by: Generator.step)
			/// The space between the current point and the destination.
			let pathway = destination.offsetting(in: direction, by: -1)
			/// An array of the two cells searched.
			let searched = [pathway, destination]

			if maze.canMove(point: current, in: direction) {
				maze[destination] = .passable
				maze[pathway] = .passable
				track += searched
				current = destination
				directions.removeAll()
			} else {
				directions.insert(direction)
			}
		}
	}
}
