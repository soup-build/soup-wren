Name: "Soup.Wren"
Language: "Wren|0"
Version: "0.3.0"
Source: [
	"tasks/BuildTask.wren"
	"tasks/RecipeBuildTask.wren"
	"tasks/ResolveDependenciesTask.wren"
]

Dependencies: {
	Runtime: [
		"mwasplund|Soup.Build.Utils@0"
	]
	Tool: [
		"[C++]mwasplund|copy@1"
		"[C++]mwasplund|mkdir@1"
	]
}