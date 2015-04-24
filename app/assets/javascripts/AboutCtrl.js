controllersModule.controller('AboutCtrl', function ($scope) {
  $scope.myInterval = 3000;
  var slides = $scope.slides = [
  {image: '/assets/images/steal_img1', text: 'Jean-Paul is a self-driven technology guy, passionate about computing and motivated to learn something new every day'}, 
  {image: '/assets/images/steal_image2', text: 'Even if your position is awesome, Luigi IS NOT interested in anything but Scala … or maybe Haskell :)'},
  {image: '/assets/images/steal_image3', text: 'What ever you are trying to achieve, Philippe can be a value to your team'},
  {image: '/assets/images/steal_image4', text: 'Giancarlo...hm...well, didnt like talking about himself too...much'}
  ];

});