
do (_, angular, Array) ->
    TAKE_RESPONSE_DATA = (response) -> response.data
    TAKE_RESPONSE_ERROR = (q, response) =>
        if response.status is -1
            do window.error_mask
            response.data = {} unless response.data
            response.data.success = false
        q.reject response.data
    angular.module('service').service 'api',

        _.ai '            @user, @$http, @$q, @param, @$sce', class
            constructor: (@user, @$http, @$q, @param, @$sce) ->
                @access_token = 'cookie'
                @user_fetching_promise = null
                @defualt_timeout = 10000
                TAKE_RESPONSE_ERROR = _.partial TAKE_RESPONSE_ERROR, @$q

                @TAKE_RESPONSE_ERROR = TAKE_RESPONSE_ERROR
                @TAKE_RESPONSE_DATA = TAKE_RESPONSE_DATA

                @process_response = (data) =>
                    return @$q.reject(data) unless data?.success is true
                    return data

            get_new_emoji: (page_no=1,page_size=10)->
                query_set = {
                    page: page_no
                    pageSize: page_size
                }

                @$http
                    .get '/api/new_emoji',
                        params: query_set
                        cache: false
                        timeout: @defualt_timeout

                    .then TAKE_RESPONSE_DATA
                    .catch TAKE_RESPONSE_ERROR