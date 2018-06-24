//
//  Generator.swift
//  MazeKit
//
//  Created by Aaron Sutton on 6/19/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//


/// An internal class the implements stack based generation.
internal class Generator {

	/// Represents a `destination` point that is two units away from the
	/// current, where `pathway` is between them.
	struct Construction {
		var destination: MazePoint
		var pathway: MazePoint
		var searched: [MazePoint] {
			return [pathway, destination]
		}
	}

	/// The step size of the generator. Internal use only.
	static var step = 2

	/// The currently selected point
	private var current: MazePoint

	/// The generator's tracking stack.
	private var track: [MazePoint] = []

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

		while !track.isEmpty  {
			/// The direction to search. If every direction has been exhausted,
			/// unwind the stack and retry.
			guard let direction = Direction.random(exclude: directions) else {
				current = track.popLast()!
				directions.removeAll()
				continue
			}

			maze.construct(from: current, in: direction) { result in
				// Validate that the direction is valid.
				guard let construction = result else {
					directions.insert(direction)
 					return
				}
				// Create the path.
				maze[construction.destination] = .passable
				maze[construction.pathway] = .passable
				track += construction.searched
				current = construction.destination
				directions.removeAll()
			}
		}
	}

	/// Reset the generator.
	///
	/// - Parameter point: The starting point.
	internal func reset(to point: MazePoint) {
		current = point
		track.append(point)
	}

}
