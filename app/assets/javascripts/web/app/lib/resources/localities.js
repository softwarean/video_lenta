angular.module('fareast.resources.localities', []).factory('Locality', [
  'railsResourceFactory', function(railsResourceFactory) {

    var Locality = railsResourceFactory({
      url: Routes.web_api_regions_path({format: "json"})
    });

    return Locality;
  }
]);
