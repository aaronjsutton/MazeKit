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
	private static var step = 2

	private var current: MazePoint
	private var maze: Maze

	var visited: [MazePoint] = []
	var track: [MazePoint] = []
	private var directions: [Direction] = []

	internal enum Direction: UInt32, CaseIterable {
		case N = 0
		case E
		case S
		case W
	}

	internal init(_ maze: Maze, start point: MazePoint) {
		self.maze = maze
		self.current = point
	}

	internal func generate(_ point: MazePoint) throws {
		current = point
		visited.reserveCapacity(maze.spaces)
		track.reserveCapacity(maze.spaces)
		visited.append(point)
		track.append(point)
		maze[current] = .passable

		while visited.count < maze.spaces  {
			var selectedDirection = randomDirection()
			while directions.contains(selectedDirection) &&
				directions.count != Direction.allCases.count {
				selectedDirection = randomDirection()
			}
			let destination = current.offsetting(in: selectedDirection, by: Generator.step)
			let middle = destination.offsetting(in: selectedDirection, by: -1)
			let searched = [middle, destination]

			if canMove(point: current, in: selectedDirection) {
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
			visited += maze.inBounds(destination.row, destination.column) ? searched : []
		}
	}

	private func randomDirection() -> Direction {
		return Direction(rawValue: arc4random_uniform(4))!
	}

	private func canMove(point: MazePoint, in direction: Direction) -> Bool {
		let destination = point.offsetting(in: direction, by: Generator.step)
		guard maze.inBounds(destination.row, destination.column) else {
			return false
		}
		let ahead = maze[destination] != .passable &&
					 				maze[destination.offsetting(in: direction, by: -1)] != .passable
		return ahead

	}
}
