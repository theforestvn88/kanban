module.exports = {
    setupFilesAfterEnv: ['./jest.setup.js'],
    testMatch: ['**/jest/**/*.test.js'],
    cacheDirectory: './tmp/cache/jest',
    moduleNameMapper: {
      '@javascripts(.*)$': '<rootDir>/app/javascript$1',
    },
    testEnvironment: 'jsdom',
    transformIgnorePatterns: ['/node_modules/(?!(el-transition|)/)'],
    transform: {
      '^.+\\.(js|jsx)$': 'babel-jest',
    }
};