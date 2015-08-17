(function () {
	angular.module('contactModule', ['ui.bootstrap'])
		.config([function () {
			//console.log("Contact Module::running");
		}])
		.run([function () {
			//console.log("Contact Module::running");
		}])
		// filter used for paging and search 
		.filter('startFrom', function () {
			return function (input, start) {
				if (input) {
					start = +start;
					return input.slice(start);
				}
				return [];
			}
		})
		// directive creating confirmation message.  must use confirmed-click to call funciton and ng-confirm-click to trigger confirmation box
		.directive('ngConfirmClick', [function () {
			return {
				link: function (scope, element, attr) {
					var msg = attr.ngConfirmClick || "Are you sure?";
					var clickAction = attr.confirmedClick;
					element.bind('click', function (event) {
						if (window.confirm(msg)) {
							scope.$eval(clickAction);
						}
					});
				}
			};
		}])
		.controller('ContactViewCtrl', ['$scope', '$http', '$route', 'filterFilter', function ($scope, $http, $route, filterFilter) {
			//#region Sort Variables
			$scope.orderByField = 'first_name';
			$scope.reverseSort = false;
			//#endregion

			//#region GET Contact List
			//Setup Contact List GET request variable
			var getReq = {
				method: 'GET',
				url: 'http://challenge.acstechnologies.com/api/contact/',
				headers: {
					'X-Auth-Token': 'pkNClPIgOp1Oo3mRmIAJRwVL9QuIpbSLsaYKZ08w',
					'Origin': undefined
				}
			};
			// Get Contact List and assign to scope
			$http(getReq).then(function (response) {
				$scope.contactList = response.data.data;

				//#region Paging for contact list
				$scope.currentPage = 1; //current page
				$scope.maxSize = 10; //pagination max size
				$scope.entryLimit = 10; //max rows for data table

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

			//#region DELETE Contact
			$scope.delete = function (id) {
				// setup contact DELETE request variable
				var delReq = {
					method: 'DELETE',
					url: 'http://challenge.acstechnologies.com/api/contact/' + id,
					headers: {
						'X-Auth-Token': 'pkNClPIgOp1Oo3mRmIAJRwVL9QuIpbSLsaYKZ08w',
						'Origin': undefined
					}
				};

				$http(delReq).then(function (response) {
					if (response.data["success"] === true) {
						$('#validation').html('<p>You have successfully deleted a contact</p>').removeClass("hidden").addClass("alert alert-success");
						$route.reload();
					} else {
						alert(response.data["success"]);
					}
				}, function (response) {
					alert('fail');
				});
			};
			//#endregion
		}])
		.controller('ContactCreateCtrl', ['$scope', '$http', '$route', function ($scope, $http, $route) {
			//#region Create Contact
			$scope.addContact = function () {
				//setup Contact Create POST request variable
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
				// Post new Contact
				$http(req).then(function (response) {
					if (response.data["success"] === true) {
						$('#validation').html('<p>You have successfully created a new contact</p>').removeClass("hidden").addClass("alert alert-success");
						$('form').find('input[type=text]').val('');
					} else {
						alert(response.data["success"]);
					}
				}, function (response) {
					alert('fail');
				});
			};
			//#endregion

			//#region Reset Create Contact Form
			$scope.reset = function () {
				$route.reload();
				//$scope.first_name = "";
				//$scope.last_name = "";
				//$scope.company_name = "";
				//$scope.address = "";
				//$scope.city = "";
				//$scope.state = "";
				//$scope.zip = "";
				//$scope.phone = "";
				//$scope.work_phone = "";
				//$scope.email = "";
				//$scope.url = "";
				//$('#validation').hide();
			};
			//#endregion
		}]);
})();



//$scope.reset = function () {
//$route.reload();
//$scope.first_name = "";
//$scope.last_name = "";
//$scope.company_name = "";
//$scope.address = "";
//$scope.city = "";
//$scope.state = "";
//$scope.zip = "";
//$scope.phone = "";
//$scope.work_phone = "";
//$scope.email = "";
//$scope.url = "";
//$('#validation').hide();
//};
