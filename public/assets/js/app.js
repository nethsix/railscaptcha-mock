$('.blacktile').click(function(event) {
    if (!$(event.target).closest('.popup').length) {
        $(this).fadeOut();
    }
});

$('.js-close').click(function(event) {
    $('.blacktile').fadeOut();
});

$('.js-privacy-popup').click(function(event) {
    $('.blacktile .privacypolicy').parent().fadeIn();
});

$('.js-terms-popup').click(function(event) {
    $('.blacktile .termsofservice').parent().fadeIn();
});

$('.w-nav-menu a').on('click', function() {
    $('.w-nav-button').removeClass('w--open');
    $('.w-nav-menu').removeClass('w--nav-menu-open');
});

$('body').click(function () {
    $('.alert:not(.no-fade)').fadeOut();
});

$('ul.tabs li').click(function(){
    var tab_id = $(this).attr('id');

    $('ul.tabs li').removeClass('current');
    $('.tab-content').removeClass('current');

    $(this).addClass('current');
    $("div#"+tab_id).addClass('current');
});

$('.circle-help').tooltip();

hljs.initHighlightingOnLoad();

$(".highlight.copyable").each(function() {
    $(this).before('<div class="zero-clipboard"><span class="btn-clipboard">Copy</span></div>');
});

ZeroClipboard.config({
    swfPath: '/assets/swf/ZeroClipboard.swf',
    hoverClass: "btn-clipboard-hover"
});

var client = new ZeroClipboard($('.btn-clipboard'));
var bridge = $("#global-zeroclipboard-html-bridge");

client.on('ready', function() {
    bridge.data("placement", "auto").attr("title", "Copy to clipboard").tooltip();
});

client.on('beforecopy', function(e) {
    var code = $(e.target).parent().nextAll('.highlight').first().text();
    client.setText(code);
});

client.on('aftercopy', function(e) {
    bridge.attr("title", "Copied!").tooltip("fixTitle").tooltip("show").attr("title", "Copy to clipboard").tooltip("fixTitle")
});

client.on('error', function(e) {
    bridge.attr("title", "Flash required").tooltip("fixTitle").tooltip("show")
});

angular.module('panel', [
    'restangular',
    'ui.bootstrap',
    'localytics.directives',
    'dateRangePicker',
    'angular-flot',
    'angular.filter'
]);

angular.module('panel').factory('$api', function($rootScope, Restangular, $window) {
    return Restangular.withConfig(function(RestangularConfigurer) {
        RestangularConfigurer.setBaseUrl($window.config.endpoint);
        if ($window.config.customerKey) {
            RestangularConfigurer.setDefaultRequestParams({ api_key: $window.config.customerKey });
        }
        RestangularConfigurer.setRequestInterceptor(function(element, operation, route, url) {
            $('.overflow').fadeIn();
            return element;
        });
        RestangularConfigurer.addResponseInterceptor(function(data, operation, what, url, response, deferred) {
            $('.overflow').fadeOut();
            return data;
        });
        RestangularConfigurer.setErrorInterceptor(function(response, deferred, responseHandler) {
            $('.overflow').fadeOut();
            return false;
        });
    });
});

angular.module('panel').run(function($rootScope, $window) {

    $rootScope.customerKey = $window.config.customerKey;

    var opts = {
        lines: 7,
        length: 35,
        width: 10,
        radius: 20,
        corners: 1,
        rotate: 12,
        direction: 1,
        color: '#fff',
        speed: 1,
        trail: 60,
        shadow: false,
        hwaccel: true,
        className: 'spinner',
        zIndex: 2e9,
        top: '50%',
        left: '50%'
    };

    var target = document.getElementById('spinner');
    var spinner = new Spinner(opts).spin(target);

});

