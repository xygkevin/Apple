# AppleCarthagePublish
carthage 仓库发布指引

## 发布Framework
1. carthage版本 0.29.0 or lower 支持静态库；之后的版本仅支持动态framework
2. 在Demo工程中创建 Framework的时候，必须打开 framework 的 Scheme 的 Shared
3. 在 Framework工程文路径下运行：` carthage build --no-skip-current`
4. 发布 git tag，使用 ` git tag #tag_name# `

## 集成Framework
1. Get Carthage by running brew install carthage or choose another installation method
2. Create a Cartfile in the same directory where your `.xcodeproj` or `.xcworkspace` is 
3. List the desired dependencies in the Cartfile, for example:
    ` github "Alamofire/Alamofire" ~> 4.7.2 // 4.7.2 is release tag `
4. Run `carthage update`
    A Cartfile.resolved file and a Carthage directory will appear in the same directory where your .xcodeproj or .xcworkspace is

5. Drag the built .framework binaries from Carthage/Build/<platform> into your application’s Xcode project.

6. If you are using Carthage for an application, follow the remaining steps, otherwise stop here.

7. On your application targets’ `Build Phases settings` tab, click the + icon and choose `New Run Script` Phase. Create a Run Script in which you specify your shell (ex: /bin/sh), add the following contents to the script area below the shell:

`/usr/local/bin/carthage copy-frameworks`

Add the paths to the frameworks you want to use under “Input Files". For example:

`$(SRCROOT)/Carthage/Build/iOS/Alamofire.framework`
