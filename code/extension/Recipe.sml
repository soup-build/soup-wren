Name: 'Wren'
Language: 'Wren|0'
Version: 0.5.0
Source: [
	'tasks/build-task.wren'
	'tasks/recipe-build-task.wren'
	'tasks/resolve-dependencies-task.wren'
]
Dependencies: {
	Runtime: [
		'Soup|Build.Utils@0'
	]
	Tool: [
		'[C++]mwasplund|copy@1'
		'[C++]mwasplund|mkdir@1'
	]
}