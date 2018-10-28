angular.module('fareast.resources.broadcastings', []).factory('Broadcasting', [
  'railsResourceFactory', function(railsResourceFactory) {

    var Broadcasting = railsResourceFactory({
      url: Routes.web_api_regions_path({format: "json"})
    });

    Broadcasting.getAvailableTimestamps = function(slug, date) {
      var timestampsUrl = gon.base_path + slug + '/' + date + '/index.json';
      return Broadcasting.$get(timestampsUrl).then(
        function(data) {
          return data.listing;
        }
      );
    };

    return Broadcasting;
  }
]);
