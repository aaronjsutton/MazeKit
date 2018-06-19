//
//  Maze.swift
//  DFSKit
//
//  Created by Aaron Sutton on 6/18/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import Foundation

/// A structure that represents the underlying data for a grid based maze.
public struct Maze {

	/// Represents the two states of a maze space.
	///
	/// - passable: The space can be passed through in the game world (path).
	/// - impassable: The space cannot be passed through (wall).
	public enum Space {
		case passable
		case impassable
	}

	/// The number of rows in the maze grid
	public var rows: Int
	/// The number of columns in the maze grid
	public var columns: Int
	private var grid: [[Space]]

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
																			 count: columns),
											count: rows)
	}

	/// Returns a row of spaces. This allows for
	/// double bracket style subscript syntax.
	///
	/// - Parameter row: The row index.
	public subscript(row: Int, column: Int) -> Space {
		assert(inBounds(row, column), "Index out of bounds")
		return grid[row][column]
	}

	private subscript(row: Int) -> [Space] {
		assert(inBounds(row, 0), "Index out of bounds")
		return grid[row]
	}

	private func inBounds(_ row: Int, _ column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}

}

// MARK: - CustomStringConvertible
extension Maze: CustomStringConvertible {
	/// Prints the maze data using Unicode box drawing characters
	public var description: String {
		let border = String(repeatElement("━", count: columns * 2))
		var box = "┏\(border)┓\n"

		for row in 0...rows - 1 {
			box += "┃"
			for space in self[row] {
				box += space == .passable ? "  " : "██"
			}
			box += ("┃\n")
		}

		box += "┗\(border)┛\n"
		return box
	}
}
