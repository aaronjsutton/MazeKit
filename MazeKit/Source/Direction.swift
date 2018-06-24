//
//  Direction.swift
//  MazeKit
//
//  Created by Aaron Sutton on 6/22/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import Foundation

/// An enumeration that represents the four cardinal directions.
///
/// - N: North
/// - E: East
/// - S: South
/// - W: West
internal enum Direction: CaseIterable {
	case N
	case E
	case S
	case W

	/// Returns the directions that are perpendicular to a given direction.
	///
	/// - Parameter direction: The initial direction.
	/// - Returns: Two values, directions perpendiuclar to `direction`
	var perpendiculars: Set<Direction> {
		return (self == .N || self == .S) ? [.E, .W] : [.N, .S]
	}

	/// Generates a random direction.
	///
	/// - Parameter directions: Exclude this set from the directions.
	/// - Returns: Returns nil if a random direction cannot be generated.
	static func random(exclude directions: Set<Direction>) -> Direction? {
		guard directions.isStrictSubset(of: Direction.allCases) else {
			return nil
		}
		var result: Direction
		repeat {
			// Force unwrap because we know allCases will never be empty.
			result = Direction.allCases.randomElement()!
		} while directions.contains(result)
		return result
	}

	
}
