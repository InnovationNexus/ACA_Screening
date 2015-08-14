angular.module('mainApp', ['eventModule', 'navModule', 'ngRoute', 'footerModule'])
    .config([
        '$routeProvider',
        function ($routeProvider) {
        	//console.log($routeProvider);
        	$routeProvider.
				 when('/home', {
				 	templateUrl: 'home.html',
				 	controller: 'HomeCtrl'
				 }).
				 otherwise({
				 	redirectTo: '/home'
				 });
        	//console.log('Configuration hook');
        }
    ])
    .run([
        function () {
        	/* Run is when the app gets kicked off*/
        	console.log('Run hook');
        }
    ])
    // controllers
    .controller('HomeCtrl', [
        '$scope', function ($scope) {
        	console.log('Home Ctrl Loaded');
        }
    ]);
