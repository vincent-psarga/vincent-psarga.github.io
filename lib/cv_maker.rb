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

  def update_places data, places
    data.each do |d|
      d['where'] = places[d['where-uid']]
    end
  end

  def context
    data = YAML.load_file("data/#{@source}.yml")
    places = data['places']
    update_places(data['experience']['data'], places)
    update_places(data['education']['data'], places)
    data
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
