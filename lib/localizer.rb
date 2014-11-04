class Localizer
  def initialize(context, i18n)
    @context = context
    @i18n = i18n
  end

  def localized_attributes
    ['title', 'body']
  end

  def get_item(d, p)
    path = p.clone
    item = d

    until path.empty?
      break if item.nil?
      item = item[path.shift]
    end
    item
  end

  def walk(path = [], &block)
    item = get_item(@context, path)
    yield item, path.clone
    
    next_keys = [] 
    if item.is_a? Hash
      next_keys = item.keys
    end

    if item.is_a? Array
      next_keys = (0 .. item.size)
    end

    next_keys.each {|k| walk(path.clone.concat([k]), &block)}
  end

  def localize(item, path)
    locale = get_item(@i18n, path)
    return if locale.nil?

    localized_attributes.each do |key|
      item[key] = locale[key] unless locale[key].nil?
    end
  end

  def localize_context
    walk do |item, path|
      if item.is_a?(Hash)
        localize(item, path)
      end

      if item.is_a?(String)
        key = path.pop
        get_item(@context, path)[key] = get_item(@i18n, ['keywords', item]) || item
      end
    end
  end
end