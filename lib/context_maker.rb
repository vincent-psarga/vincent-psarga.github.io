require 'yaml'
require './lib/localizer'

class ContextMaker
  def initialize(lang=nil)
    @context = load_yaml('content')
    @localizer = Localizer.new(@context, lang.nil? ? {} : load_yaml(lang))
  end

  def load_yaml(file)
    YAML.load_file("data/#{file}.yml")
  end

  def update_places(data)
    places = @context['places']
    data.each do |key, d|
      d['where'] = places[d['where-uid']]
    end
  end

  def context
    @localizer.localize_context

    update_places(@context['experience']['data'])
    update_places(@context['education']['data'])
    @context
  end
end