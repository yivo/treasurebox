def rename_fonts(dir, oldname, newname)
  weight_transformations = {
    'blackitalic'       => 'BlackItalic',
    'black'             => 'Black',

    'extrathin'         => 'ExtraThin',
    'extrathinitalic'   => 'ExtraThinItalic',
    'ultralight'        => 'UltraLight',
    'ultralightitalic'  => 'UltraLightItalic',

    'light'             => 'Light',
    'lightitalic'       => 'LightItalic',

    'medium'            => 'Medium',
    'mediumitalic'      => 'MediumItalic',

    'regular'           => 'Regular',
    'regularitalic'     => 'RegularItalic',

    'bold'              => 'Bold',
    'bolditalic'        => 'BoldItalic',

    'ultrablack'        => 'UltraBlack',
    'ultrablackitalic'  => 'UltraBlackItalic',

    'xthin'             => 'XThin',
    'thin'              => 'Thin',
    'thinitalic'        => 'ThinItalic',

    'semibold'          => 'SemiBold',
    'semibolditalic'    => 'SemiBoldItalic',

    'extrabold'         => 'ExtraBold',
    'extrabolditalic'   => 'ExtraBoldItalic',
    'heavy'             => 'Heavy',

    'italic'            => 'RegularItalic'
  }

  Dir[File.join(dir, '**/*.{woff,woff2,ttf,eot,svg}')].each do |path|
    basename  = File.basename(path, '.*')
    extname   = File.extname(path)

    next unless basename =~ /\A#{oldname}/i
    weight    = basename.gsub(/\A#{oldname}[-_]?/i, '').gsub(/webfont\z/i, '')
    name      = "#{newname}-#{weight_transformations[weight] || weight}#{extname}"

    unless File.basename(path) == name
      File.rename File.expand_path(path), File.join(File.dirname(File.expand_path(path)), name)
      puts "#{File.basename(path).ljust(40)} => #{name}"
    end
  end
end

require 'commander/import'

program :name,        'fonts_renamer'
program :version,     '1.0.0'
program :description, 'Tool for normalizing font names.'
default_command       :rename

command :rename do |c|
  c.syntax = 'ruby fonts_renamer.rb --dir ~/Downloads/OpenSans --oldname opensans --newname OpenSans'

  c.option '--dir DIR',                     String,  'Directory with fonts'
  c.option '--oldname OLDNAME',             String,  'Old (current) font name'
  c.option '--newname NEWNAME',             String,  'New font name'

  c.action do |args, options|
    fail 'Please specify directory using --dir DIR'              unless options.dir
    fail "Invalid directory specified or directory doen't exist" unless Dir.exists?(options.dir)
    fail 'Please specify old font name using --oldname OLDNAME'  unless options.oldname
    fail 'Please specify new font name using --newname NEWNAME'  unless options.newname

    rename_fonts(options.dir, options.oldname, options.newname)
    exit 0
  end
end
