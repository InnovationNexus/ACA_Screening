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
				 when('/about', {
				 	templateUrl: 'about.html',
				 	controller: 'AboutCtrl'
				 }).
				 when('/contact', {
				 	templateUrl: 'contact.html',
				 	controller: 'ContactCtrl'
				 }).
				 when('/portfolio', {
				 	templateUrl: 'portfolio.html',
				 	controller: 'PortCtrl'
				 }).
				 when('/blog', {
				 	templateUrl: 'blog/blog.html',
				 	controller: 'BlogCtrl'
				 }).
				 when('/post/:id', {
				 	templateUrl: 'blog/post.html',
				 	controller: 'PostCtrl'
				 }).
				 when('/createBlog', {
				 	templateUrl: 'blog/createBlog.html',
				 	controller: 'CreateBlog'
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
        	//console.log('Run hook');
        }
    ])
    // controllers
    .controller('HomeCtrl', [
        '$scope', function ($scope) {
        	console.log('Home Ctrl Loaded');
        }
    ]);
