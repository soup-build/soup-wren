// <copyright file="build-task-unit-tests.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "soup-test" for SoupTest, SoupTestOperation
import "../../extension/tasks/build-task" for BuildTask
import "Soup|Build.Utils:./path" for Path
import "../../test/assert" for Assert

class BuildTaskUnitTests {
	construct new() {
	}

	RunTests() {
		System.print("BuildTaskUnitTests.Build_Execute_NoSource")
		this.Build_Execute_NoSource()
		System.print("BuildTaskUnitTests.Build_Executable_Source")
		this.Build_Executable_Source()
		System.print("BuildTaskUnitTests.Build_Executable_RuntimeDependency")
		this.Build_Executable_RuntimeDependency()
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
		buildTable["ScriptDirectory"] = "script/"
		buildTable["Source"] = []

		// Setup parameters table
		var parametersTable = {}
		globalState["Parameters"] = parametersTable

		// Setup dependencies table
		var dependenciesTable = {}
		globalState["Dependencies"] = dependenciesTable
		dependenciesTable["Tool"] = {
			"mwasplund|mkdir": {
				"SharedState": {
					"Build": {
						"RunExecutable": "/TARGET/mkdir.exe"
					}
				}
			}
		}

		BuildTask.evaluate()

		// Verify expected logs
		Assert.ListEqual(
			[
				"INFO: Copy Module: main",
				"INFO: Build Generate Done",
			],
			SoupTest.logs)

		// Verify build state
		var expectedBuildOperations = [
			SoupTestOperation.new(
				"MakeDir [./script/]",
				Path.new("/TARGET/mkdir.exe"),
				[
					"./script/",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("script/"),
				]),
			SoupTestOperation.new(
				"MakeDir [./script/main/]",
				Path.new("/TARGET/mkdir.exe"),
				[
					"./script/main/",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("script/main/"),
				]),
			SoupTestOperation.new(
				"WriteFile [./script/bundles.sml]",
				Path.new("writefile.exe"),
				[
					"./script/bundles.sml",
					"Bundles: {\n}\n",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("script/bundles.sml"),
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
		buildTable["ScriptDirectory"] = "script/"
		buildTable["Source"] = [
			"TestFile.wren",
		]

		// Setup parameters table
		var parametersTable = {}
		globalState["Parameters"] = parametersTable

		// Setup dependencies table
		var dependenciesTable = {}
		globalState["Dependencies"] = dependenciesTable
		dependenciesTable["Tool"] = {
			"mwasplund|copy": {
				"SharedState": {
					"Build": {
						"RunExecutable": "/TARGET/copy.exe"
					}
				}
			},
			"mwasplund|mkdir": {
				"SharedState": {
					"Build": {
						"RunExecutable": "/TARGET/mkdir.exe"
					}
				}
			}
		}

		BuildTask.evaluate()

		// Verify expected logs
		Assert.ListEqual(
			[
				"INFO: Copy Module: main",
				"INFO: Build Generate Done",
			],
			SoupTest.logs)

		// Verify build state
		var expectedBuildOperations = [
			SoupTestOperation.new(
				"MakeDir [./script/]",
				Path.new("/TARGET/mkdir.exe"),
				[
					"./script/",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("./script/"),
				]),
			SoupTestOperation.new(
				"MakeDir [./script/main/]",
				Path.new("/TARGET/mkdir.exe"),
				[
					"./script/main/",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("script/main/"),
				]),
			SoupTestOperation.new(
				"Copy [C:/source/TestFile.wren] -> [./script/main/TestFile.wren]",
				Path.new("/TARGET/copy.exe"),
				[
					"C:/source/TestFile.wren",
					"./script/main/TestFile.wren",
				],
				Path.new("C:/target/"),
				[
					Path.new("C:/source/TestFile.wren"),
				],
				[
					Path.new("script/main/TestFile.wren"),
				]),
			SoupTestOperation.new(
				"WriteFile [./script/bundles.sml]",
				Path.new("writefile.exe"),
				[
					"./script/bundles.sml",
					"Bundles: {\n}\n",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("script/bundles.sml"),
				]),
		]

		Assert.ListEqual(
			expectedBuildOperations,
			SoupTest.operations)
	}

	Build_Executable_RuntimeDependency() {
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
		buildTable["ScriptDirectory"] = "script/"
		buildTable["Source"] = [
			"TestFile.wren",
		]
		buildTable["ModuleDependencies"] = {
			"Proj1": {
				"TargetDirectory": "C:/target2/",
				"Source": [
					"TestFile2.wren"
				]
			}
		}

		// Setup parameters table
		var parametersTable = {}
		globalState["Parameters"] = parametersTable

		// Setup dependencies table
		var dependenciesTable = {}
		globalState["Dependencies"] = dependenciesTable
		dependenciesTable["Tool"] = {
			"mwasplund|copy": {
				"SharedState": {
					"Build": {
						"RunExecutable": "/TARGET/copy.exe"
					}
				}
			},
			"mwasplund|mkdir": {
				"SharedState": {
					"Build": {
						"RunExecutable": "/TARGET/mkdir.exe"
					}
				}
			}
		}

		BuildTask.evaluate()

		// Verify expected logs
		Assert.ListEqual(
			[
				"INFO: Copy Module: main",
				"INFO: Copy Module: Proj1",
				"INFO: Build Generate Done",
			],
			SoupTest.logs)

		// Verify build state
		var expectedBuildOperations = [
			SoupTestOperation.new(
				"MakeDir [./script/]",
				Path.new("/TARGET/mkdir.exe"),
				[
					"./script/",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("./script/"),
				]),
			SoupTestOperation.new(
				"MakeDir [./script/main/]",
				Path.new("/TARGET/mkdir.exe"),
				[
					"./script/main/",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("script/main/"),
				]),
			SoupTestOperation.new(
				"Copy [C:/source/TestFile.wren] -> [./script/main/TestFile.wren]",
				Path.new("/TARGET/copy.exe"),
				[
					"C:/source/TestFile.wren",
					"./script/main/TestFile.wren",
				],
				Path.new("C:/target/"),
				[
					Path.new("C:/source/TestFile.wren"),
				],
				[
					Path.new("script/main/TestFile.wren"),
				]),
			SoupTestOperation.new(
				"MakeDir [./script/Proj1/]",
				Path.new("/TARGET/mkdir.exe"),
				[
					"./script/Proj1/",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("script/Proj1/"),
				]),
			SoupTestOperation.new(
				"Copy [C:/target2/TestFile2.wren] -> [./script/Proj1/TestFile2.wren]",
				Path.new("/TARGET/copy.exe"),
				[
					"C:/target2/TestFile2.wren",
					"./script/Proj1/TestFile2.wren",
				],
				Path.new("C:/target/"),
				[
					Path.new("C:/target2/TestFile2.wren"),
				],
				[
					Path.new("script/Proj1/TestFile2.wren"),
				]),
			SoupTestOperation.new(
				"WriteFile [./script/Bundles.sml]",
				Path.new("writefile.exe"),
				[
					"./script/bundles.sml",
					"Bundles: {\n\t'Proj1': { Root: './Proj1/' }\n}\n",
				],
				Path.new("C:/target/"),
				[],
				[
					Path.new("script/bundles.sml"),
				]),
		]

		Assert.ListEqual(
			expectedBuildOperations,
			SoupTest.operations)
	}
}
