module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/assets/javascripts/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
  ],
  theme: {
    extend: {
      height: {
        '176': '44rem'
      },
      maxHeight: {
        '176': '44rem'
      }
    },
  },
}
