Pod::Spec.new do |spec|

  spec.name         = "TBRefreshView"
  spec.version      = "1.5.2"
  spec.summary      = "TBRefreshView provides three loading method in UITableView or UICollectionView: pull to refresh,  scroll to bottom to refresh and loading."

  spec.homepage     = "https://github.com/teambition/RefreshView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "bruce" => "liangmingzou@163.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/teambition/RefreshView.git", :tag => "#{spec.version}" }
  spec.swift_version = "5.0"

  spec.source_files  = "Sources/*.swift"
  spec.resource_bundles = {
    "RefreshView" => ["Resource/*"]
  }
  spec.frameworks   = "Foundation", "UIKit"

end
