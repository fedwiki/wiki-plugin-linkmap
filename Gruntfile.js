module.exports = function (grunt) {
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-git-authors');

  grunt.initConfig({

    authors: {
      prior: [
        "Ward Cunningham <ward@c2.com>",
        "Nicholas Hallahan <nick@theoutpost.io>",
        "Nick Niemeir <nick.niemeir@gmail.com>"
      ]
    },

    coffee: {
      client: {
        expand: true,
        options: {
          sourceMap: true
        },
        src: ['client/*.coffee', 'server/*.coffee'],
        ext: '.js'
      }
    },

    watch: {
      all: {
        files: ['client/*.coffee', 'server/*.coffee'],
        tasks: ['coffee']
      }
    }
  });

  grunt.registerTask('build', ['coffee']);
  grunt.registerTask('default', ['build']);

};
