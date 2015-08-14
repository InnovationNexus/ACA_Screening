angular.module('mainApp', ['ngRoute', 'eventModule', 'navModule', 'footerModule'])
    .config([
    '$routeProvider',

function ($routeProvider) {
	//console.log($routeProvider);
	$routeProvider.
	when('/', {
		templateUrl: 'home.html',
		controller: 'HomeCtrl'
	}).
	when('/home', {
		templateUrl: 'home.html',
		controller: 'HomeCtrl'
	}).
	when('/about', {
		templateUrl: 'about.html',
		controller: 'AboutCtrl'
	}).
	otherwise({
		redirectTo: '/home'
	});
	//console.log('Configuration hook');
}])
    .run([

function () {
	/* Run is when the app gets kicked off*/
	//console.log('Run hook');
}])
// controllers
.controller('HomeCtrl', [
    '$scope', function ($scope) {
    	console.log('Home Ctrl Loaded');
    }])
    .controller('AboutCtrl', [
    '$scope', function ($scope) {
    	console.log('About Ctrl Loaded');
    }]);