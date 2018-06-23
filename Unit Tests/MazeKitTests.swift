//
//  DFSKitTests.swift
//  DFSKitTests
//
//  Created by Aaron Sutton on 6/18/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import XCTest
@testable import MazeKit

class MazeKitTests: XCTestCase {

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testParity() {
		let evenMaze = Maze(width: 20, height: 20)
		XCTAssert(evenMaze.columns == 21 && evenMaze.rows == 21)
		let oddMaze = Maze(width: 55, height: 55)
		XCTAssert(oddMaze.columns == 55 && oddMaze.rows == 55)
	}

	func testGridCreate() {
		let maze = Maze(width: 59, height: 59)
		for row in 0...58 {
			for col in 0...58 {
				XCTAssert(maze[row, col] == .impassable)
			}
		}
	}

	func testString() {
		var maze = Maze(width: 25, height: 9)
		print(maze)
		maze = Maze(width: 5, height: 5)
		print(maze)
	}


	func testGenerate() {
		var maze: Maze
		maze = Maze(width: 10, height: 10)
		 maze.generate(start: MazePoint(row: 0, column: 0))
		print(maze)

		maze = Maze(width: 25, height: 25)
		 maze.generate(start: MazePoint(row: 0, column: 0))
		print(maze)

		maze = Maze(width: 10, height: 25)
		 maze.generate(start: MazePoint(row: 0, column: 0))
		print(maze)

	}

	func testGenerationPerformance() {
		self.measure {
			var maze = Maze(width: 100, height: 100)
			 maze.generate(start: MazePoint.zero)
		}
	}

	func testMemoryBaseline() {
		// Current baseline: 45.4MB
		()
	}

	func testMemoryFootprint() {
		var maze = Maze(width: 100, height: 100)
		 maze.generate(start: MazePoint.zero)
	}

}
