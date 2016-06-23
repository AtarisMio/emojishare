
do (_, document, angular, modules, APP_NAME = 'Gyro') ->
    angular.module APP_NAME, modules

        .config _.ai '$routeProvider, $locationProvider',
            (         $routeProvider, $locationProvider) ->

                $routeProvider



                    .when '/', {
                        controller: 'HomepageCtrl as self'
                        templateUrl: 'controller/homepage/homepage.tmpl.html'
                        # resolve:
                        #     user: _.ai 'api, $location, $q',
                        #         (       api, $location, $q) ->
                        #             api.fetch_current_user().catch (data)=>
                        #                 return data
                    }

                    .otherwise redirectTo: '/'


                $locationProvider
                    .html5Mode true
                    .hashPrefix '!'



        .config _.ai '$provide, build_timestamp', ($provide, build_timestamp) ->
            return unless build_timestamp

            HOLDER = '{ts}'
            TPR = 'totalPendingRequests'

            $provide.decorator '$templateRequest', _.ai '$delegate', ($delegate) ->

                wrapper = (tpl, ignoreRequestError) ->

                    if /// ^/? ( components | static | assets ) ///.test tpl
                        if not /// #{ HOLDER } ///.test tpl
                            tpl += if /\?/.test(tpl) then '&' else '?'
                            tpl += '_t=' + HOLDER

                    return $delegate tpl.replace(HOLDER, build_timestamp), ignoreRequestError

                return {}.constructor.defineProperty wrapper, TPR, get: -> $delegate[TPR]


        .constant 'baseURI', document.baseURI

        .constant 'build_timestamp', do (src = document.getElementById('main-script')?.src) ->
            1000 * (src?.match(/t=([^&]+)/)?[1] or '0')


    angular.element(document).ready ->
        angular.bootstrap document, [APP_NAME], strictDi: true
