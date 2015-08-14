(function () {
	angular.module('navModule', [])
		 .config([

	function () {
		console.log("Nav Module::config");
	}])
		 .run([

	function () {
		console.log("Nav Module::running");
	}])
	// controllers
	.controller('NavCtrl', [
		 '$scope', '$location', function ($scope, $location) {
		 	// Controll Top Navigation menu here
		 	this.nav = ["home", "about"];

		 	// scope
		 	$scope.isActive = function (viewLocation) {
		 		return viewLocation === $location.path();
		 	};
		 }]);
})();