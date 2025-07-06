// <copyright file="recipe-build-task.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "soup" for Soup, SoupTask
import "Soup|Build.Utils:./path" for Path
import "Soup|Build.Utils:./list-extensions" for ListExtensions
import "Soup|Build.Utils:./map-extensions" for MapExtensions

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
		var contextTable = globalState["Context"]
		var recipeTable = globalState["Recipe"]
		var buildTable = MapExtensions.EnsureTable(activeState, "Build")

		// Load the input properties
		var packageRoot = Path.new(contextTable["PackageDirectory"])

		// Load Recipe properties
		var name = recipeTable["Name"]

		// Build up arguments to build this individual recipe
		var targetDirectory = Path.new(contextTable["TargetDirectory"])
		var scriptDirectory = Path.new("script/")

		// Load the source files if present
		var sourceFiles = null
		if (recipeTable.containsKey("Source")) {
			sourceFiles = recipeTable["Source"]
		}

		buildTable["TargetName"] = name
		buildTable["SourceRootDirectory"] = packageRoot.toString
		buildTable["TargetRootDirectory"] = targetDirectory.toString
		buildTable["ScriptDirectory"] = scriptDirectory.toString

		if (sourceFiles != null) {
			ListExtensions.Append(
				MapExtensions.EnsureList(build, "Source"),
				sourceFiles)
		}
	}
}
