platform :ios, '12.2'

use_frameworks!

workspace 'AppHubWorkspace'

#core module
def login_pods
    pod 'Moya'
end

target 'Login' do
    project 'Login/Login.project'
    login_pods
end

#application
def apphub_pods
    login_pods
end

target 'AppHub' do
    project 'AppHub/AppHub.project'
    apphub_pods
end
