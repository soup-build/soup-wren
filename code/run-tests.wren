import "./utils-tests/glob-unit-tests" for GlobUnitTests
import "./utils-tests/path-unit-tests" for PathUnitTests
import "./extension-tests/tasks/build-task-unit-tests" for BuildTaskUnitTests
import "./extension-tests/tasks/recipe-build-task-unit-tests" for RecipeBuildTaskUnitTests

var uut

// Utils.UnitTests
uut = GlobUnitTests.new()
uut.RunTests()
uut = PathUnitTests.new()
uut.RunTests()

// Extension.UnitTests
uut = BuildTaskUnitTests.new()
uut.RunTests()
uut = RecipeBuildTaskUnitTests.new()
uut.RunTests()