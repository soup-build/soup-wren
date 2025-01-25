Name: 'Wren'
Language: 'Wren|0'
Version: 0.4.2
Source: [
	'tasks/BuildTask.wren'
	'tasks/RecipeBuildTask.wren'
	'tasks/ResolveDependenciesTask.wren'
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