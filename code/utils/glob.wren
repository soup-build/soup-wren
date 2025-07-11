// <copyright file="glob.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "./path" for Path

/// <summary>
/// A utility class that knows how to check for glob match between two paths
/// </summary>
class Glob {
	/// <summary>
	/// check if the provided target path is a match for the pattern
	/// </summary>
	static IsMatch(patternPath, targetPath) {
		var patternDirectories = Path.DecomposeDirectoriesString(patternPath.GetDirectories())
		var targetDirectories = Path.DecomposeDirectoriesString(targetPath.GetDirectories())

		// Scan over the target and pattern directories verify match
		// If a wildcard is unable to match we move forward one and retry
		var patternIndex = 0
		var targetIndex = 0
		var patternRetryIndex = 0
		var targetRetryIndex = 0
		while (patternIndex < patternDirectories.count || targetIndex < targetDirectories.count) {
			if (patternIndex < patternDirectories.count) {
				var patternDirectory = patternDirectories[patternIndex]
				if (patternDirectory == "**") {
					// Match zero or more directories
					// Try to match at current target
					// If that doesn't work out, restart at next target directory
					patternRetryIndex = patternIndex
					targetRetryIndex = targetIndex + 1
					patternIndex = patternIndex + 1
					continue
				} else {
					// Match directory
					if (targetIndex < targetDirectories.count &&
						Glob.IsInnerMatch(targetDirectories[targetIndex], patternDirectory)) {
						patternIndex = patternIndex + 1
						targetIndex = targetIndex + 1
						continue
					}
				}
			}

			// Retry if possible.
			if (targetRetryIndex > 0 && targetRetryIndex <= targetDirectories.count) {
				patternIndex = patternRetryIndex
				targetIndex = targetRetryIndex
				continue
			}

			// Not a match
			return false
		}

		// All the directories match up, check the file names
		var patternFileName = patternPath.GetFileName()
		var targetFileName = targetPath.GetFileName()

		return Glob.IsInnerMatch(patternFileName, targetFileName)
	}

	static IsInnerMatch(pattern, target) {
		// Scan over the target and pattern to verify match
		// If a wildcard is unable to match we move forward one and retry
		var patternIndex = 0
		var targetIndex = 0
		var patternRetryIndex = 0
		var targetRetryIndex = 0
		while (patternIndex < pattern.count || targetIndex < target.count) {
			if (patternIndex < pattern.count) {
				var patternCharacter = pattern[patternIndex]
				if (patternCharacter == "?") {
					// Match single wildcard
					if (targetIndex < target.count) {
						patternIndex = patternIndex + 1
						targetIndex = targetIndex + 1
						continue
					}
				} else if (patternCharacter == "*") {
					// Match zero or more wildcard
					// Try to match at current target
					// If that doesn't work out, restart at next target character
					patternRetryIndex = patternIndex
					targetRetryIndex = targetIndex + 1
					patternIndex = patternIndex + 1
					continue
				} else {
					// Exactly match character
					if (targetIndex < target.count && target[targetIndex] == patternCharacter) {
						patternIndex = patternIndex + 1
						targetIndex = targetIndex + 1
						continue
					}
				}
			}

			// Retry if possible.
			if (targetRetryIndex > 0 && targetRetryIndex <= target.count) {
				patternIndex = patternRetryIndex
				targetIndex = targetRetryIndex
				continue
			}

			// Not a match
			return false
		}

		// Fully matched pattern
		return true
	}
}