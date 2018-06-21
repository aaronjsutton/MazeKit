//
//  MazePoint.swift
//  MazeKit
//
//  Created by Aaron Sutton on 6/21/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import Foundation

/// A structure that represents a point on the maze grid.
public struct MazePoint {
	/// X coordinate
	public var row: Int
	/// Y coordinate
	public var column: Int

	/// Returns a point offset from this point.
	///
	/// - Parameters:
	///   - direction: The direction to offset in.
	///   - amount: Number of points to offset by.
	/// - Returns: The new point.
	func offsetting(in direction: Generator.Direction, by amount: Int) -> MazePoint {
		switch direction {
		case .N:
			return MazePoint(row: self.row - amount, column: self.column)
		case .S:
			return MazePoint(row: self.row + amount, column: self.column)
		case .E:
			return MazePoint(row: self.row, column: self.column + amount)
		case .W:
			return MazePoint(row: self.row, column: self.column - amount)
		}
	}

	/// Offsets the point in-place.
	///
	/// - Parameters:
	///   - direction: The direction to offset in.
	///   - amount: The amount of points to offset by.
	mutating func offset(in direction: Generator.Direction, by amount: Int) {
		switch direction {
		case .N:
			self.row -= amount
		case .S:
			self.row += amount
		case .E:
			self.column += amount
		case .W:
			self.column -= amount
		}
	}
}
