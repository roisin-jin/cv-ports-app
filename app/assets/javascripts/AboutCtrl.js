controllersModule.controller('AboutCtrl', function ($scope) {
  $scope.myInterval = 5000;
  var slides = $scope.slides = [
  {image: '/assets/images/steal_img1.jpg', text: 'Jean-Paul is passionate about computing and motivated to learn something new every day'}, 
  {image: '/assets/images/steal_image2.jpg', text: 'Even if your position is awesome, Luigi IS NOT interested in anything but Scala … or maybe Haskell :)'},
  {image: '/assets/images/steal_image3.jpg', text: 'What ever you are trying to achieve, Philippe can be a value to your team'},
  {image: '/assets/images/steal_image4.jpg', text: 'Giancarlo...hm...well, didnt like talking about himself too...much'}
  ];

});