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
			'Soup|Wren': { Version: 0.4.3 }
		}
	}
	Tool0: {
		'C++': {
			'mwasplund|copy': { Version: 1.1.0 }
			'mwasplund|mkdir': { Version: 1.1.0 }
		}
	}
}