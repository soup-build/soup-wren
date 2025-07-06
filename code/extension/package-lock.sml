Version: 5
Closures: {
	Root: {
		Wren: {
			'Soup|Build.Utils': { Version: '../utils/', Build: 'Build0', Tool: 'Tool0' }
			'Soup|Wren': { Version: './', Build: 'Build0', Tool: 'Tool0' }
			Wren: { Version: './', Build: 'Build0', Tool: 'Tool0' }
		}
	}
	Build0: {
		Wren: {
			'Soup|Wren': { Version: 0.5.1 }
		}
	}
	Tool0: {
		'C++': {
			'mwasplund|copy': { Version: 1.2.0 }
			'mwasplund|mkdir': { Version: 1.2.0 }
		}
	}
}