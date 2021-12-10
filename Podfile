platform :ios, '12.2'

use_frameworks!

workspace 'AppHubWorkspace'

#core module
def core_pods
    pod 'Moya'
end

target 'Core' do
    project 'Core/Core.project'
    core_pods
end

#feature module
def login_pods
    pod 'Auth0'
    core_pods
end

target 'Login' do
    project 'Login/Login.project'
    login_pods
end

#application
def apphub_pods
    login_pods
    core_pods
end

target 'AppHub' do
    project 'AppHub/AppHub.project'
    apphub_pods
end
