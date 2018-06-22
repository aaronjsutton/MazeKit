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

	internal enum Direction: UInt32, CaseIterable {
		case N = 0
		case E
		case S
		case W
	}

	internal init(start point: MazePoint) {
		self.current = point
	}

	internal func generate(_ point: MazePoint, _ maze: inout Maze) throws {
		current = point
		// Don't need this stack after all.
//		visited.reserveCapacity(maze.spaces)
		track.reserveCapacity(maze.spaces)
//		visited.append(point)
		track.append(point)
		maze[current] = .passable

		// Refactor the hell out of this :]
		while track.count > 0  {
			var selectedDirection = randomDirection()
			while directions.contains(selectedDirection) &&
				directions.count != Direction.allCases.count {
				selectedDirection = randomDirection()
			}
			let destination = current.offsetting(in: selectedDirection, by: Generator.step)
			let middle = destination.offsetting(in: selectedDirection, by: -1)
			let searched = [middle, destination]

			if maze.canMove(point: current, in: selectedDirection) {
				maze[destination] = .passable
				maze[middle] = .passable
				track += searched
				current = destination
				directions = []
			} else if directions.count == Direction.allCases.count {
				current = track.last!
				track.removeLast()
				directions = []
			} else {
				directions += [selectedDirection]
			}
		}
	}

	/// Generates a random direction.
	///
	/// - Returns: A direction.
	private func randomDirection() -> Direction {
		return Direction(rawValue: UInt32.random(in: 0...3))!
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
