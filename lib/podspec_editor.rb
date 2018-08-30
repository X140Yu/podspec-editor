require 'podspec_editor/version'
require 'pathname'
require 'ostruct'
require 'json'

module PodspecEditor
  class Helper
    def self.openstruct_to_hash(object, hash = {})
      return object unless object.is_a?(OpenStruct)
      object.each_pair do |key, value|
        hash[key] = if value.is_a?(OpenStruct)
                      openstruct_to_hash(value)
                    elsif value.is_a?(Array)
                      value.map { |v| openstruct_to_hash(v) }
                    else
                      value
                    end
      end
      hash
    end
  end

  class Spec
    attr_accessor :inner_spec

    def initialize(json_content)
      @inner_spec = JSON.parse(json_content, object_class: OpenStruct)
    end

    # read
    def method_missing(method, *args, &block)
      inner_spec.send(method, *args, &block)
    end
  end

  class Editor
    attr_accessor :origin_json_content
    attr_accessor :spec

    def self.default_json_spec_content(pod_name)
      content = File.read(File.expand_path('TEMPLATE.podspec.json', __dir__))
      content.gsub('POD_NAME', pod_name)
    end

    def spec_to_json(spec_path)
      Pod::Specification.from_file(spec_path).to_pretty_json.chomp
    end

    def initialize(args)
      json_path = args[:json_path]
      if json_path
        unless Pathname.new(json_path).exist?
          raise ArgumentError, "invalid json path #{json_path}"
        end

        @origin_json_content = File.read(json_path).chomp
      end

      json_content = args[:json_content]
      @origin_json_content = json_content if json_content

      spec_path = args[:spec_path]
      if spec_path
        unless Pathname.new(spec_path).exist?
          raise ArgumentError, "invalid spec path #{spec_path}"
        end

        @origin_json_content = spec_to_json spec_path
      end

      @spec = Spec.new @origin_json_content
    end

    def current_hash
      Helper.openstruct_to_hash(@spec.inner_spec)
    end

    def current_json_content
      JSON.pretty_generate(current_hash)
    end
  end
end
