Name: 'Soup.Wren'
Language: 'Wren|0'
Version: '0.4.2'
Source: [
	'Tasks/BuildTask.wren'
	'Tasks/RecipeBuildTask.wren'
	'Tasks/ResolveDependenciesTask.wren'
]

Dependencies: {
	Runtime: [
		'mwasplund|Soup.Build.Utils@0'
	]
	Tool: [
		'[C++]mwasplund|copy@1'
		'[C++]mwasplund|mkdir@1'
	]
}