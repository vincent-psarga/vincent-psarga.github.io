require 'ostruct'
require 'optparse'

require './lib/context_maker'

class CommandLine
  def initialize(args)
    @selected = []
    parse_options(args)
  end

  def available_options
    [
      {
        opt: 'contact',
        key: 'about',
        title: 'Contact information'
      },
      {
        opt: 'about',
        key: 'resume',
        title: 'About me'
      },
      {
        opt: 'experience',
        key: 'experience',
        title: 'My work experiences'
      },
      {
        opt: 'education',
        key: 'education',
        title: 'My diplomas'
      },
      {
        opt: 'skills',
        key: 'skills',
        title: 'My skills'
      },
      {
        opt: 'hobbies',
        key: 'hobbies',
        title: 'My hobbies'
      }
    ]
  end

  def parse_options(args)
    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: bin/show_cv [options]"
      opts.separator "Show cv in terminal"
      opts.separator ""
      opts.separator "Specific options:"

      available_options.each do |option|
        opts.on(nil, "--#{option[:opt]}", option[:title]) do 
          @selected << option[:key]
        end
      end

      opts.on('-a', "--all", "Show the full CV") do  
        @selected = available_options.map {|option| option[:key]}
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end
    opt_parser.parse!(args)
  end

  def show
    @context = ContextMaker.new().context
    available_options.each do |option|
      if @selected.include?(option[:key])
        self.send("show_#{option[:key]}")
        puts ""
      end
    end
  end

  def show_about
    show_title "#{@context['about']['name']} - #{@context['about']['title']}"
    contacts = {"Address" => @context['about']['address']}
    @context['about']['contacts'].each do |c|
      contacts[c['type']] = c['title'].split(':').last.strip
    end
    show_two_columns(contacts)
    puts ""
  end

  def show_resume
    show_title @context['resume']['title']
    puts @context['resume']['body']
  end

  def show_experience
    show_title @context['experience']['title']

    @context['experience']['data'].each do |id, experience|
      show_subtitle("#{experience['title']} - #{experience['dates']}")
      puts "#{experience['where']['name']}, #{experience['where']['location']}"
      puts ""
      puts experience['body']
      puts ""
      puts "Keywords: #{experience['keywords'].join(', ')}"
      puts ""
    end
  end

  def show_education
    show_title @context['education']['title']

    @context['education']['data'].each do |id, education|
      show_subtitle("#{education['title']} - #{education['dates']}")
      puts education['where']['name']
      puts ""
    end
  end

  def show_skills
    show_title(@context['skills']['title'])

    skills = {}
    @context['skills']['data'].each do |skill|
      skills[skill['title']] = skill['body'].join("\n")
    end
    show_two_columns(skills)
  end

  def show_hobbies
    show_title @context['hobbie']['title']
    puts @context['hobbie']['body']
  end

  def underlined(text, underliner)
    puts text
    puts underliner*text.length
  end
  
  def show_title(text)
    underlined(text, '=')
    puts ""
  end

  def show_subtitle(text)
    underlined(text, '-')
  end

  def show_list(items)
    items.each do |item|
      puts "- #{item}"
    end
  end

  def show_two_columns(data)
    first_column_size = data.keys.map(&:length).max + 2

    data.each do |title, value|
      adapted_title = fit_to_length("#{title}:", first_column_size)

      if value.include?("\n")
        lines = value.split("\n")
        puts "#{adapted_title}#{lines.first}"
        lines[1..-1].each do |line|
          puts "#{fit_to_length('', first_column_size)}#{line}"
        end
      else
        puts "#{adapted_title}#{value}"
      end

      puts ""
    end
  end

  def fit_to_length(text, length)
    "#{text}#{' ' * (length - text.length)}"
  end
end