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


	/// Returns the directions that are perpendicular to a given direction.
	///
	/// - Parameter direction: <#direction description#>
	/// - Returns: <#return value description#>
	static func perpendicular(from direction: Direction) -> Set<Direction> {
		switch direction {
		case .N, .S:
			return (.E, .W)
		case .E, .W:
			return (.N, .S)
		}
	}

	
}
