// <copyright file="ResolveToolsTask.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "soup" for Soup, SoupTask
import "Soup|Build.Utils:./ListExtensions" for ListExtensions
import "Soup|Build.Utils:./MapExtensions" for MapExtensions

/// <summary>
/// The resolve dependencies build task that knows how to combine all previous state
/// into the active state.
/// </summary>
class ResolveDependenciesTask is SoupTask {
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
		var activeState = Soup.activeState
		var globalState = Soup.globalState

		if (globalState.containsKey("Dependencies")) {
			var dependenciesTable = globalState["Dependencies"]
			if (dependenciesTable.containsKey("Runtime")) {
				var runtimeDependenciesTable = dependenciesTable["Runtime"]
				var buildTable = MapExtensions.EnsureTable(activeState, "Build")
				var moduleDependenciesTable = MapExtensions.EnsureTable(buildTable, "ModuleDependencies")

				for (dependencyName in runtimeDependenciesTable.keys) {
					// Combine the core dependency build inputs for the core build task
					Soup.info("Combine Runtime Dependency: %(dependencyName)")
					var dependencyTable = runtimeDependenciesTable[dependencyName]
					var moduleTable = MapExtensions.EnsureTable(moduleDependenciesTable, dependencyName)

					var dependencySharedStateTable = dependencyTable["SharedState"]
					if (dependencySharedStateTable.containsKey("Build")) {
						var dependencyBuildTable = dependencySharedStateTable["Build"]

						if (dependencyBuildTable.containsKey("Source") && dependencyBuildTable.containsKey("TargetDirectory")) {
							var sourceDependencies = dependencyBuildTable["Source"]
							moduleTable["Source"] = sourceDependencies
							moduleTable["TargetDirectory"] = dependencyBuildTable["TargetDirectory"]
						}
					}
				}
			}
		}
	}
}
