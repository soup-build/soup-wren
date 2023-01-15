Name: "Soup.Wren"
Language: "Wren|0.1"
Version: "0.1.0"
Source: [
	"Tasks/BuildTask.wren"
	"Tasks/RecipeBuildTask.wren"
	"Tasks/ResolveDependenciesTask.wren"
]

Dependencies: {
	Runtime: [
		{ Reference: "../Utils" }
	]
}