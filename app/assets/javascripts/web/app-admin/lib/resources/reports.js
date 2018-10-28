angular.module('fareastAdmin.resources.reports', []).factory('Report', [
  'railsResourceFactory', function(railsResourceFactory) {

    var Report = railsResourceFactory({
      url: Routes.web_api_reports_path({format: "json"}),
      name: 'report'
    });

    Report.prototype.getPath = function() {
      return Routes.admin_report_path({id: this.id});
    };

    return Report;
  }
]);