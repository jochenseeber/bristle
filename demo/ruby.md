# Ruby project

Create configuration file `project.json` with the folloging content:

    {
        "name": "bristle_demo",
        "version": "1.0.0.dev",
        "summary": "Bristle demo",
        "developers": {
            "john.doe": {
                "name": "John Doe",
                "email": "john.doe@nowhere"
            }
        },
        "language": {
            "ruby": true
        },
        "presets": {
            "github": {
                "user": "johndoe"
            },
            "common": true,
            "ruby": true,
            "vscode": true
        }
    }

Then run the following command to create the project files:

    bb setup

This creates the project files for your Ruby project

    Pathname("Rakefile").assert.file?
    Pathname("Gemfile").assert.file?
    Pathname("bristle_demo.gemspec").assert.file?    