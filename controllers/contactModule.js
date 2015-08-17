(function () {
	angular.module('contactModule', ['ui.bootstrap'])
		.config([function () {
			//console.log("Contact Module::running");
		}])
		.run([function () {
			//console.log("Contact Module::running");
		}])
		.filter('startFrom', function() {
			return function(input, start) {
				if (input) {
					start = +start;
					return input.slice(start);
				}
				return [];
			}
		})
		.controller('ContactViewCtrl', ['$scope', '$http', 'filterFilter', function ($scope, $http, filterFilter) {
			$scope.orderByField = 'first_name';
			$scope.reverseSort = false;

			//#region Get Contact List JSON
			//Setup Contact List GET Request
			var req = {
				method: 'GET',
				url: 'http://challenge.acstechnologies.com/api/contact/',
				headers: {
					'X-Auth-Token': 'pkNClPIgOp1Oo3mRmIAJRwVL9QuIpbSLsaYKZ08w',
					'Origin': undefined
				}
			};
			// Get Contact List and assign to scope
			$http(req).then(function (response) {
				$scope.contactList = response.data.data;

				//#region Paging - Paging for contact list
				$scope.currentPage = 1; //current page
				$scope.maxSize = 5; //pagination max size
				$scope.entryLimit = 5; //max rows for data table
				



				/* init pagination with $scope.list */
				$scope.noOfPages = Math.ceil($scope.contactList.length / $scope.entryLimit);

				$scope.$watch('search', function (term) {
					// Create $scope.filtered and then calculat $scope.noOfPages, no racing!
					$scope.filtered = filterFilter($scope.contactList, term);
					$scope.noOfPages = Math.ceil($scope.filtered.length / $scope.entryLimit);
					$scope.totalItems = $scope.filtered.length;
				});
				//#endregion
			}, function (response) {
				alert('fail');
			});
			//#endregion
		}])
		.controller('ContactCreateCtrl', ['$scope', '$http', function ($scope, $http) {
			$scope.addContact = function () {
				//setup Contact Create POST Request
				var req = {
					method: 'POST',
					url: 'http://challenge.acstechnologies.com/api/contact/',
					headers: {
						'X-Auth-Token': 'pkNClPIgOp1Oo3mRmIAJRwVL9QuIpbSLsaYKZ08w',
						'Origin': undefined
					},
					data: {
						"first_name": $scope.first_name,
						"last_name": $scope.last_name,
						"company_name": $scope.company_name,
						"address": $scope.address,
						"city": $scope.city,
						"state": $scope.state,
						"zip": $scope.zip,
						"phone": $scope.phone,
						"work_phone": $scope.work_phone,
						"email": $scope.email,
						"url": $scope.url
					}
				};

				$http(req).then(function (response) {

					if (response.data["success"] === false) {
						console.log(response.data["errors"]["first_name"]);

						//for (var i = 0; i < response.data["errors"].length; i++) {
						//	alert('test');
						//}
					} else {
						$('#validation').append('<p>You have successfully created a new contact</p>').removeClass("hidden").addClass("alert alert-success");
					}
				}, function (response) {
					alert('fail');
				});
			};

			//$scope.reset = function () {
			//	$scope.first_name = "";
			//			"last_name": $scope.last_name,
			//			"company_name": $scope.company_name,
			//			"address": $scope.address,
			//			"city": $scope.city,
			//			"state": $scope.state,
			//			"zip": $scope.zip,
			//			"phone": $scope.phone,
			//			"work_phone": $scope.work_phone,
			//			"email": $scope.email,
			//			"url": $scope.url
			//	$('#validation').hide();
			//};
		}]);
})();