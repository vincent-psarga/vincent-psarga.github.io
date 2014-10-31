require 'sass'

class SassCompiler
	def compile
		Dir.entries('assets/sass/').each do |source|
			next if File.directory?(File.join('/your_dir', source)) || source.start_with?('_')
			next unless source.end_with?('.sass')
			source = source.split('.sass').first

			engine = Sass::Engine.new(File.read("assets/sass/#{source}.sass"), :syntax => :sass)
			File.open("assets/stylesheets/#{source}.css", 'w') do |file|
				file.write(engine.render)
			end
		end
	end
end