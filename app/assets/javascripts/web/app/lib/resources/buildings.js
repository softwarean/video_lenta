angular.module('fareast.resources.buildings', []).factory('Building', [
  'railsResourceFactory', function(railsResourceFactory) {

    var Building = railsResourceFactory({
      url: Routes.web_api_buildings_path({format: "json"})
    });

    Building.search = function(query) {
      return Building.query(query || {}).then(function(data) {
        var newBuildings = [];

        _.each(data.buildings, function(buildingAttrs, index) {

          var building = new Building(buildingAttrs);
          building.number = index + 1;
          building.statusname = I18n.t("js.translation_status." + buildingAttrs.status);

          newBuildings.push(building);
        });

        return newBuildings;
      });
    };

    Building.prototype.getPath = function() {
      return Routes.building_path({id: this.id});
    };

    Building.prototype.getImagePath = function() {
      var imagePath = moment.unix(this.lastFrameTime).utc().format("YYYY/MM/DD") + '/' + this.lastFrameTime + '.jpg';

      if (this.status === 'finished') {
        imagePath = this.finishedPath + '/' + this.finishedImageName + ".jpg";
      }

      return gon.base_path + this.slug + '/' +  imagePath;
    };

    Building.prototype.getFinishedDate = function() {
      return moment.unix(this.broadcastingFinishTime).utc().format('YYYY/MM/DD');
    };

    Building.prototype.hasImage = function() {
      return (this.slug !== "") && (this.lastFrameTime !== 0);
    };

    Building.prototype.getMarkerProps = function() {
      var markerProps = {
        geometry: {
          type: "Point",
          coordinates: [this.latitude, this.longitude]
        },
        properties: {
          iconContent: this.number,
          id: this.id,
          description: this.region.name + ", " + this.district + ", " + this.locality,
          balloonContentHeader: this.name,
          path: this.getPath(),
          status: this.status,
          statusname: this.statusname
        }
      };

      return markerProps;
    };

    return Building;
  }
]);
