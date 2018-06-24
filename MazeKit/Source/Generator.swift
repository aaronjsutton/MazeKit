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
	private var directions: Set<Direction> = []

	internal init(start point: MazePoint) {
		self.current = point
	}

	/// Generate a maze.
	///
	/// - Parameters:
	///   - point: The point at which generation will begin.
	///   - maze: The maze object to generate
	internal func generate(_ point: MazePoint, _ maze: inout Maze) {
		current = point
		track.reserveCapacity(maze.spaces)
		track.append(point)
		maze[current] = .passable

		while track.count > 0  {
			guard let direction = Direction.random(exclude: directions) else {
				directions = []
				current = track.last!
				track.removeLast()
				continue
			}

			let destination = current.offsetting(in: direction, by: Generator.step)
			let middle = destination.offsetting(in: direction, by: -1)
			let searched = [middle, destination]

			if maze.canMove(point: current, in: direction) {
				maze[destination] = .passable
				maze[middle] = .passable
				track += searched
				current = destination
				directions = []
			} else {
				directions.insert(direction)
			}
		}
	}


}
