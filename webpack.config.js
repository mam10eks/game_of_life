const path = require('path')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')

const LOAD_FONT_FROM_CDN = [{
	loader: "file-loader", 
	options: {
		name: "[name].[ext]",
		outputPath: "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/fonts/"
	}
}];

const EMBED_FONT = [{loader: "url-loader?prefix=font/&limit=5000000"}];

module.exports = {
	entry: "./src/js/index.js",
	output: {
		path: path.join(__dirname, "build"),
		libraryTarget: "var",
		library: "Application",
		filename: "all.js"
	},
	module: {
		rules: [ {
			test: /\.css$/,
			use: [ {
					loader: "style-loader"
				}, {
					loader: "css-loader"
				}]
		}, {
			test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
			use: LOAD_FONT_FROM_CDN
		}, {
			test: /\.(woff)$/,
			use: LOAD_FONT_FROM_CDN
		}, {
			test: /\.(woff2)$/,
			use: EMBED_FONT
		}, {
			test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
			use: LOAD_FONT_FROM_CDN
		}, {
			test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
			use: LOAD_FONT_FROM_CDN
		}]
	},
	plugins: [
		new UglifyJsPlugin()
	],
	performance: { hints: false },
	mode: "production"
}
