
do (_, angular) ->
    angular.module('controller').controller 'HomepageCtrl',

        _.ai '            @$scope, @$rootScope, @$window, @$q, @$location, @$document', class
            constructor: (@$scope, @$rootScope, @$window, @$q, @$location, @$document) ->
                # debugger
                @$window.scrollTo 0, 0

                @$rootScope.state = 'landing'

                angular.extend @$scope, {
                    down: true
                    page_path: @$location.absUrl()
                    loading: true
                    show_float_coupon: false
                }
                
                @$scope.$on '$viewContentLoaded',()->
	                class waterFall
                        MIN_COLUMN_COUNT: 2
                        COLUMN_WIDTH: 220
                        CELL_PADDING: 26
                        GAP_HEIGHT: 15
                        GAP_WIDTH: 15
                        THRESHOLD: 2000

                        columnHeights: 0
                        columnCount: 0
                        noticeDelay: null
                        resizeDelay: null
                        scrollDelay: null
                        managing: false
                        loading: false

                        noticeContainer: document.querySelector('#notice')
                        cellsContainer: document.querySelector('#cells')
                        cellTemplate: document.querySelector('#template').innerHTML

                        addEvent: (element, eventName, handler)->
                            if element.addEventListener
                                addEvent = (element, eventName, handler)->
                                    element.addEventListener type, handler, false
                            else if element.attachEvent
                                addEvent = (element, eventName, handler)->
                                    element.attachEvent 'on' + type, handler
                            else
                                addEvent = (element, eventName, handler)->
                                    element['on' + type] = handler
                            addEvent element, eventName, handler

                        getMinVal: (arr)->
                            Math.min.apply Math, arr

                        getMaxVal: (arr)->
                            Math.max.apply Math, arr

                        getMinKey: (arr)->
                            key = 0
                            min = arr[0]
                            i = 1
                            len = arr.length
                            while i < len
                                if arr[i] < min
                                    key = i
                                    min = arr[i]
                                i++
                            key

                        getMaxKey: (arr)->
                            key = 0
                            max = arr[0]
                            i = 1
                            len = arr.length
                            while i < len
                                if arr[i] > max
                                    key = i
                                    max = arr[i]
                                i++
                            key

                        updateNotice: (event)->
                            clearTimeout noticeDelay
                            e = event or window.event
                            target = e.target or e.srcElement
                            if target.tagName == 'SPAN'
                                targetTitle = target.parentNode.tagLine
                                noticeContainer.innerHTML = (if target.className == 'like' then 'Liked ' else 'Marked ') + '<strong>' + targetTitle + '</strong>'
                                noticeContainer.className = 'on'
                                noticeDelay = setTimeout ()->
                                        noticeContainer.className = 'off'
                                    ,2000

                        getColumnCount: ()->
                            Math.max MIN_COLUMN_COUNT, Math.floor (document.body.offsetWidth + GAP_WIDTH) / (COLUMN_WIDTH + GAP_WIDTH)
                        
                        resetHeights: (count)->
                            columnHeights = []
                            while i < count
                                columnHeights.push 0
                                i++
                            cellsContainer.style.width = (count * (COLUMN_WIDTH + GAP_WIDTH) - GAP_WIDTH) + 'px'
                        
                        appendCells: (num)->
                            return if loading
                            # 获取图片

                        adjustCells: (cells,reflow)->
                            columnIndex = 0
                            columnHeight = 0
                            _.forEach cells,(cell)->
                                columnIndex = getMinKey columnHeights
                                columnHeight = columnHeights[columnIndex]
                                cell.style.height = (cell.offsetHeight - CELL_PADDING) + 'px'
                                cell.style.left = columnIndex * (COLUMN_WIDTH + GAP_WIDTH) + 'px'
                                cell.style.top = columnHeight + 'px'
                                columnHeights[columnIndex] = columnHeight + GAP_HEIGHT + cell.offsetHeight
                                unless reflow
                                    cell.className = "cell ready"
                            cellsContainer.style.height = (getMaxVal columnHeights) + 'px'
                            do manageCells

                        reflowCells: ()->
                            columnCount = do getColumnCount
                            unless columnHeights.length == columnCount
                                resetHeights columnCount
                                adjustCells cellsContainer.children, true
                            else
                                do manageCells

                        manageCells: ()->
                            managing = true
                            cells = cellsContainer.children
                            viewportTop = (document.body.scrollTop || document.documentElement.scrollTop) - cellsContainer.offsetTop
                            viewportBottom = (window.innerHeight || document.documentElement.clientHeight) + viewportTop
                            _.forEach cells,()->
                                if cell.offsetTop - viewportBottom > THRESHOLD or viewportTop - cell.offsetTop - cell.offsetHeight > THRESHOLD
                                    if cell.className == 'cell ready'
                                        cell.fragment = cell.innerHTML
                                        cell.innerHTML = ''
                                        cell.className = 'cell shadow'
                                else
                                    if cell.className == 'celll shadow'
                                        cell.innerHTML = cell.fragment
                                        cell.className = 'cell ready'
                            if viewportBottom > getMinVal columnHeights
                                appendCells columnCount
                            managing = false

                        delayedScroll: ()->
                            clearTimeout scrollDelay
                            scrollDelay = setTimeout manageCells, 500 unless managing
                        
                        delayedResize: ()->
                            clearTimeout resizeDelay
                            resizeDelay = setTimeout reflowCells, 500

                        init: ()->
                            addEvent cellsContainer, 'click', updateNotice
                            addEvent window, 'resize', delayedResize
                            addEvent window, 'scroll', delayedScroll

                            columnCount = getColumnCount
                            resetHeights columnCount
                            do manageCells

                        constructor: (window, document)->
                            addEvent window, 'load', init
