require 'yaml'
require 'redcarpet'
require 'handlebars'

class CVMaker
  def initialize(lang)
    @handlebars = Handlebars::Context.new
    register_hb_helpers

    @context = load_yaml('content')
    @i18n = load_yaml(lang)
  end

  def register_hb_helpers
    @handlebars.register_helper('md') do |context, value|
      Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(value)
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

  def get_item(d, path)
    item = d
    until path.empty?
      item = item[path.shift]
    end
    item
  end

  def localize(path)
    item = get_item(@context, path.clone)
    locale = get_item(@i18n, path.clone)

    item['title'] = locale['title']
    item['body'] = locale['body']
  end

  def localize_context
    @context.keys.each {|k| localize([k])}

    @context['experience']['data'].keys.each do |id|
      localize(['experience', 'data', id])
      @context['experience']['data'][id]['keywords'].map! do |kw|
        @i18n['keywords'][kw] || kw
      end
    end

    @context['education']['data'].keys.each do |id|
      localize(['education', 'data', id])
    end

    @context['skills']['data'] = @i18n['skills']['data']
  end

  def context
    localize_context

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
