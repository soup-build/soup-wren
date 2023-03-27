// <copyright file="SharedOperations.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "soup" for Soup
import "./BuildOperation" for BuildOperation
import "./Path" for Path

/// <summary>
/// The Shared Operations class
/// </summary>
class SharedOperations {
	/// <summary>
	/// Create a build operation that will copy a file
	/// </summary>
	static CreateCopyFileOperation(
		workingDirectory,
		source,
		destination) {
		// Discover the dependency tool
		var copyExecutable = SharedOperations.ResolveRuntimeDependencyRunExectable("copy")

		var title = "Copy [%(source)] -> [%(destination)]"

		var program = Path.new(copyExecutable)
		var inputFiles = [
			source,
		]
		var outputFiles = [
			destination,
		]

		// Build the arguments
		var arguments = "\"%(source)\" \"%(destination)\""

		return BuildOperation.new(
			title,
			workingDirectory,
			program,
			arguments,
			inputFiles,
			outputFiles)
	}

	/// <summary>
	/// Create a build operation that will create a directory
	/// </summary>
	static CreateCreateDirectoryOperation(
		workingDirectory,
		directory) {
		if (directory.HasFileName) {
			Fiber.abort("Cannot create a directory with a filename.")
		}

		// Discover the dependency tool
		var mkdirExecutable = SharedOperations.ResolveRuntimeDependencyRunExectable("mkdir")

		var title = "MakeDir [%(directory)]"

		var program = Path.new(mkdirExecutable)
		var inputFiles = []
		var outputFiles = [
			directory,
		]

		// Build the arguments
		var arguments = "\"%(directory)\""

		return BuildOperation.new(
			title,
			workingDirectory,
			program,
			arguments,
			inputFiles,
			outputFiles)
	}

	/// <summary>
	/// Create a build operation that will write the content to a file
	/// </summary>
	static CreateWriteFileOperation(
		workingDirectory,
		destination,
		content) {
		if (!destination.HasFileName) {
			Fiber.abort("Cannot create a file with from a directory.")
		}

		var title = "WriteFile [%(destination)]"

		// Create the fake write file executable that will be executed in process
		var program = Path.new("writefile.exe")
		var inputFiles = []
		var outputFiles = [
			destination,
		]

		// Build the arguments
		var arguments = "\"%(destination)\" \"%(content)\""

		return BuildOperation.new(
			title,
			workingDirectory,
			program,
			arguments,
			inputFiles,
			outputFiles)
	}

	static ResolveRuntimeDependencyRunExectable(dependencyName) {
		var dependencies = Soup.globalState["Dependencies"]
		if (!dependencies.containsKey("Tool")) {
			Fiber.abort("Missing Tool Dependencies for \"%(dependencyName)\"")
		}

		var runtimeDependencies = dependencies["Tool"]
		if (!runtimeDependencies.containsKey(dependencyName)) {
			Fiber.abort("Missing Tool Dependency \"%(dependencyName)\"")
		}

		var dependency = runtimeDependencies[dependencyName]
		return dependency["SharedState"]["Build"]["RunExecutable"]
	}
}
