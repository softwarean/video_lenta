angular.module('fareast.directives')
.directive('yaMap', ['$q', '$window', function($q, $window) {

  return {
    restrict: "E",

    scope: {
      yaCenter: '@',
      yaZoom: '@',
      yaControls: '@',
      yaIconImageHref: '@',
      yaSource: '='
    },

    controller: [ "$scope", "$window", function($scope, $window) {
      $scope.FareastBalloonContentLayoutClass = "";

      angular.element($window).bind('resize', function() {
        redrawMapEnvironmet();
      });

      var redrawMapEnvironmet = function() {
        var mapViewportHeight = parseInt($(window).height(), 10) - parseInt($('.motto').outerHeight(), 10) - parseInt($('.fmap-navbar').outerHeight(), 10) - parseInt($('.nav-tabs').outerHeight(), 10) - parseInt($('.footer').outerHeight(), 10);

          if ( mapViewportHeight <= 650 ) {
            mapViewportHeight = 650;
          }

          var mapObjectListHeight = mapViewportHeight - parseInt($('.fmap-panel-map .fmap-panel-header').outerHeight(), 10);

          $('ya-map, .fmap-panel-map').css({
            height: mapViewportHeight + 'px'
          });

          $('.fmap-panel-map .fmap-panel-body').css({
            height: mapObjectListHeight + 'px',
            maxHeight: mapObjectListHeight + 'px'
          });

          $scope.map.container.fitToViewport();
      };

      $scope.$on('mapRedraw', function() {
        if ($scope.mapIsLoaded) {
          redrawMapEnvironmet();
        }
      });
    }],

    link: function(scope, element, attr, controller) {

      var getEvalOrValue = function(value){
        try{
            return scope.$eval(value);
        }catch(e){
            return value;
        }
      };

      scope.mapIsLoaded = false;

      var yaMapLoadPromise = function() {
        var deferred = $q.defer();

        scope.$watch('mapIsLoaded', function(mapIsLoaded) {
          if (mapIsLoaded) {
            deferred.resolve();
          }
        });

        return deferred.promise;
      }();

      yaMapLoadPromise.then(function() {});

      ymaps.ready(function(){
        var mapCenter = getEvalOrValue(scope.yaCenter);

        scope.map = new ymaps.Map(element[0], {
          center: mapCenter,
          zoom: scope.yaZoom,
          controls: []
        }, {
          minZoom: 5
        });

        scope.map.behaviors.disable("scrollZoom");

        scope.map.controls.add("zoomControl", {
          position: {
            top: 100,
            right: 10
          }
        });

        scope.mapIsLoaded = true;
        scope.$broadcast("mapRedraw");
        scope.$digest();
      });


      scope.$watch('yaSource', function(newGeoObjects, oldGeoObjects) {
        if (newGeoObjects == oldGeoObjects) {
          return;
        }
        yaMapLoadPromise.then(function() {

          if (!scope.FareastBalloonContentLayoutClass) {
            scope.FareastBalloonContentLayoutClass = ymaps.templateLayoutFactory.createClass([

              '<div class="fmap-item fmap-item-baloon">',
                  '<a class="fmap-item-link" href="{{ properties.path }}" target="_blank">',
                    '<div class="fmap-item-number">{{ properties.iconContent }}</div>',
                    '<div class="fmap-item-summary">',
                      '<div class="fmap-item-name">{{ properties.balloonContentHeader }}</div>',
                      '<p>{{ properties.description }}</p>',
                    '</div>',
                    '<div class="fmap-item-controls">',
                      '<div class="fmap-item-button-broadcast {{properties.status}}">{{ properties.statusname}}</div>',
                    '</div>',
                  '</a>',
              '</div>'
            ].join(''));
          }

          if (!scope.FareastClusterContentLayoutClass) {
            scope.FareastClusterContentLayoutClass = ymaps.templateLayoutFactory.createClass([
              '<div class="fmap-panel fmap-panel-cluster">',
                '<div class="fmap-panel-header">',
                  'Объектов: {{properties.geoObjects.length}}',
                '</div>',
                '<div class="fmap-panel-body">',
                  '{% for geoObject in properties.geoObjects %}',
                    '<div class="fmap-item">',
                        '<a class="fmap-item-link" href="{{ geoObject.properties.path }}" target="_blank">',
                          '<table>',
                            '<tr>',
                              '<td>',
                                '<div class="fmap-item-number">{{ geoObject.properties.iconContent }}</div>',
                              '</td>',
                              '<td>',
                                '<div class="fmap-item-summary">',
                                  '<div class="fmap-item-name">{{ geoObject.properties.balloonContentHeader }}</div>',
                                  '<p>{{ geoObject.properties.description }}</p>',
                                '</div>',
                              '</td>',
                              '<td>',
                                '<div class="fmap-item-controls">',
                                  '<div class="fmap-item-button-broadcast {{geoObject.properties.status}}" title="{{geoObject.properties.statusname}}"></div>',
                                '</div>',
                              '</td>',
                            '</tr>',
                          '</table>',
                        '</a>',
                    '</div>',
                  '{% endfor %}',
                '</div>',
              '</div>'
            ].join(''));
          }

          scope.map.geoObjects.removeAll();

          if (scope.yaSource.length > 0) {
            var myClusterer = new ymaps.Clusterer({
              clusterBalloonContentLayout: scope.FareastClusterContentLayoutClass,
              clusterOpenBalloonOnClick: true,
              clusterBalloonMaxHeight: 390,
              clusterBalloonMaxWidth: 560,
              zoomMargin: 10
            });

            _.each(scope.yaSource, function(newGeoObject) {

              var markerParams = newGeoObject.getMarkerProps();

              var tempObject = new ymaps.GeoObject(
                markerParams,  {
                  iconLayout: 'default#imageWithContent',
                  iconImageHref: scope.yaIconImageHref,
                  iconImageSize: [32, 49],
                  iconImageOffset: [-16, -49],
                  iconContentOffset: [0, 7],
                  balloonContentLayout: scope.FareastBalloonContentLayoutClass
              });

              myClusterer.add(tempObject);
            });

            scope.map.setBounds(myClusterer.getBounds(), {
              checkZoomRange: true
            });

            scope.map.geoObjects.add(myClusterer);
          }

        });
      });

    }

  };
}]);
