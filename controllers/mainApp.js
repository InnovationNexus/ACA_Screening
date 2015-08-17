angular.module('mainApp', ['ngRoute', 'eventModule', 'navModule', 'footerModule', 'contactModule'])
	.config([
		'$routeProvider', function($routeProvider) {
			$routeProvider.
				when('/', {
					templateUrl: 'contactView.html',
					controller: 'ContactViewCtrl'
				}).
				when('/View Contact', {
					templateUrl: 'contactView.html',
					controller: 'ContactViewCtrl'
				}).
				when('/Create Contact', {
					templateUrl: 'contactCreate.html',
					controller: 'ContactCreateCtrl'
				}).
				when('/Edit Contact/:id', {
					templateUrl: 'contactEdit.html',
					controller: 'ContactEditCtrl'
				}).
				otherwise({
					redirectTo: '/contactView'
				});
			//console.log('Configuration hook');
		}
	])
	.run([
		function() {
			/* Run is when the app gets kicked off*/
			//console.log('Run hook');
		}
	]);
