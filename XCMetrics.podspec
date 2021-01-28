Pod::Spec.new do |s|
    s.name         = 'XCMetrics'
    s.version      = '0.0.1'
    s.summary      = 'See the README.'
    s.homepage     = 'https://github.com/Spotify/XCMetrics'
    s.license      = { type: 'Apache 2.0', text: '© 2020 Spotify, Inc.' }
    s.authors      = 'Spotify'    
    s.source       = { :http => "#{s.homepage}/releases/download/v#{s.version}/XCMetrics-macOS-x86_64-v#{s.version}.zip" }
    s.preserve_paths = '**/*'
    s.exclude_files  = '**/file.zip'
end
