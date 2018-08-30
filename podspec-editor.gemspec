lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'podspec/editor/version'

Gem::Specification.new do |spec|
  spec.name          = 'podspec-editor'
  spec.version       = Podspec::Editor::VERSION
  spec.authors       = ['X140Yu']
  spec.email         = ['zhaoxinyu1994@gmail.com']

  spec.summary       = 'Edit podspec'
  spec.description   = 'Edit podspecs'
  spec.homepage      = 'https://zhaoxinyu.me'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'cocoapods', '~> 1.5'
  spec.add_development_dependency 'coveralls'

end
