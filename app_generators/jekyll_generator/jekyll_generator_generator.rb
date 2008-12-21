class JekyllGeneratorGenerator < RubiGen::Base

  default_options :author => 'FIXME', :email => 'FIXME', :theme => 'plain'

  attr_reader :author, :email, :title, :name, :theme

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @name             = base_name
    @title            = base_name.humanize
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory ''
      BASEDIRS.each { |path| m.directory path }

      m.dependency "#{theme}_theme", [], :destination => destination_root, :collision => :force
    end
  end

  protected
    def banner
      <<-EOS
Creates a Jekyell static website including Disqus comment system.

USAGE: #{spec.name} path/to/website
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      opts.on("-a", "--author=\"Your Name\"", String,
              "Your name will be pre-populated throughout website",
              "Default: FIXME") { |v| options[:author] = v }
      opts.on("-e", "--email=\"your@email.com\"", String,
              "Your email will be pre-populated throughout website",
              "Default: FIXME") { |v| options[:email] = v }
      opts.on("--title=\"Your Project\"", String,
              "Your project's human title",
              "Default: current folder name") { |v| options[:title] = v }
      opts.on("-t", "--theme=THEME", String,
              "Initial layouts, css, images from a theme.",
              "Available: plain, textmate",
              "Default: plain") { |v| options[:theme] = v }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      @author = options[:author]
      @email  = options[:email]
      @theme  = options[:theme]

      @title  = options[:title] if options[:title]
    end

    # Installation skeleton.  Intermediate directories are automatically
    # created so don't sweat their absence here.
    BASEDIRS = %w(
      _posts
      layouts
      css
      images
    )
end
