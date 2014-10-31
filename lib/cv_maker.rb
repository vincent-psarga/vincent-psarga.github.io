require 'yaml'
require 'redcarpet'
require 'handlebars'

require './lib/localizer'

class CVMaker
  def initialize(lang)
    @handlebars = Handlebars::Context.new
    register_hb_helpers

    @context = load_yaml('content')
    @localizer = Localizer.new(@context, load_yaml(lang))
  end

  def register_hb_helpers
    @handlebars.register_helper('md') do |context, value|
      Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(value)
    end

    @handlebars.register_helper('join') do |context, items, joiner|
      "#{items.join(joiner)}"
    end
  end

  def template
    File.read('templates/body.hbs')
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

    @context['experience']['data'] = @context['experience']['data'].values
    @context['education']['data'] = @context['education']['data'].values

    @context
  end

  def render
    @handlebars.compile(template).send(:call, context)
  end

  def write(to)
    File.open(to, 'w') do |file|
      file.write(render)
    end
  end
end
