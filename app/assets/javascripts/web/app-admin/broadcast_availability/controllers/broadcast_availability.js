angular.module('fareastAdmin.modules.broadcastings.controllers').controller('BroadcastAvailability', [
  '$scope', 'Broadcasting',
  function($scope, Broadcasting) {

    $scope.opened = false;
    $scope.availabilityDate = moment().format("YYYY/MM/DD");

    var availability_path = gon.player_path;

    $scope.timezoneOffset = (gon.timezone - gon.root_timezone);
    $scope.cameraOffset = gon.timezone;

    $scope.$watch('availabilityDate', function(newDate) {
      Broadcasting.getAvailableTimestamps(availability_path, $scope.availabilityDate).then(
        function(available_timestamps) {

          $scope.available_timestamps = [];
          $scope.allTimestamps = [];
          $scope.allTimestampsGroupByHours = [];

          if (!(_.isUndefined(available_timestamps))) {
            $scope.available_timestamps = available_timestamps;
            $scope.allTimestamps = buildAllTimestamps($scope.available_timestamps);
            $scope.allTimestampsGroupByHours = buildAllTimestampsGroupedbyHours($scope.allTimestamps);
          }

        }
      );
    });

    var buildAllTimestamps = function(available_timestamps) {
      var firstTimestampFromResource = _.first(available_timestamps),
          lastTimestampFromResource = _.last(available_timestamps);

      var step = moment.duration(1, 'minutes').asSeconds();

      // Show line from the hour began
      var firstTimestamp = moment.unix(firstTimestampFromResource).startOf('hour').unix();

      // Fill the statistics till current moment
      var currentTimestamp = moment.utc().zone($scope.cameraOffset).startOf('minute').unix();

      // Get the end of the day
      var lastDayTimestamp = moment.unix(firstTimestampFromResource).utc().endOf('day').startOf('minute').unix();

      var lastTimestamp;
      if (currentTimestamp > lastDayTimestamp) {
        lastTimestamp = lastDayTimestamp;
      } else {
        lastTimestamp = Math.max(currentTimestamp, lastTimestampFromResource);
      }

      return _.range(firstTimestamp, lastTimestamp + step, step);
    };

    var buildAllTimestampsGroupedbyHours = function(all_timestamps) {
      var groupedTimestamps = _.groupBy(all_timestamps, function(timestamp) {
        return moment.unix(timestamp).utc().format("DD.MM.YYYY HH");
      });

      var groupedTimestampsObject = [];

      _.map(groupedTimestamps, function(timestampGroup) {
        var hourObject = {};

        hourObject.title = moment.unix(_.first(timestampGroup)).utc().zone($scope.timezoneOffset).format("HH");
        hourObject.timestamps = _.map(timestampGroup, function(timestamp) {
            var hourTimestampsObject = {};

            hourTimestampsObject.value = timestamp;
            hourTimestampsObject.title = moment.unix(timestamp).utc().zone($scope.timezoneOffset).format("HH:mm");

            return hourTimestampsObject;
        });

        groupedTimestampsObject.push(hourObject);
      });

      return groupedTimestampsObject;
    };

    $scope.isAvailableTimestamp = function(currentTimestamp) {
      return _.contains($scope.available_timestamps, moment.unix(currentTimestamp).startOf('minute').unix());
    };

    $scope.open = function($event) {
      $event.preventDefault();
      $event.stopPropagation();

      $scope.opened = true;
    };

}]);
