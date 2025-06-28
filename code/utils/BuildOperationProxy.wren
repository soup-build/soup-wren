// <copyright file="BuildOperation.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "./ListExtensions" for ListExtensions

class BuildOperationProxy {
	construct new(
		title,
		workingDirectory,
		executable,
		arguments,
		declaredInput,
		resultFile,
		finalizerTask,
		finalizerState) {
		_title = title
		_workingDirectory = workingDirectory
		_executable = executable
		_arguments = arguments
		_declaredInput = declaredInput
		_resultFile = resultFile
		_finalizerTask = finalizerTask
		_finalizerState = finalizerState
	}

	Title { _title }
	WorkingDirectory { _workingDirectory }
	Executable { _executable}
	Arguments { _arguments }
	DeclaredInput { _declaredInput }
	ResultFile { _resultFile }
	FinalizerTask { _finalizerTask }
	FinalizerState { _finalizerState }

	==(other) {
		// System.print("BuildOperation==")
		if (other is Null) {
			return false
		}

		return this.Title == other.Title &&
			this.WorkingDirectory == other.WorkingDirectory  &&
			this.Executable == other.Executable &&
			ListExtensions.SequenceEqual(this.Arguments, other.Arguments) &&
			ListExtensions.SequenceEqual(this.DeclaredInput, other.DeclaredInput) &&
			this.ResultFile == other.ResultFile &&
			this.FinalizerTask == other.FinalizerTask &&
			this.FinalizerState == other.FinalizerState
	}

	toString {
		return "BuildOperationProxy { Title=%(_title), WorkingDirectory=%(_workingDirectory), Executable=%(_executable), Arguments=%(_arguments), DeclaredInput=%(_declaredInput), ResultFile=%(_resultFile), FinalizerTask=%(_finalizerTask), FinalizerState=%(_finalizerState) }"
	}
}
