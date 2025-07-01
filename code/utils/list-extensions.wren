// <copyright file="list-extensions.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "./path" for Path

class ListExtensions {
	static SequenceEqual(lhs, rhs) {
		// System.print("SequenceEqual LHS: %(lhs)")
		// System.print("SequenceEqual RHS: %(rhs)")
		if (lhs is Null || rhs is Null) {
			return lhs is Null && rhs is Null
		}

		if (lhs.count != rhs.count) {
			return false
		}

		for (i in 0...lhs.count) {
			// System.print("SequenceEqual value %(lhs[i]) == %(rhs[i])")
			if (lhs[i].type.name == rhs[i].type.name) {
				if (lhs[i].type == Map) {
					System.abort("cannot compare map in list... sorry")
				} else if (lhs[i].type == List) {
					if (!ListExtensions.SequenceEqual(lhs[i], rhs[i])) {
						// System.print("list list not equal")
						return false
					}
				} else {
					if (!(lhs[i] == rhs[i])) {
						// System.print("list value not equal")
						return false
					}
				}
			} else {
				// System.print("list mismatch types %(lhs[i].type.name) == %(rhs[i].type.name)")
				return false
			}
		}

		return true
	}

	static ConvertToPathList(list) {
		var result = []
		for (value in list) {
			result.add(Path.new(value.toString))
		}

		return result
	}

	static ConvertFromPathList(list) {
		var result = []
		for (value in list) {
			result.add(value.toString)
		}

		return result
	}

	static Append(target, source) {
		for (value in source) {
			target.add(value)
		}
	}
}