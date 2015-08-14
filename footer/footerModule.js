(function () {

	angular.module('footerModule', [])
		 .config([
			  function () {
			  	console.log("Footer Module::config");
			  }
		 ])
		 .run([
			  function () {
			  	console.log("Footer Module::running");
			  }
		 ])
		 // controllers
		 .controller('FootCtrl', [
			  '$scope', '$location', function ($scope, $location) {
			  }
		 ]);

})();