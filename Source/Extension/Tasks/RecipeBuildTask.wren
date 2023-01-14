// <copyright file="RecipeBuildTask.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "soup" for Soup, SoupTask
import "../../Utils/Path" for Path
import "../../Utils/ListExtensions" for ListExtensions
import "../../Utils/MapExtensions" for MapExtensions

/// <summary>
/// The recipe build task that knows how to build a single recipe
/// </summary>
class RecipeBuildTask is SoupTask {
	/// <summary>
	/// Get the run before list
	/// </summary>
	static runBefore { [
		"BuildTask",
	] }

	/// <summary>
	/// Get the run after list
	/// </summary>
	static runAfter { [] }

	/// <summary>
	/// The Core Execute task
	/// </summary>
	static evaluate() {
		var globalState = Soup.globalState
		var activeState = Soup.activeState
		var parametersTable = globalState["Parameters"]
		var recipeTable = globalState["Recipe"]
		var buildTable = MapExtensions.EnsureTable(activeState, "Build")

		// Load the input properties
		var packageRoot = Path.new(parametersTable["PackageDirectory"])

		// Load Recipe properties
		var name = recipeTable["Name"]

		// Build up arguments to build this individual recipe
		var targetDirectory = Path.new(parametersTable["TargetDirectory"])
		var binaryDirectory = Path.new("bin/")

		// Load the source files if present
		var sourceFiles = []
		if (recipeTable.containsKey("Source")) {
			sourceFiles = recipeTable["Source"]
		}

		buildTable["TargetName"] = name
		buildTable["SourceRootDirectory"] = packageRoot.toString
		buildTable["TargetRootDirectory"] = targetDirectory.toString
		buildTable["BinaryDirectory"] = binaryDirectory.toString

		ListExtensions.Append(
			MapExtensions.EnsureList(buildTable, "Source"),
			sourceFiles)
	}
}
