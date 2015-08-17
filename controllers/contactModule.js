(function () {
	angular.module('contactModule', ['ui.bootstrap'])
		.config([function () { }])
		.run([function () { }])
		// filter used for paging and search 
		.filter('startFrom', function () {
			return function (input, start) {
				if (input) {
					start = +start;
					return input.slice(start);
				}
				return [];
			};
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
						$route.reload(); //refresh page
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
						$('#validation').html('<p>You have successfully created a new contact</p>').removeClass("hidden").addClass("alert alert-success"); //create success message
						$('form').find('input[type=text], input[type=email], input[type=tel], input[type=url]').val(''); //clear fields
					} else {
						$('#validation').html('<p>Contact was not saved</p>').removeClass("hidden").addClass("alert alert-danger"); //create success message
					}
				}, function (response) {
					alert('fail');
				});
			};
			//#endregion

			//#region Reset Create Contact Form
			$scope.reset = function () {
				$route.reload();
			};
			//#endregion
		}])
		.controller('ContactEditCtrl', ['$scope', '$http', '$route', '$routeParams', '$location', function ($scope, $http, $routeParams, $route, $location) {
			$scope.temp = false;

			//#region GET Contact 
			//Setup Contact List GET request variable
			if ($scope.temp === false) {

				var getReq = {
					method: 'GET',
					url: 'http://challenge.acstechnologies.com/api/contact/' + $routeParams.current.params['id'],
					headers: {
						'X-Auth-Token': 'pkNClPIgOp1Oo3mRmIAJRwVL9QuIpbSLsaYKZ08w',
						'Origin': undefined
					}
				};
				// Get Contact List and assign to scope
				$http(getReq).then(function (response) {

					$scope.first_name = response.data.first_name;
					$scope.last_name = response.data.last_name;
					$scope.company_name = response.data.company_name;
					$scope.address = response.data.address;
					$scope.city = response.data.city;
					$scope.state = response.data.state;
					$scope.zip = response.data.zip;
					$scope.phone = response.data.phone;
					$scope.work_phone = response.data.work_phone;
					$scope.email = response.data.email;
					$scope.url = response.data.url;
					$scope.temp = true;
				}, function (response) {
					alert('fail');
				});
			}
			//#endregion

			//#region PUT Contact
			$scope.editContact = function () {

				var putReq = {
					method: 'PUT',
					url: 'http://challenge.acstechnologies.com/api/contact/' + $routeParams.current.params['id'],
					headers: {
						'X-Auth-Token': 'pkNClPIgOp1Oo3mRmIAJRwVL9QuIpbSLsaYKZ08w',
						'Origin': undefined
					},
					data: {
						"first_name": this.first_name,
						"last_name": this.last_name,
						"company_name": this.company_name,
						"address": this.address,
						"city": this.city,
						"state": this.state,
						"zip": this.zip,
						"phone": this.phone,
						"work_phone": this.work_phone,
						"email": this.email,
						"url": this.url
					}
				};


				// Get Contact List and assign to scope
				$http(putReq).then(function (response) {
					alert("Contact Saved");
					$location.path('/View Contact');
				}, function (response) {
					alert('fail');
				});
			}
			//#endregion

		}]);
})();