//
//  Generator.swift
//  MazeKit
//
//  Created by Aaron Sutton on 6/19/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import UIKit

/// Errors pertaining to the generation of
///
/// - lowMemory: Generation was cancelled due to a low memory warning from the
///							 system.
internal enum GenerationError: Error {
	case lowMemory
}

/// An internal class the implements stack based generation.
internal class Generator {

	/// The step size of the generator. Internal use only.
	static var step = 2

	private var current: MazePoint

	//	var visited: [MazePoint] = []
	var track: [MazePoint] = []
	private var directions: [Direction] = []

	internal enum Direction: CaseIterable {

		/// Generates a random direction.
		///
		/// - Parameter directions: Exclude this set from the directions.
		/// - Returns: Returns nil if `directions` is equal to pr
		static func random(exclude directions: [Direction]) -> Direction? {
			guard directions.count < Direction.allCases.count else {
				return nil
			}
			var result: Direction
			repeat {
				// Force unwrap because we know allCases will never be empty.
				result = Direction.allCases.randomElement()!
			} while directions.contains(result)
			return result
		}

		case N
		case E
		case S
		case W
	}

	internal init(start point: MazePoint) {
		self.current = point
	}

	internal func generate(_ point: MazePoint, _ maze: inout Maze) throws {
		current = point
		track.reserveCapacity(maze.spaces)
		track.append(point)
		maze[current] = .passable

		// Refactor the hell out of this :]
		while track.count > 0  {
			guard let selected = Direction.random(exclude: directions) else {
				directions = []
				current = track.last!
				track.removeLast()
				continue
			}

			let destination = current.offsetting(in: selected, by: Generator.step)
			let middle = destination.offsetting(in: selected, by: -1)
			let searched = [middle, destination]

			if maze.canMove(point: current, in: selected) {
				maze[destination] = .passable
				maze[middle] = .passable
				track += searched
				current = destination
				directions = []
			} else {
				directions += [selected]
			}
		}
	}

	static func oppositeDirections(in direction: Direction) -> (Direction, Direction) {
		switch direction {
		case .N, .S:
			return (.E, .W)
		case .E, .W:
			return (.N, .S)
		}
	}

}
