//
//  DFSKitTests.swift
//  DFSKitTests
//
//  Created by Aaron Sutton on 6/18/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import XCTest
@testable import DFSKit

class DFSKitTests: XCTestCase {

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
		let maze = Maze(width: 25, height: 9)
		print(maze)
	}

}