angular.module('panel').controller('MetricsCtrl', function($scope, $api) {

    $scope.app = { site_key: null, secret_key: null };
    $scope.type = 'verification';
    $scope.interval = '1-day'; // default interval

    var format = 'YYYY-MM-DDTHH:mm:ss', initialized = false, raw;

    var getColor = function(index) {
        var colors = ['red', 'green'];
        return colors[index] || 'defaultFill';
    };

    var renderKpis = function (data) {
        var kpis;
        if ($scope.type == 'verification') {
            kpis = {
                rate: { raw: data.rate, pretty: numeral(data.rate / 100).format('0%') },
                spend: { raw: data.spend, pretty: numeral(data.spend).format('$0,0.00') },
                transactions: { raw: data.transactions, pretty: numeral(data.transactions).format('0.[0a]') },
                latency: { raw: data.latency, pretty: numeral(data.latency).format('00:00:00') }
            };
        } else {
            kpis = {
                rate: { raw: data.rate, pretty: numeral(data.rate / 100).format('0%') },
                spend: { raw: data.spend, pretty: numeral(data.spend).format('$0,0.00') },
                transactions: { raw: data.transactions, pretty: numeral(data.transactions).format('0.[0a]') }
            };
        }
        $scope.kpis = kpis;
    };

    var renderChart = function (data) {

        var lines, chart;

        var timeUnitSize = {
            "second": 1000,
            "minute": 60 * 1000,
            "hour": 60 * 60 * 1000,
            "day": 24 * 60 * 60 * 1000,
            "month": 30 * 24 * 60 * 60 * 1000,
            "quarter": 3 * 30 * 24 * 60 * 60 * 1000,
            "year": 365.2425 * 24 * 60 * 60 * 1000
        };

        var tickFormatter = function(value, axis) {
            var d = moment(value);

            var t = axis.tickSize[0] * timeUnitSize[axis.tickSize[1]];
            var span = axis.max - axis.min;
            var fmt;

            if (t < timeUnitSize.minute) {
                fmt = 'LT';
            } else if (t < timeUnitSize.day) {
                fmt = 'LT';
                if (span < 2 * timeUnitSize.day) {
                    fmt = 'LT';
                } else {
                    fmt = 'MMM D LT';
                }
            } else if (t < timeUnitSize.month) {
                fmt = 'MMM D';
            } else if (t < timeUnitSize.year) {
                if (span < timeUnitSize.year) {
                    fmt = 'MMM';
                } else {
                    fmt = 'MMM YY';
                }
            } else {
                fmt = 'YY';
            }

            return d.format(fmt);
        };

        data = _.transform(data, function (result, data, timestamp) {
            timestamp = moment.unix(timestamp).valueOf();
            result.transactions.push([timestamp, data.transactions]);
            if (data.rate !== null) {
                result.conversion.push([timestamp, data.rate]);
            }
        }, { conversion: [], transactions: [] });

        lines = [{
            label: 'Transactions',
            data: data.transactions,
            color: '#9dbbcd',
            lines: {
                show: true,
                fill: false
            },
            shadowSize: false,
            hoverable: true
        }, {
            label: 'Success Rate',
            data: data.conversion,
            yaxis: 2,
            color: '#c7cbcd',
            lines: {
                show: true,
                fill: false
            },
            shadowSize: false,
            hoverable: true
        }];

        var options = {
            xaxes: [{
                mode: "time",
                tickFormatter: tickFormatter,
                ticks: 4
            }],
            yaxes: [{
                min: 0,
                tickFormatter: function(value) {
                    return numeral(value).format('0.[0]a');
                }
            }, {
                alignTicksWithAxis: 1,
                position: 'right',
                tickFormatter: function(v, axis) {
                    return numeral(v / 100).format('0%');
                },
                min: 0,
                max: 100,
            }],
            grid: {
                show: true,
                hoverable: true,
                backgroundColor: '#ffffff',
                borderWidth: 0,
                tickColor: '#ebf0f2',
                margin: 0
            },
            series: {
                points: {
                    show: true,
                    radius: 3
                },
                lines: {
                    fill: false
                },
                stack: false
            },
            hoverable: true,
            legend: {
                noColumns: 2,
                position: 'se'
            },
            lines: {
                show: true,
                fill: true
            }
        };

        chart = $('#chart').plot(lines, options).data('plot');
    };

    var renderChoropleth = function (data) {

        var width = 1157, height = 960, map, popup, projection;

        data = _.transform(data, function (result, item, key) {
            var rank = 0;
            if (item.rate > 90) {
                rank++;
            }
            item.fillKey = 'blue';
            result[key.toUpperCase()] = item;
        });

        popup = _.template($('#choropleth-popup').text());

        projection = function (element) {
            var projection, path;
            projection = d3.geo.mercator()
                .scale((width + 1) / 2 / Math.PI)
                .translate([width / 2, height / 2])
                .precision(.1);
            path = d3.geo.path().projection(projection);
            return { path: path, projection: projection };
        }

        map = new Datamap({
            element: $('#choropleth').empty().get(0),
            height: height,
            width: width,
            geographyConfig: {
                dataUrl: '/assets/data/world.json',
                highlightFillColor: '#2D4A59',
                highlightBorderColor: '#2D4A59',
                highlightBorderWidth: 0,
                popupTemplate: function(geo, data) {
                    return popup({
                        geo: geo,
                        data: data,
                        isFree: $scope.isFree
                    });
                }
            },
            scope: 'countries',
            fills: {
                blue: '#9DBBCD',
                defaultFill: '#DDD'
            },
            data: data,
            setProjection: projection
        });
    };

    var render = function (data) {
        data = data[$scope.type];
        renderKpis(data['total']);
        renderChart(data['timestamp']);
        renderChoropleth(data['country']);
    };

    var update = function () {
        $api.one('metrics').get({
            from: $scope.from.format(),
            to: $scope.to.format(),
            apps: $scope.app.site_key
        }).then(function (response) {
            raw = response;
            render(raw);
        });
    };

    var updateInterval = function (interval) {
        if (interval) {
            var chunks = interval.split('-'),
                duration = +chunks[0],
                type = chunks[1];
            $scope.to = moment.utc().add(1, 'hour').startOf('hour');
            $scope.from = $scope.to.clone().subtract(duration, type);
            $scope.range = null; // Reset date range picker
            update();
        }
    }

    $scope.$watch('interval', function (newValue, oldValue) {
        if (newValue !== oldValue || !initialized) {
            updateInterval(newValue);
            initialized = true;
        }
    });

    $scope.$watch('app', function (newValue, oldValue) {
        if (newValue !== oldValue) {
            if (!newValue) {
                $scope.app = { site_key: null, secret_key: null };
            } else {
                $scope.app = angular.fromJson(newValue);
            }
            update();
        }
    });

    $scope.$watch('type', function (newValue, oldValue) {
        if (newValue !== oldValue) {
            render(raw);
        }
    });

    $scope.$watch('range', function (newValue, oldValue) {
        if (newValue && newValue !== oldValue) {
            $scope.from = moment.utc(newValue.start);
            $scope.to = moment.utc(newValue.end).clone().add(1, 'day'); // add 1 day because interval in metrics API is [from, to)
            $scope.interval = null;
            update();
        }
    });
});
