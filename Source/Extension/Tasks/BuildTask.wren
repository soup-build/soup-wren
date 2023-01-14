// <copyright file="BuildTask.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "soup" for Soup, SoupTask
import "../../Utils/Path" for Path
import "../../Utils/ListExtensions" for ListExtensions
import "../../Utils/SharedOperations" for SharedOperations

class BuildTask is SoupTask {
	/// <summary>
	/// Get the run before list
	/// </summary>
	static runBefore { [] }

	/// <summary>
	/// Get the run after list
	/// </summary>
	static runAfter { [] }

	static evaluate() {
		var globalState = Soup.globalState
		var activeState = Soup.activeState
		var sharedState = Soup.sharedState

		var buildTable = activeState["Build"]
		var parametersTable = globalState["Parameters"]

		var sourceRootDirectory = Path.new(buildTable["SourceRootDirectory"])
		var targetRootDirectory = Path.new(buildTable["TargetRootDirectory"])
		var binaryDirectory = Path.new(buildTable["BinaryDirectory"])

		var sourceFiles = []
		if (buildTable.containsKey("Source")) {
			sourceFiles = ListExtensions.ConvertToPathList(buildTable["Source"])
		}

		var buildOperations = BuildTask.copySource(
			sourceRootDirectory,
			targetRootDirectory,
			binaryDirectory,
			sourceFiles)

		// Register the build operations
		for (operation in buildOperations) {
			Soup.createOperation(
				operation.Title,
				operation.Executable.toString,
				operation.Arguments,
				operation.WorkingDirectory.toString,
				ListExtensions.ConvertFromPathList(operation.DeclaredInput),
				ListExtensions.ConvertFromPathList(operation.DeclaredOutput))
		}

		Soup.info("Build Generate Done")
	}

	static copySource(sourceRootDirectory, targetRootDirectory, binaryDirectory, sourceFiles) {
		var result = []

		// Ensure the output directories exists as the first step
		result.add(
			SharedOperations.CreateCreateDirectoryOperation(
				targetRootDirectory,
				binaryDirectory))

		for (file in sourceFiles) {
			result.add(
				SharedOperations.CreateCopyFileOperation(
					targetRootDirectory,
					sourceRootDirectory + file,
					binaryDirectory + file))
		}

		return result
	}
}
