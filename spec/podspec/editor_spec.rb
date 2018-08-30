require 'cocoapods'

RSpec.describe Podspec::Editor do
  it 'has a version number' do
    expect(Podspec::Editor::VERSION).not_to be nil
  end

  def origin_json_content
    File.read(File.expand_path('fixtures/A.podspec.json', __dir__))
  end

  def generate_normal_editor
    PodspecEditor::Editor.new(
      json_path: File.expand_path('fixtures/A.podspec.json', __dir__)
    )
  end

  describe PodspecEditor::Editor do
    describe 'initialize' do
      it 'initialize wrong file will raise error' do
        expect { PodspecEditor::Editor.new(json_path: 'Dangerfile') }.to raise_error(ArgumentError)
      end

      it 'initialize with a json path will not raise error' do
        editor = generate_normal_editor
        expect(editor.origin_json_content).to eq(origin_json_content)
      end

      it 'initialize with a spec path will not raise error' do
        editor = PodspecEditor::Editor.new(
          spec_path: File.expand_path('fixtures/A.podspec', __dir__)
        )
        expect(editor.origin_json_content).to eq(origin_json_content)
      end
    end

    it 'generate default template for pod' do
      content = PodspecEditor::Editor.default_json_spec_content('RxSwift')
      expect(content) == "{\n  \"name\": \"RxSwift\",\n  \"version\": \"1.0.0\",\n  \"summary\": \"TestPod summary\",\n  \"lic...\n  \"homepage\": \"https://www.example.com\",\n  \"platforms\": {\n    \"ios\": \"9.0\"\n  },\n}\n"
    end

    it 'get value from spec' do
      editor = generate_normal_editor
      kvs = [
        editor.spec.name => 'TestPod',
        editor.spec.version => '1.0.0',
        editor.spec.license => 'MIT',
        editor.spec.requires_arc => true,
        editor.spec.key_not_exist => nil,
        editor.spec.authors => OpenStruct.new('test' => 'test@test.com'),
        editor.spec.subspecs[0].name => 'SubSpecA',
        editor.spec.subspecs[0].dependencies => OpenStruct.new('Masonry': [], 'ReactiveObjC': [], 'SDWebImage': [])
      ]
      kvs.each do |kv|
        kv.each do |k, v|
          expect(k).to eq(v)
        end
      end
    end

    describe 'delete value from spec' do
      before :context do
        @editor = generate_normal_editor
      end

      it 'delete normal key' do
        @editor.spec.name = nil
        expect(@editor.spec.name).to eq(nil)

        @editor.spec.authors = nil
        expect(@editor.spec.authors).to eq(nil)
      end

      it 'delete non-exist key' do
        @editor.spec.key_not_exist = nil
        expect(@editor.spec.key_not_exist).to eq(nil)
      end

      it 'delete nested key' do
        @editor.spec.subspecs[0].source_files = nil
        expect(@editor.spec.subspecs[0].source_files).to eq(nil)
      end
    end

    describe 'update value from spec' do
      before :context do
        @editor = generate_normal_editor
      end

      it 'update first level key' do
        expect(@editor.spec.name).to eq('TestPod')
        new_name = 'NewTestPod'
        @editor.spec.name = new_name
        expect(@editor.spec.name).to eq(new_name)
      end

      it 'update nested key' do
        expect(@editor.spec.subspecs[0].name).to eq('SubSpecA')
        new_name = 'newNameA'
        @editor.spec.subspecs[0].name = new_name
        expect(@editor.spec.subspecs[0].name).to eq(new_name)

        new_source_files = ['A.h']
        @editor.spec.subspecs[0].source_files = new_source_files
        expect(@editor.spec.subspecs[0].source_files).to eq(new_source_files)
      end

      it 'update invalid key will add new key to spec' do
        expect(@editor.spec.invlid_key).to eq(nil)
        new_value = 'value'
        @editor.spec.invlid_key = new_value
        expect(@editor.spec.invlid_key).to eq(new_value)
      end
    end

    describe 'generate json content' do
      before :context do
        @editor = generate_normal_editor
      end

      it 'current json content' do
        expect(@editor.current_json_content).to eq(origin_json_content)
      end

      it 'update value then generate json' do
        @editor.spec.name = 'NewTestPod'
        new_dependencies = OpenStruct.new('Masonry' => [])
        @editor.spec.subspecs[0].dependencies = new_dependencies
        expect(@editor.spec.subspecs[0].dependencies).to eq(new_dependencies)

        new_json_content = File.read(File.expand_path('fixtures/A_t.podspec.json', __dir__)).chomp
        expect(@editor.current_json_content).to eq(new_json_content)
      end
    end
  end
end
