# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :shell do
 watch /(data\/.*\.yml|templates\/.*\.hbs)$/ do |yml|
    `bin/data_to_html`
  end

  watch /assets\/sass\/.*\.sass$/ do |sass|
    `bin/sass_to_css`
  end
end