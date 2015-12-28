weight_transformations = {
  'blackitalic'     => 'BlackItalic',
  'black'           => 'Black',
  'extrathin'       => 'ExtraThin',
  'extrathinitalic' => 'ExtraThinItalic',
  'light'           => 'Light',
  'lightitalic'     => 'LightItalic',
  'medium'          => 'Medium',
  'mediumitalic'    => 'MediumItalic',
  'regular'         => 'Regular',
  'regularitalic'   => 'RegularItalic',
  'bold'            => 'Bold',
  'bolditalic'      => 'BoldItalic',
  'ultrablack'      => 'UltraBlack',
  'xthin'           => 'XThin',
  'thin'            => 'Thin',
  'thinitalic'      => 'ThinItalic'
}

Dir['**/*.{woff,woff2,ttf,eot,svg}'].each do |path|
  basename  = File.basename(path, '.*')
  extname   = File.extname(path)

  next unless basename =~ /\A#{ARGV[0]}/i
  weight    = basename.gsub(/\A#{ARGV[0]}[-_]?/i, '').gsub(/webfont\z/i, '')
  name      = "#{ARGV[1]}-#{weight_transformations[weight] || weight}#{extname}"
  File.rename File.expand_path(path), File.join(File.dirname(File.expand_path(path)), name)
  puts "#{path.ljust(40)} => #{name}"
end