
Pod::Spec.new do |s|

    s.name         = "MRPageView"
    s.version      = "1.0.0"
    s.ios.deployment_target = '8.0'
    s.summary      = "A delightful setting interface framework."
    s.homepage     = "https://github.com/coderLL/PageView"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "coderLL" => "8973223459@qq.com" }
    s.source       = { :git => "https://github.com/coderLL/PageView.git", :tag => s.version }
    s.source_files  = "PageView/*"
    s.resources          = "PageView/PageView.bundle"
    s.requires_arc = true
    
end

