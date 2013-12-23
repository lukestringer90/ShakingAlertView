Pod::Spec.new do |s|
  s.name         = "ShakingAlertView"
  s.version      = "2.0.0"
  s.summary      = "UIAlertView subclass for secure text entry with a 'shake' animation."
  s.description  = "ShakingAlertView is a UIAlertView subclass with a secure text entry field. Incorrect text entry causes a 'shake' animation similar to the OS X account login screen."
  s.homepage     = "https://github.com/stringer630/ShakingAlertView"
  s.license         = { :type => 'MIT' }
  s.author       = { "Luke Stringer" => "lukestringer630@gmail.com" }
  s.source       = { :git => "https://github.com/stringer630/ShakingAlertView.git", :tag => "2.0.0" }
  s.ios.deployment_target = '5.0'
  s.source_files = 'Classes'
  s.requires_arc = true
end

