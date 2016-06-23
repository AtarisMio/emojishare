
do (angular) ->
    angular.module('directive').directive 'siteHeader', ->
        restrict: 'AE'
        replace: true
        templateUrl: 'controller/header/header.tmpl.html'

        controller: _.ai '@$element, @$location, @$rootScope', class
            constructor: (@$element, @$location, @$rootScope) ->
                return;

        controllerAs: 'self'
