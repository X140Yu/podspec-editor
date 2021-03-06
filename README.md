# podspec_editor

[![Build Status](https://travis-ci.org/X140Yu/podspec-editor.svg?branch=master)](https://travis-ci.org/X140Yu/podspec-editor)
[![Coverage Status](https://coveralls.io/repos/github/X140Yu/podspec-editor/badge.svg)](https://coveralls.io/github/X140Yu/podspec-editor)
[![Gem Version](https://badge.fury.io/rb/podspec_editor.svg)](https://badge.fury.io/rb/podspec_editor)

💎 A ruby gem which can edit [podspec](https://guides.cocoapods.org/syntax/podspec.html).


## Installation

    $ gem install podspec_editor -v 0.4.0

## Usage

```ruby
require 'podspec_editor'

# create an editor
editor = PodspecEditor::Editor.new(spec_path: 'path/to/spec/')

# read value from editor
editor.spec.name
editor.spec.key_not_exist
editor.spec.subspecs[0].name

# remove value from editor
editor.spec.name = nil
editor.spec.key_not_exist = nil
editor.spec.subspecs[0].source_files = nil

# update value from editor
# update non-exist key will add this k-v pair to the spec
editor.spec.name = 'abc'
editor.spec.subspecs[0].name = 'cde'
editor.spec.subspecs[0].source_files = new_source_files = ['A.h']

# get current json content
editor.current_json_content
```

See `spec/podspec_editor/editor_spec.rb` for more usage examples.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
