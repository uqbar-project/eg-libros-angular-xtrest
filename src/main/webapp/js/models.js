function Libro(json) {
  angular.extend(this, json);
  
  this.sosViejo = function() {
    return (new Date().getFullYear() - this.anioPublicacion) > 100
  }
}
