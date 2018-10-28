angular.module('fareastAdmin.modules.broadcastings.controllers').controller('Reports', [
  '$scope', '$timeout', 'Report',
  function($scope, $timeout, Report) {
    var loadData = function() {
      Report.query({}).then(
        function(data) {
          $scope.reports = new Report(data);
        }
      );
    };

    var poll = function () {
      $timeout(poll, 5000);
      loadData();
    };

    poll();
  }
]);
