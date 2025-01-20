import "./Utils.UnitTests/PathUnitTests" for PathUnitTests
import "./Extension.UnitTests/Tasks/BuildTaskUnitTests" for BuildTaskUnitTests
import "./Extension.UnitTests/Tasks/RecipeBuildTaskUnitTests" for RecipeBuildTaskUnitTests

var uut

// Utils.UnitTests
uut = PathUnitTests.new()
uut.RunTests()

// Extension.UnitTests
uut = BuildTaskUnitTests.new()
uut.RunTests()
uut = RecipeBuildTaskUnitTests.new()
uut.RunTests()
