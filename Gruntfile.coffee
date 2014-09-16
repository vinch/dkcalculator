module.exports = (grunt) ->
  grunt.initConfig {
    pkg: grunt.file.readJSON 'package.json'
    concat: {
      dist: {
        src: [
          'bower_components/angular/angular.js'
          'bower_components/modernizr/modernizr.js'
        ]
        dest: 'public/js/dist/components.js'
      }
    }
    uglify: {
      options: {
        report: 'min'
      }
      build: {
        src: 'public/js/dist/components.js'
        dest: 'public/js/dist/components.min.js'
      }
    }
  }

  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask 'components', ['concat', 'uglify']