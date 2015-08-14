(function () {
	angular.module('eventModule', [])
		 .config([function () {
		 	console.log("Event Module:: config");
		 }])
		 .run([function () {
		 	console.log("Event Module::running");
		 }])
		 .controller('EventCtrl', ['$scope', function ($scope) {

		 }])
	// directives
	.directive('myNav', function () {
		return {
			restrict: 'E', //E = element, A = attribute, C = class, M = comment   
			templateUrl: './nav/nav.html',
			controller: function ($scope) {
				console.log("Nav Loaded");
			}, //Embed a custom controller in the directive
			link: function ($scope, element, attrs) { } //DOM manipulation
		};
	})
		 .directive('myFoot', function () {
		 	return {
		 		restrict: 'E', //E = element, A = attribute, C = class, M = comment   
		 		templateUrl: './footer/footer.html',
		 		controller: function ($scope) {
		 			console.log("Footer Loaded");
		 		}, //Embed a custom controller in the directive
		 		link: function ($scope, element, attrs) { } //DOM manipulation
		 	};
		 });
})();