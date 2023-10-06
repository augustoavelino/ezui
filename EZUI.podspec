Pod::Spec.new do |spec|
  spec.name         = "EZUI"
  spec.version      = "1.3.0"
  spec.summary      = "A framework designed to improve and speed up UI development."
  spec.description  = <<-DESC
  Visual utilities, extension and components. This is a framework designed to improve and speed up UI development, making UI creation much easier and faster, as well as providing resources for Design Systems development.
                   DESC
  spec.homepage     = "https://gitlab.com/highborncow/ezui"
  spec.license      = { :type => "MIT", :file => "LICENSE.txt" }
  spec.author             = { "Augusto Avelino" => "augusto_avelino@icloud.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://gitlab.com/highborncow/ezui.git", :tag => "#{spec.version}" }
  spec.source_files  = ["EZUI/**/*.swift", "EZUI/**/*.h"]
  spec.public_header_files = "EZUI/Framework/EZUI.h"
  spec.swift_version = "5.0"
  spec.requires_arc = true
end
