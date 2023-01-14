// <copyright file="BuildTaskUnitTests.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "soup-test" for SoupTest, SoupTestOperation
import "../../Extension/Tasks/BuildTask" for BuildTask
import "../../Utils/Path" for Path
import "../../Test/Assert" for Assert

class BuildTaskUnitTests {
	construct new() {
	}

	RunTests() {
		System.print("BuildTaskUnitTests.Build_Execute_NoSource")
		this.Build_Execute_NoSource()
		System.print("BuildTaskUnitTests.Build_Executable_Source")
		this.Build_Executable_Source()
	}

	Build_Execute_NoSource() {
		// Setup the input build state
		SoupTest.initialize()
		var activeState = SoupTest.activeState
		var globalState = SoupTest.globalState

		// Setup build table
		var buildTable = {}
		activeState["Build"] = buildTable
		buildTable["TargetName"] = "Program"
		buildTable["SourceRootDirectory"] = "C:/source/"
		buildTable["TargetRootDirectory"] = "C:/target/"
		buildTable["BinaryDirectory"] = "bin/"
		buildTable["Source"] = []

		// Setup parameters table
		var parametersTable = {}
		globalState["Parameters"] = parametersTable

		BuildTask.evaluate()

		// Verify expected logs
		Assert.ListEqual(
			[
				"INFO: Build Generate Done",
			],
			SoupTest.logs)

		// Verify build state
		var expectedBuildOperations = [
			SoupTestOperation.new(
				"MakeDir [./bin/]",
				Path.new("C:/Program Files/SoupBuild/Soup/Soup/mkdir.exe"),
				"\"./bin/\"",
				Path.new("C:/target/"),
				[],
				[
					Path.new("bin/"),
				]),
		]

		Assert.ListEqual(
			expectedBuildOperations,
			SoupTest.operations)
	}

	Build_Executable_Source() {
		// Setup the input build state
		SoupTest.initialize()
		var activeState = SoupTest.activeState
		var globalState = SoupTest.globalState

		// Setup build table
		var buildTable = {}
		activeState["Build"] = buildTable
		buildTable["TargetName"] = "Program"
		buildTable["SourceRootDirectory"] = "C:/source/"
		buildTable["TargetRootDirectory"] = "C:/target/"
		buildTable["BinaryDirectory"] = "bin/"
		buildTable["Source"] = [
			"TestFile.wren",
		]

		// Setup parameters table
		var parametersTable = {}
		globalState["Parameters"] = parametersTable

		BuildTask.evaluate()

		// Verify expected logs
		Assert.ListEqual(
			[
				"INFO: Build Generate Done",
			],
			SoupTest.logs)

		// Verify build state
		var expectedBuildOperations = [
			SoupTestOperation.new(
				"MakeDir [./bin/]",
				Path.new("C:/Program Files/SoupBuild/Soup/Soup/mkdir.exe"),
				"\"./bin/\"",
				Path.new("C:/target/"),
				[],
				[
					Path.new("./bin/"),
				]),
			SoupTestOperation.new(
				"Copy [C:/source/TestFile.wren] -> [./bin/TestFile.wren]",
				Path.new("C:/Program Files/SoupBuild/Soup/Soup/copy.exe"),
				"\"C:/source/TestFile.wren\" \"./bin/TestFile.wren\"",
				Path.new("C:/target/"),
				[
					Path.new("C:/source/TestFile.wren"),
				],
				[
					Path.new("bin/TestFile.wren"),
				]),
		]

		Assert.ListEqual(
			expectedBuildOperations,
			SoupTest.operations)
	}
}
