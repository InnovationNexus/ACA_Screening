angular.module('mainApp', ['ngRoute', 'eventModule', 'navModule', 'footerModule', 'contactModule'])
    .config(['$routeProvider', function ($routeProvider) {
    	$routeProvider.
		when('/', {
			templateUrl: 'contactView.html',
			controller: 'ContactViewCtrl'
		}).
		when('/contactView', {
			templateUrl: 'contactView.html',
			controller: 'ContactViewCtrl'
		}).
		when('/about', {
			templateUrl: 'about.html',
			controller: 'AboutCtrl'
		}).
		otherwise({
			redirectTo: '/contactView'
		});
    	//console.log('Configuration hook');
    }])
    .run([function () {
    	/* Run is when the app gets kicked off*/
    	//console.log('Run hook');
    }])
    .controller('AboutCtrl', [function () {
    	console.log('About Ctrl Loaded');
    }]);
