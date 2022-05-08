#
#  Be sure to run `pod spec lint CoreDataCombineKit.podspec' to ensure this is a


Pod::Spec.new do |spec|

  spec.name         = "CoreDataCombineKit"

  spec.version      = "0.0.2"

  spec.summary      = "CoreData with Combine"

  spec.description  = "A light weight library for manipulating the main Core Data actions with Combine framework compatibility."

  spec.homepage     = "https://github.com/ramyaimansabry/CoreDataCombineKit"

  spec.license      = 'MIT'

  spec.author       = { "Ramy Sabry" => "ramysabry1996@gmail.com" }

  spec.source       = { :git => "https://github.com/ramyaimansabry/CoreDataCombineKit.git", :tag => "#{spec.version}" }

  spec.source_files  = "CoreDataCombineKit/Source/**/*.{h,m,swift}"
  
end
