import "./utils-tests/PathUnitTests" for PathUnitTests
import "./extension-tests/tasks/BuildTaskUnitTests" for BuildTaskUnitTests
import "./extension-tests/tasks/RecipeBuildTaskUnitTests" for RecipeBuildTaskUnitTests

var uut

// Utils.UnitTests
uut = PathUnitTests.new()
uut.RunTests()

// Extension.UnitTests
uut = BuildTaskUnitTests.new()
uut.RunTests()
uut = RecipeBuildTaskUnitTests.new()
uut.RunTests()