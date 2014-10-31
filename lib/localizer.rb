class Localizer
  def initialize(context, i18n)
	@context = context
	@i18n = i18n
  end

  def localized_attributes
  	['title', 'body']
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
    return if locale.nil?

    localized_attributes.each {|key| item[key] = locale[key]}
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

end