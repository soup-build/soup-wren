﻿// <copyright file="expand-source-task.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "soup" for Soup, SoupTask
import "Soup|Build.Utils:./path" for Path
import "Soup|Build.Utils:./list-extensions" for ListExtensions
import "Soup|Build.Utils:./map-extensions" for MapExtensions

/// <summary>
/// The expand source task that knows how to discover source files from the file system state
/// </summary>
class ExpandSourceTask is SoupTask {
	/// <summary>
	/// Get the run before list
	/// </summary>
	static runBefore { [
		"BuildTask",
	] }

	/// <summary>
	/// Get the run after list
	/// </summary>
	static runAfter { [
		"RecipeBuildTask",
	] }

	/// <summary>
	/// The Core Execute task
	/// </summary>
	static evaluate() {
		var globalState = Soup.globalState
		var activeState = Soup.activeState

		var buildTable = activeState["Build"]

		Soup.info("Check Expand Source")
		if (!buildTable.containsKey("Source")) {
			Soup.info("Expand Source")
			var filesystem = globalState["FileSystem"]
			var sourceFiles = ExpandSourceTask.DiscoverCompileFiles(filesystem, Path.new())

			ListExtensions.Append(
				MapExtensions.EnsureList(buildTable, "Source"),
				ListExtensions.ConvertFromPathList(sourceFiles))
		}
	}

	static DiscoverCompileFiles(currentDirectory, workingDirectory) {
		Soup.info("Discover Files %(workingDirectory)")
		var files = []
		for (directoryEntity in currentDirectory) {
			if (directoryEntity is String) {
				if (directoryEntity.endsWith(".wren")) {
					var file = workingDirectory + Path.new(directoryEntity)
					Soup.info("Found Wren File: %(file)")
					files.add(file)
				}
			} else {
				for (child in directoryEntity) {
					var directory = workingDirectory + Path.new(child.key)
					Soup.info("Found Directory: %(directory)")
					var subFiles = ExpandSourceTask.DiscoverCompileFiles(child.value, directory)
					ListExtensions.Append(files, subFiles)
				}
			}
		}

		return files
	}
}