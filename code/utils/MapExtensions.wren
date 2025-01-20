import "./ListExtensions" for ListExtensions

class MapExtensions {
	static Equal(lhs, rhs) {
		// System.print("MapEqual LHS: %(lhs)")
		// System.print("MapEqual RHS: %(rhs)")
		if (lhs is Null || rhs is Null) {
			return lhs is Null && rhs is Null
		}

		if (lhs.count != rhs.count) {
			return false
		}

		// Check that every key exists in both maps and the value is equal
		for (entry in lhs) {
			// System.print("MapEqual Value %(entry.key) %(entry.value)")
			if (rhs.containsKey(entry.key) &&
				entry.value.type.name == rhs[entry.key].type.name) {
				if (entry.value.type == Map) {
					if (!MapExtensions.Equal(entry.value, rhs[entry.key])) {
						// System.print("map map not equal")
						return false
					}
				} else if (entry.value.type == List) {
					if (!ListExtensions.SequenceEqual(entry.value, rhs[entry.key])) {
						// System.print("map list not equal")
						return false
					}
				} else {
					if (!(entry.value == rhs[entry.key])) {
						// System.print("map value not equal")
						return false
					}
				}
			} else {
				return false
			}
		}

		return true
	}

	static EnsureList(parent, key) {
		if (!parent.containsKey(key)) {
			parent[key] = []
		}

		return parent[key]
	}

	static EnsureTable(parent, key) {
		if (!parent.containsKey(key)) {
			parent[key] = {}
		}

		return parent[key]
	}
}