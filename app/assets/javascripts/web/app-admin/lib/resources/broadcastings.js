angular.module('fareastAdmin.resources.broadcastings', []).factory('Broadcasting', [
  'railsResourceFactory', function(railsResourceFactory) {

    var Broadcasting = railsResourceFactory({
      url: Routes.web_api_regions_path({format: "json"})
    });

    Broadcasting.getAvailableTimestamps = function(player_path, date) {
      var timestampsUrl = player_path + moment(new Date(date)).format("YYYY/MM/DD") + '/index.json';
      return Broadcasting.$get(timestampsUrl).then(
        function(data) {
          return data.listing;
        },
        function() {
          $("#dataIsNotAvailable").show();
        }
      );
    };

    return Broadcasting;
  }
]);
