Name: "Soup.Wren"
Language: "Wren|0.1"
Version: "0.2.0"
Source: [
	"Tasks/BuildTask.wren"
	"Tasks/RecipeBuildTask.wren"
	"Tasks/ResolveDependenciesTask.wren"
]

Dependencies: {
	Runtime: [
		"Soup.Build.Utils@0.2.0"
	]
	Tool: [
		"C++|copy@1.0.0"
		"C++|mkdir@1.0.0"
	]
}