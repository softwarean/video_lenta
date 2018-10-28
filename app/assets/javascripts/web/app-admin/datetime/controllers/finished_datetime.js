angular.module('fareastAdmin.modules.datetime.controllers').controller('FinishedDatetime', [
  '$scope',
  function($scope) {

    $scope.finishedTimestamp = "";
    $scope.cameraType = gon.camera_type;
    $scope.cameraEnabled = gon.camera_enabled;
    $scope.pollCamera = gon.camera_enabled;
    $scope.userZone = moment().zone();

    $scope.initFinishedTimestamp = function(timestamp) {
      if (timestamp) {
        $scope.finishedDatetime = moment(timestamp).add('m', $scope.userZone).add('m', getTimezoneOffset()).format("YYYY/MM/DD HH:mm");
        $scope.updateTimestamp();
      }
    };

    $scope.updateTimestamp = function() {
      if (_.isNull($scope.finishedDatetime)) {
        $scope.finishedTimestamp = "";
      } else {
        $scope.finishedTimestamp = moment($scope.finishedDatetime).utc().subtract('m', $scope.userZone).subtract('m', getTimezoneOffset()).format();
      }
      $scope.isCameraPolled();
    };

    $scope.isCameraPolled = function() {
      $scope.pollCamera = ($scope.finishedTimestamp !== "" || $scope.cameraType == 'ftp') ? false : $scope.cameraEnabled;
    };

    $scope.disableCameraPoll = function() {
      return $scope.finishedTimestamp || $scope.cameraType == 'ftp';
    };

    var getTimezoneOffset = function() {
       if ($scope.cameraType === 'ftp') {
        return 0;
      } else {
        return gon.timezone_offset;
      }
    };

}]);
