require 'cocoapods'

RSpec.describe Podspec::Editor do
  it 'has a version number' do
    expect(Podspec::Editor::VERSION).not_to be nil
  end

  def origin_json_content
    File.read(File.expand_path('fixtures/A.podspec.json', __dir__))
  end

  def generate_normal_editer
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
        editer = generate_normal_editer
        expect(editer.origin_json_content).to eq(origin_json_content)
      end

      it 'initialize with a spec path will not raise error' do
        editer = PodspecEditor::Editor.new(
          spec_path: File.expand_path('fixtures/A.podspec', __dir__)
        )
        expect(editer.origin_json_content).to eq(origin_json_content)
      end
    end

    it 'generate default template for pod' do
      content = PodspecEditor::Editor.default_json_spec_content('RxSwift')
      expect(content) == "{\n  \"name\": \"RxSwift\",\n  \"version\": \"1.0.0\",\n  \"summary\": \"TestPod summary\",\n  \"lic...\n  \"homepage\": \"https://www.example.com\",\n  \"platforms\": {\n    \"ios\": \"9.0\"\n  },\n}\n"
    end

    it 'get value from spec' do
      editer = generate_normal_editer
      kvs = [
        editer.spec.name => 'TestPod',
        editer.spec.version => '1.0.0',
        editer.spec.license => 'MIT',
        editer.spec.requires_arc => true,
        editer.spec.key_not_exist => nil,
        editer.spec.authors => OpenStruct.new('test' => 'test@test.com'),
        editer.spec.subspecs[0].name => 'SubSpecA',
        editer.spec.subspecs[0].dependencies => OpenStruct.new('Masonry': [], 'ReactiveObjC': [], 'SDWebImage': [])
      ]
      kvs.each do |kv|
        kv.each do |k, v|
          expect(k).to eq(v)
        end
      end
    end

    describe 'delete value from spec' do
      before :context do
        @editer = generate_normal_editer
      end

      it 'delete normal key' do
        @editer.spec.name = nil
        expect(@editer.spec.name).to eq(nil)

        @editer.spec.authors = nil
        expect(@editer.spec.authors).to eq(nil)
      end

      it 'delete non-exist key' do
        @editer.spec.key_not_exist = nil
        expect(@editer.spec.key_not_exist).to eq(nil)
      end

      it 'delete nested key' do
        @editer.spec.subspecs[0].source_files = nil
        expect(@editer.spec.subspecs[0].source_files).to eq(nil)
      end
    end

    describe 'update value from spec' do
      before :context do
        @editer = generate_normal_editer
      end

      it 'update first level key' do
        expect(@editer.spec.name).to eq('TestPod')
        new_name = 'NewTestPod'
        @editer.spec.name = new_name
        expect(@editer.spec.name).to eq(new_name)
      end

      it 'update nested key' do
        expect(@editer.spec.subspecs[0].name).to eq('SubSpecA')
        new_name = 'newNameA'
        @editer.spec.subspecs[0].name = new_name
        expect(@editer.spec.subspecs[0].name).to eq(new_name)

        new_source_files = ['A.h']
        @editer.spec.subspecs[0].source_files = new_source_files
        expect(@editer.spec.subspecs[0].source_files).to eq(new_source_files)
      end

      it 'update invalid key will add new key to spec' do
        expect(@editer.spec.invlid_key).to eq(nil)
        new_value = 'value'
        @editer.spec.invlid_key = new_value
        expect(@editer.spec.invlid_key).to eq(new_value)
      end
    end

    describe 'generate json content' do
      before :context do
        @editer = generate_normal_editer
      end

      it 'current json content' do
        expect(@editer.current_json_content).to eq(origin_json_content)
      end

      it 'update value then generate json' do
        @editer.spec.name = 'NewTestPod'
        new_dependencies = OpenStruct.new('Masonry' => [])
        @editer.spec.subspecs[0].dependencies = new_dependencies
        expect(@editer.spec.subspecs[0].dependencies).to eq(new_dependencies)

        new_json_content = File.read(File.expand_path('fixtures/A_t.podspec.json', __dir__)).chomp
        expect(@editer.current_json_content).to eq(new_json_content)
      end
    end
  end
end
