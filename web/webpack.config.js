const webpack = require('webpack');

module.exports = {
  entry: "./index.js",
  resolve: {
    extensions: [".js"],
  },
  output: {
    filename: "sqlite-wasm-http-[name].js",
    clean: true,
    asyncChunks: false,
  },
  module: {
    rules: [
      /*{
        test: /\.wasm$/,
        type: "asset/inline",
      },*/
      /*{
        test: /worker\.js$/,
        loader: 'worker-loader',
        options: {
          inline: 'no-fallback',
        },
      }*/
    ],
  },
  optimization: {
    minimize: true
  },
  /*plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
        maxChunks: 1
    })
  ],*/
};
