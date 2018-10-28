angular.module('fareast.modules.map.controllers').controller('Map', [
  '$scope', '$location', '$window', 'Broadcasting', 'Building', 'Locality',
  function($scope, $location, $window, Broadcasting, Building, Locality) {

    $scope.$location = $location;

    $scope.resetScope = function() {
      $scope.activeTabName = "map";

      $scope.isActiveMapTab = false;
      $scope.isActiveListTab = false;
      $scope.isActiveGalleryTab = false;

      $scope.buildings = [];
      $scope.districts = [];
      $scope.localities = [];

      $scope.queryString = '';

      $scope.regionId = '';
      $scope.districtId = '';
      $scope.localityName = '';
      $scope.broadcastState = 'active';
    }();

    $scope.broadcaststates = [{
      name: I18n.t("js.translation_status.select.all"),
      value: "all"
    }, {
      name: I18n.t("js.translation_status.select.active"),
      value: "active"
    }, {
      name: I18n.t("js.translation_status.select.outdated"),
      value: "outdated"
    }, {
      name: I18n.t("js.translation_status.select.inactive"),
      value: "inactive"
    }, {
      name: I18n.t("js.translation_status.select.finished"),
      value: "finished"
    }];

    $scope.initialize = function() {
      var initQuery = $scope.$location.search();
      $scope.buildScopeFromUrl(initQuery);
      setActiveTab();

      Locality.query({}).then(
        function(data) {
          $scope.regions = data.regions;

          $scope.getDistricts();
          $scope.getLocalities();

          $scope.searchByQuery();

          refreshFilterSelects();
        }
      );
    };

    var buildQuery = function() {

      var query = {
        "q[name_or_description_or_district_region_name_or_district_name_or_locality_cont]": $scope.queryString,
        "q[district_region_id_eq]": $scope.regionId,
        "q[district_id_eq]": $scope.districtId,
        "q[locality_eq]": $scope.localityName
      };
      return query;
    };

    var buildFilterStateQuery = function() {
      var query = {
        "regionId": $scope.regionId,
        "districtId": $scope.districtId,
        "localityName": $scope.localityName,
        "queryString": $scope.queryString,
        "broadcastState": $scope.broadcastState,
        "activeTabName": $scope.activeTabName
      };
      return $scope.$location.search(query);
    };

    $scope.$on('$locationChangeSuccess', function() {
      if (_.isEmpty($scope.$location.search())) {
        $window.location.reload();
      }
    });

    $scope.$on('ngRepeatFinished', function(ngRepeatFinishedEvent) {
      $scope.showTabContent = true;
    });

    $scope.buildScopeFromUrl = function(initQuery) {
      $scope.regionId =  _.isUndefined(initQuery.regionId) ? $scope.regionId : initQuery.regionId;
      $scope.districtId = _.isUndefined(initQuery.districtId) ? $scope.districtId : initQuery.districtId;
      $scope.localityName = _.isUndefined(initQuery.localityName) ? $scope.localityName : initQuery.localityName;
      $scope.queryString = _.isUndefined(initQuery.queryString) ? $scope.queryString : initQuery.queryString;
      $scope.broadcastState = _.isUndefined(initQuery.broadcastState) ? $scope.broadcastState : initQuery.broadcastState;
      $scope.activeTabName = _.isUndefined(initQuery.activeTabName) ? $scope.activeTabName : initQuery.activeTabName;
    };

    $scope.getDistricts = function() {
      if ($scope.regionId) {
        $scope.districts = _.find($scope.regions, function(region) {
          return region.id == $scope.regionId;
        }).districts;
      }
    };

    $scope.getLocalities = function() {
      if ($scope.districtId) {
        $scope.localities = _.find($scope.districts, function(district) {
          return district.id == $scope.districtId;
        }).localities;
        $scope.localities = _.uniq($scope.localities);
      }
    };

    $scope.searchByQuery = function() {
      $scope.showTabContent = false;
      buildFilterStateQuery();
      var query = buildQuery();

      Building.search(query).then(function(buildings) {
        if ($scope.broadcastState !== "all") {
          $scope.buildings = _.filter(buildings, function(building) {
            return building.status == $scope.broadcastState;
          });

          // Reset order numbers
          _.each($scope.buildings, function(item, key) {
            item.number = key + 1;
          });

        } else {
          $scope.buildings = buildings;
        }

        if ($scope.broadcastState == "finished") {
          $scope.insertFinishedImages();
        }

        if (_.isEmpty($scope.buildings)) {
          $scope.showTabContent = true;
        }

        $scope.getDistricts();
        $scope.getLocalities();

        refreshFilterSelects();

        $scope.mapRedraw();
      });
    };

    $scope.insertFinishedImages = function() {

      _.each($scope.buildings, function(item) {
          var finishedDate = item.getFinishedDate();

          item.finishedPath = finishedDate;

          Broadcasting.getAvailableTimestamps(item.slug, finishedDate).then(
            function(available_timestamps) {

              var finishedImageTimestamp = _.first(available_timestamps);

              var i = 0;
              while (item.broadcastingFinishTime >= available_timestamps[i]) {
                finishedImageTimestamp = available_timestamps[i];
                i++;
              }

              item.finishedImageName = finishedImageTimestamp;
            });
      });
    };

    $scope.selectRegion = function() {
      clearDistricts();
      clearLocalities();

      $scope.getDistricts();
      $scope.searchByQuery();
    };

    $scope.selectDistrict = function() {
      clearLocalities();

      $scope.getLocalities();
      $scope.searchByQuery();
    };

    refreshFilterSelects = function() {
      $("select.fmap-filter-select").trigger('render');
      var parentWidth = parseInt($(".customSelect:eq(0)").outerWidth(), 10);
      $(".customSelectInner").css({
        display: "block",
        width: parentWidth + "px"
      });
    };

    clearDistricts = function() {
      $scope.districts = [];
      $scope.districtId = '';
    };

    clearLocalities = function() {
      $scope.localities = [];
      $scope.localityName = '';
    };

    $scope.mapRedraw = function() {
      $scope.$broadcast("mapRedraw");
    };

    $scope.loadImages = function() {
      $scope.showImages = true;
    };

    $scope.saveActiveTab = function(tabName) {
      $scope.activeTabName = tabName;

      setActiveTab();
      buildFilterStateQuery();
    };

    var setActiveTab = function() {

      $scope.isActiveMapTab = false;
      $scope.isActiveListTab = false;
      $scope.isActiveGalleryTab = false;

      switch ($scope.activeTabName) {
        case 'map': $scope.isActiveMapTab = true; break;
        case 'list': $scope.isActiveListTab = true; break;
        case 'gallery': $scope.isActiveGalleryTab = true; break;
      }
    };

    $scope.initialize();

}]).config([ '$locationProvider', function($locationProvider) {

  $locationProvider.html5Mode(false).hashPrefix('!');

}]);
