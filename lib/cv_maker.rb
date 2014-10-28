require 'yaml'
require 'redcarpet'
require 'handlebars'

class CVMaker
  def initialize(source)
    @source = source
    @handlebars = Handlebars::Context.new
    register_hb_helpers
  end

  def register_hb_helpers
    @handlebars.register_helper('md') do |context, value|
      Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(value)
    end
  end

  def template
    File.read('templates/body.hbs')
  end

  def context
    YAML.load_file("data/#{@source}.yml")
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
