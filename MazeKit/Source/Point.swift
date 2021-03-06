//
//  Point.swift
//  MazeKit
//
//  Created by Aaron Sutton on 6/21/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

/// A structure that represents a point on the maze grid.
public struct Point: Hashable {

	/// A point at the top-left corner of any maze.
	public static var zero: Point {
		return Point(row: 0, column: 0)
	}

	/// The row (X-value) of the point.
	public var row: Int
	/// The column (Y-value) of the point.
	public var column: Int

	/// Returns a point offset from this point.
	///
	/// - Parameters:
	///   - direction: The direction to offset in.
	///   - amount: Number of points to offset by.
	/// - Returns: The new point.
	func offsetting(in direction: Direction, by amount: Int) -> Point {
		switch direction {
		case .N:
			return Point(row: self.row - amount, column: self.column)
		case .S:
			return Point(row: self.row + amount, column: self.column)
		case .E:
			return Point(row: self.row, column: self.column + amount)
		case .W:
			return Point(row: self.row, column: self.column - amount)
		}
	}

	/// Offsets the point in-place.
	///
	/// - Parameters:
	///   - direction: The direction to offset in.
	///   - amount: The amount of points to offset by.
	mutating func offset(in direction: Direction, by amount: Int) {
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
