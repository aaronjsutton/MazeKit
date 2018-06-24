//
//  Maze.swift
//  MazeKit
//
//  Created by Aaron Sutton on 6/18/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

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

	/// The number of columns in the maze grid.
	public var columns: Int
	
	/// The number of rows in the maze grid.
	public var rows: Int

	/// The starting point of the maze.
	public var start: MazePoint

	/// The endpoint of the maze. Nil if the maze
	/// has not been generated.
	public var end: MazePoint?

	/// The total number of spaces in the maze.
	public var spaces: Int {
		return rows * columns
	}

	/// The generator object responsible for generating the maze.
	private var generator: Generator

	/// Representation of a maze's spaces.
	private var grid: [[Space]]
	
	/// Create a new maze, ungenerated.
	///
	/// - Parameters:
	///   - rows: Number of rows in the maze.
	///   - columns: Number of columns in the maze.
	///		- point: The starting point of the maze. Defaults to (0,0).
	///
	/// - Warning: Both `rows` and `columns` must be odd. If
	/// 					 the values passed in are even, they will be incremented.
	public init(width columns: Int,
							height rows: Int,
							start point: MazePoint = MazePoint.zero) {
		self.rows = rows % 2 != 0 ? rows : rows + 1
		self.columns = columns % 2 != 0 ? columns : columns + 1
		self.start = point
		self.grid = [[Space]](repeating: [Space](repeating: .impassable, count: self.columns),
													count: self.rows)
		self.generator = Generator(start)
	}
	
	/// Generates a maze in-place.
	public mutating func generate() {
		generator.generate(&self)
	}

	/// Reset a maze to inital values.
	/// The maze will not be generated.
	///
	/// - Parameters:
	///   - point: A new starting point. Optional.
	///   - regenerate: Indicates if the maze should be regenerated. Defaults to false.
	public mutating func reset(to point: MazePoint? = nil,
														 regenerate: Bool = false) {
		generator.reset(to: (point != nil ? point! : start))
		grid = [[Space]](repeating: [Space](repeating: .impassable, count: columns),
										 count: self.rows)
		if regenerate { generate() }
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
	
	/// Returns the value of a space.
	///
	/// - Parameter row: The row index.
	public subscript(row: Int, column: Int) -> Space {
		assert(contains(row, column), "Index out of bounds")
		return grid[row][column]
	}
	
	/// Get/set subscript used by the Generator class.
	///
	/// - Parameter point: Space that can be read/written.
	internal subscript(point: MazePoint) -> Space {
		get {
			return self[point.row, point.column]
		}
		set {
			self.grid[point.row][point.column] = newValue
		}
	}

	/// Determines if a point is within the bounds of the maze.
	///
	/// - Parameters:
	///   - row: Row of the point.
	///   - column: Column of the point
	internal func contains(_ row: Int, _ column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}

	/// Determines if a point is within the bounds of the maze.
	///
	/// - Parameter point: The point to check.
	/// - Returns: True if in bounds, false if not.
	internal func contains(_ point: MazePoint) -> Bool {
		let row = point.row
		let column = point.column
		return contains(row, column)
	}

	/// Determines if a path can be constructed in a certain direction.
	/// If a path can be constructed, `constructor` is called, passing in
	/// the information about the points to be constructed.
	///
	/// This function favors an exit-early approach,
	/// reducing uneeded computation.
	///
	/// - Parameters:
	///   - base: The base point of the construction.
	///   - direction: The direction to construct in.
	///   - constructor: Passed `nil` if the construction was invalid.
	internal func construct(from base: MazePoint,
													in direction: Direction,
													_ constructor: (Generator.Construction?) -> ()) {
		/// The path used in a maze construction.
		var construction: Generator.Construction? = nil

		defer {
			constructor(construction)
		}

		/// The destination point.
		let destination = base.offsetting(in: direction,
																			by: Generator.step)
		guard self.contains(destination) &&
					self[destination] == .impassable
		else {
				return
		}

		/// The point between `destination` and `base`
		let pathway = destination.offsetting(in: direction, by: -1)
		guard self[pathway] != .passable else {
			return
		}

		/// Points to either side of `base`
		var surrounding = [MazePoint]()
		direction.perpendiculars.forEach { direction in
			surrounding.append(base.offsetting(in: direction, by: 1))
		}
		for _ in 1...Generator.step {
			surrounding += surrounding.map { point in
				point.offsetting(in: direction, by: 1)
			}
		}
		surrounding.removeFirst(2)

		// Validate surrounding.
		var valid = true
		for point in surrounding where self.contains(point) {
			valid = valid && self[point] != .passable
		}
		guard valid else {
			return
		}

		// Create the construction.
		construction = Generator.Construction(destination: destination,
																					pathway: pathway)
	}
}

// MARK: - CustomStringConvertible
extension Maze: CustomStringConvertible {
	/// Prints the maze data using Unicode box drawing characters.
	/// Suitable for debugging purposes.
	public var description: String {
		let border = String(repeatElement("━", count: columns * 2))
		var box = "┏\(border)┓\n"
		
		for row in grid {
			box += "┃"
			for space in row {
				box += space == .passable ? "00" : "██"
			}
			box += ("┃\n")
		}
		
		box += "┗\(border)┛\n"
		return box
	}
}
