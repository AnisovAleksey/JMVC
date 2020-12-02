platform :ios, '13.0'

flutter_application_path = File.expand_path("./Modules/flutter_game", File.dirname(path))
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'ThemoviedbOne' do
  use_frameworks!
  
  install_all_flutter_pods(flutter_application_path)
  
  pod "Alamofire"
  pod "AlamofireImage"
  pod "SnapKit"


  target 'ThemoviedbOneScreenshotTests' do
    # Pods for testing
  end

  target 'ThemoviedbOneTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
