// <copyright file="BuildTask.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "soup" for Soup, SoupTask
import "../../Utils/Path" for Path
import "../../Utils/ListExtensions" for ListExtensions
import "../../Utils/MapExtensions" for MapExtensions
import "../../Utils/SharedOperations" for SharedOperations
import "../../Utils/Set" for Set

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
		var scriptDirectory = Path.new(buildTable["ScriptDirectory"])

		var sourceFiles = []
		if (buildTable.containsKey("Source")) {
			sourceFiles = ListExtensions.ConvertToPathList(buildTable["Source"])
		}

		// Load the dependency references
		var moduleDependencies = {}
		if (buildTable.containsKey("ModuleDependencies")) {
			moduleDependencies = buildTable["ModuleDependencies"]
		}

		var buildOperations = BuildTask.build(
			sourceRootDirectory,
			targetRootDirectory,
			scriptDirectory,
			sourceFiles,
			moduleDependencies)

		// Always pass along required input to shared build tasks
		var mainModuleTargetDirectory = targetRootDirectory + scriptDirectory + Path.new("Main/")
		var sharedBuildTable = MapExtensions.EnsureTable(sharedState, "Build")
		sharedBuildTable["TargetDirectory"] = mainModuleTargetDirectory.toString
		sharedBuildTable["Source"] = ListExtensions.ConvertFromPathList(sourceFiles)

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

	static build(
		sourceRootDirectory,
		targetRootDirectory,
		scriptDirectory,
		sourceFiles,
		moduleDependencies) {
		var result = []

		// Ensure the output directories exists as the first step
		result.add(
			SharedOperations.CreateCreateDirectoryOperation(
				targetRootDirectory,
				scriptDirectory))

		// Copy the main module
		result = result + BuildTask.copyModule(
			sourceRootDirectory,
			targetRootDirectory,
			scriptDirectory,
			"Main",
			sourceFiles)

		// Copy all module dependencies
		for (moduleName in moduleDependencies.keys) {
			var moduleTable = moduleDependencies[moduleName]
			var moduleSourceFiles = ListExtensions.ConvertToPathList(moduleTable["Source"])
			var moduleTargetDirectory = Path.new(moduleTable["TargetDirectory"])
			result = result + BuildTask.copyModule(
				moduleTargetDirectory,
				targetRootDirectory,
				scriptDirectory,
				moduleName,
				moduleSourceFiles)
		}

		// Create the Module Bundle definitions
		var moduleBundles = ""
		moduleBundles = moduleBundles + "Bundles: {\n"
		for (moduleName in moduleDependencies.keys) {
			var moduleBundleDirectory = Path.new(moduleName + "/")
			moduleBundles = moduleBundles + "\t\"%(moduleName)\": { Root: \"%(moduleBundleDirectory)\" }\n"
		}

		moduleBundles = moduleBundles + "}\n"

		// Write the bundle file
		var moduleBundlesFile = scriptDirectory + Path.new("Bundles.sml")
		result.add(
			SharedOperations.CreateWriteFileOperation(
				targetRootDirectory,
				moduleBundlesFile,
				moduleBundles))

		return result
	}

	static copyModule(
		sourceRootDirectory,
		targetRootDirectory,
		scriptDirectory,
		name,
		sourceFiles) {
		var result = []

		Soup.info("Copy Module: %(name)")
		var moduleDirectory = scriptDirectory + Path.new(name + "/")

		// Discover all unique sub folders
		var folderSet = Set.new()
		folderSet.add(moduleDirectory)
		for (file in sourceFiles) {
			folderSet.add(moduleDirectory + file.GetParent())
		}

		// Ensure the output directories exists
		for (folder in folderSet.list) {
			result.add(
				SharedOperations.CreateCreateDirectoryOperation(
					targetRootDirectory,
					folder))
		}

		// Copy the script files to the output
		for (file in sourceFiles) {
			result.add(
				SharedOperations.CreateCopyFileOperation(
					targetRootDirectory,
					sourceRootDirectory + file,
					moduleDirectory + file))
		}

		return result
	}
}
