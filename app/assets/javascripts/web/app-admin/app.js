//= require ./broadcast_availability/module
//= require ./datetime/module
//= require_self

angular.module('fareastAdmin.modules', [
  'ui.bootstrap',
  'ngQuickDate',
  'fareastAdmin.modules.broadcastings',
  'fareastAdmin.modules.datetime'
]);
