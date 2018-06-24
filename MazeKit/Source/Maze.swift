//
//  Maze.swift
//  MazeKit
//
//  Created by Aaron Sutton on 6/18/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import Foundation

/// A structure that represents the underlying data for a grid based maze.
///
///	In the coordinate space of a maze. The *origin* (0, 0)
///	is located at the top-right corner of a maze.
public struct Maze {
	
	/// Represents the two states of a maze space.
	///
	/// - passable: The space can be passed through in the game world (path).
	/// - impassable: The space cannot be passed through (wall).
	public enum Space {
		case passable
		case impassable
	}
	
	/// True if the maze has undergone generation.
	public var isGenerated: Bool = false
	/// The number of columns in the maze grid.
	public var columns: Int
	/// The number of rows in the maze grid.
	public var rows: Int
	
	/// The total number of spaces in the maze.
	public var spaces: Int {
		return rows * columns
	}
	
	internal var grid: [[Space]]
	
	/// Create a new maze, ungenerated.
	///
	/// - Parameters:
	///   - rows: Number of rows in the maze.
	///   - columns: Number of columns in the maze.
	///
	/// - Warning: Both `rows` and `columns` must be odd. If
	/// 					 the values passed in are even, they will be incremented.
	public init(width columns: Int, height rows: Int) {
		self.rows = rows % 2 != 0 ? rows : rows + 1
		self.columns = columns % 2 != 0 ? columns : columns + 1
		self.grid = Array(repeating: Array(repeating: .impassable,
																			 count: self.columns),
											count: self.rows)
	}
	
	/// Generates a maze in-place.
	public mutating func generate(start point: MazePoint) {
		let generator = Generator(start: point)
		generator.generate(point, &self)
	}
	
	/// Returns a generated copy of this maze.
	///
	/// - Returns: The generated maze.
	//	public func generated(start: (Int, Int)) throws -> Maze {
	//		let point = Point(row: start.0, column: start.1)
	//		var copy = Maze(width: columns, height: rows)
	//		try Generator.generate(maze: &copy, point)
	//		return copy
	//	}
	
	/// Returns the value of a
	///
	/// - Parameter row: The row index.
	public subscript(row: Int, column: Int) -> Space {
		assert(inBounds(row, column), "Index out of bounds")
		return grid[row][column]
	}
	
	internal subscript(point: MazePoint) -> Space {
		get {
			return self[point.row, point.column]
		}
		set {
			self.grid[point.row][point.column] = newValue
		}
	}
	
	private subscript(row: Int) -> [Space] {
		assert(inBounds(row, 0), "Index out of bounds")
		return grid[row]
	}
	
	/// Determines if a point is within the bounds of the maze.
	///
	/// - Parameters:
	///   - row: Row of the point.
	///   - column: Column of the point
	/// - Returns: True if in bounds, false if not.
	internal func inBounds(_ row: Int, _ column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}

	// TODO: Refactor
	func canMove(point: MazePoint, in direction: Direction) -> Bool {
		var destination = point.offsetting(in: direction, by: Generator.step)
		guard inBounds(destination.row, destination.column) else {
			return false
		}
		var ahead = self[destination] != .passable &&
			self[destination.offsetting(in: direction, by: -1)] != .passable
		destination.offset(in: direction, by: 1)
		if inBounds(destination.row, destination.column) {
			ahead = ahead && self[destination] == .impassable
		}
		var walls: [MazePoint] = []
		for direction in direction.perpendiculars {
			walls += [point.offsetting(in: direction, by: 1)]
		}
		var wallsClear: Bool = true
		for point in walls where inBounds(point.row, point.column) {
			wallsClear = wallsClear && self[point.offsetting(in: direction, by: 1)] == .impassable &&
									self[point.offsetting(in: direction, by: 2)] == .impassable
		}
		return ahead && wallsClear
	}
}

// MARK: - CustomStringConvertible
extension Maze: CustomStringConvertible {
	/// Prints the maze data using Unicode box drawing characters.
	/// Suitable for debugging purposes.
	public var description: String {
		let border = String(repeatElement("━", count: columns * 2))
		var box = "┏\(border)┓\n"
		
		for row in 0...rows - 1 {
			box += "┃"
			for space in self[row] {
				box += space == .passable ? "00" : "██"
			}
			box += ("┃\n")
		}
		
		box += "┗\(border)┛\n"
		return box
	}
}