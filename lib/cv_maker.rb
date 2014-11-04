require 'redcarpet'
require 'handlebars'

require './lib/context_maker'

class CVMaker
  def initialize(lang = nil)
    @handlebars = Handlebars::Context.new
    register_hb_helpers

    @context = ContextMaker.new(lang).context
  end

  def register_hb_helpers
    @handlebars.register_helper('md') do |context, value|
      Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(value)
    end

    @handlebars.register_helper('join') do |context, items, joiner|
      "#{items.join(joiner)}"
    end

    @handlebars.register_helper('each_values') do |context, hash, block|
      hash.values.reverse.map do |value|
        "#{block.fn(value)}"
      end.join("")
    end
  end

  def template
    File.read('templates/body.hbs')
  end

  def render
    @handlebars.compile(template).send(:call, @context)
  end

  def write(to)
    File.open(to, 'w') do |file|
      file.write(render)
    end
  end
end
