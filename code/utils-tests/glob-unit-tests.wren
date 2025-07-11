// <copyright file="glob-unit-tests.wren" company="Soup">
// Copyright (c) Soup. All rights reserved.
// </copyright>

import "Soup|Build.Utils:./glob" for Glob
import "Soup|Build.Utils:./path" for Path
import "../test/assert" for Assert

class GlobUnitTests {
	construct new() {
	}

	RunTests() {
		System.print("GlobUnitTests.IsMatch_SimpleFile_Exact()")
		this.IsMatch_SimpleFile_Exact()
		System.print("GlobUnitTests.IsMatch_SimpleFile_DifferentStart()")
		this.IsMatch_SimpleFile_DifferentStart()
		System.print("GlobUnitTests.IsMatch_SimpleFile_DifferentEnd()")
		this.IsMatch_SimpleFile_DifferentEnd()
		System.print("GlobUnitTests.IsMatch_SimpleFile_BeyondEnd()")
		this.IsMatch_SimpleFile_BeyondEnd()
		System.print("GlobUnitTests.IsMatch_SimpleFile_TooShort()")
		this.IsMatch_SimpleFile_TooShort()

		System.print("GlobUnitTests.IsMatch_QuestionMark_AtStart()")
		this.IsMatch_QuestionMark_AtStart()
		System.print("GlobUnitTests.IsMatch_QuestionMark_Middle()")
		this.IsMatch_QuestionMark_Middle()
		System.print("GlobUnitTests.IsMatch_QuestionMark_AtEnd()")
		this.IsMatch_QuestionMark_AtEnd()
		System.print("GlobUnitTests.IsMatch_QuestionMark_All()")
		this.IsMatch_QuestionMark_All()
		
		System.print("GlobUnitTests.IsMatch_Star_Simple()")
		this.IsMatch_Star_Simple()
		System.print("GlobUnitTests.IsMatch_Star_DoubleMatch()")
		this.IsMatch_Star_DoubleMatch()
		System.print("GlobUnitTests.IsMatch_Star_DoubleNextCharacter()")
		this.IsMatch_Star_DoubleNextCharacter()
		System.print("GlobUnitTests.IsMatch_Star_Directory_NoMatch()")
		this.IsMatch_Star_Directory_NoMatch()

		System.print("GlobUnitTests.IsMatch_DoubleStar_SingleFile()")
		this.IsMatch_DoubleStar_SingleFile()
		System.print("GlobUnitTests.IsMatch_DoubleStar_Directory()")
		this.IsMatch_DoubleStar_Directory()
		System.print("GlobUnitTests.IsMatch_DoubleStar_MultipleDirectory()")
		this.IsMatch_DoubleStar_MultipleDirectory()
		System.print("GlobUnitTests.IsMatch_DoubleStar_RequiredDirectory_Match()")
		this.IsMatch_DoubleStar_RequiredDirectory_Match()
		System.print("GlobUnitTests.IsMatch_DoubleStar_RequiredDirectory_NoMatch()")
		this.IsMatch_DoubleStar_RequiredDirectory_NoMatch()

		System.print("GlobUnitTests.IsMatch_AnyFile_SingleFileManyDirectories()")
		this.IsMatch_AnyFile_SingleFileManyDirectories()
		System.print("GlobUnitTests.IsMatch_AnyFile_SingleFile()")
		this.IsMatch_AnyFile_SingleFile()
	}

	IsMatch_SimpleFile_Exact() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./File.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}
	
	IsMatch_SimpleFile_DifferentStart() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./2ile.txt")
		Assert.False(Glob.IsMatch(pattern, target))
	}
	
	IsMatch_SimpleFile_DifferentEnd() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./File.tx2")
		Assert.False(Glob.IsMatch(pattern, target))
	}
	
	IsMatch_SimpleFile_BeyondEnd() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./File.txt2")
		Assert.False(Glob.IsMatch(pattern, target))
	}
	
	IsMatch_SimpleFile_TooShort() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./File.tx")
		Assert.False(Glob.IsMatch(pattern, target))
	}

	IsMatch_QuestionMark_AtStart() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./?ile.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_QuestionMark_Middle() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./Fil?.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_QuestionMark_AtEnd() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./File.tx?")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_QuestionMark_All() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./????.???")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_Star_Simple() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./*.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_Star_DoubleMatch() {
		var target = Path.new("./File.txt.txt")
		var pattern = Path.new("./*.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_Star_DoubleNextCharacter() {
		var target = Path.new("./File..txt")
		var pattern = Path.new("./*.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_Star_Directory_NoMatch() {
		var target = Path.new("./Dir1/File.txt")
		var pattern = Path.new("./*.txt")
		Assert.False(Glob.IsMatch(pattern, target))
	}

	IsMatch_DoubleStar_SingleFile() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./**/File.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_DoubleStar_Directory() {
		var target = Path.new("./Dir/File.txt")
		var pattern = Path.new("./**/File.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_DoubleStar_MultipleDirectory() {
		var target = Path.new("./Dir1/Dir2/Dir3/File.txt")
		var pattern = Path.new("./**/File.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_DoubleStar_RequiredDirectory_Match() {
		var target = Path.new("./Dir1/Dir2/Dir3/File.txt")
		var pattern = Path.new("./**/Dir3/File.txt")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_DoubleStar_RequiredDirectory_NoMatch() {
		var target = Path.new("./Dir1/Dir2/Dir3/File.txt")
		var pattern = Path.new("./**/Dir1/File.txt")
		Assert.False(Glob.IsMatch(pattern, target))
	}

	IsMatch_AnyFile_SingleFileManyDirectories() {
		var target = Path.new("./Dir1/Dir2/Dir3/File.txt")
		var pattern = Path.new("./**/*")
		Assert.True(Glob.IsMatch(pattern, target))
	}

	IsMatch_AnyFile_SingleFile() {
		var target = Path.new("./File.txt")
		var pattern = Path.new("./**/*")
		Assert.True(Glob.IsMatch(pattern, target))
	}
}