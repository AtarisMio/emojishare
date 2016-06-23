
do (angular) ->

    custom = '
        filter
        factory
        service
        provider
        directive
        controller

    '.split ' '

    for name in custom
        angular.module name, []

    @modules = custom.concat '
        ngRoute
        ngCookies
        ngSanitize
        ngTouch
    '.split ' '
