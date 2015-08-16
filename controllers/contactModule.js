﻿(function () {
	angular.module('contactModule', ['ui.bootstrap'])
		.config([
				function () {
					//console.log("Contact Module::running");
				}
		])
		.run([
			function () {
				//console.log("Contact Module::running");
			}
		])
		.controller('ContactViewCtrl', ['$scope', '$http',
			function ($scope, $http) {
				var req = {
					method: 'GET',
					url: 'http://challenge.acstechnologies.com/api/contact/',
					headers: {
						'X-Auth-Token': 'pkNClPIgOp1Oo3mRmIAJRwVL9QuIpbSLsaYKZ08w',
						'Origin': undefined
					}
				};
				$http(req).then(function (response) {
					$scope.contactList = response.data.data;

					//#region Paging - Paging for contact list
					$scope.itemsPerPage = 5;
					$scope.currentPage = 1;
					$scope.totalItems = $scope.contactList.length;

					$scope.pageCount = function () {
						return Math.ceil($scope.contactList.length / $scope.itemsPerPage);
					};

					$scope.$watch('currentPage + itemsPerPage', function () {
						var begin = (($scope.currentPage - 1) * $scope.itemsPerPage), end = begin + $scope.itemsPerPage;
						$scope.filteredContacts = $scope.contactList.slice(begin, end);
					});

					//#endregion
				}, function (response) {
					alert('fail');
				});

			}
		]);

})();