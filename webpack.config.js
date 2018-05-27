const path = require('path');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const webpack = require('webpack');
const autoprefixer = require('autoprefixer');
const dateFormat = require('dateformat');
const packageJson = require('./package.json');
const GitRevisionPlugin = require('git-revision-webpack-plugin')

const LOAD_FONT_FROM_CDN = [{
	loader: "file-loader", 
	options: {
		name: "[name].[ext]",
		outputPath: "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/fonts/"
	}
}];

const EMBED_FONT = [{loader: "url-loader?prefix=font/&limit=5000000"}];
const isProd = process.env.npm_lifecycle_event === 'build';
const gitRevisionPlugin = new GitRevisionPlugin();

function commitHash() {
	try {
		return gitRevisionPlugin.commithash();
	}
	catch(doNothing) {
		return null;
	}
}

function linkToCommit() {
	var commit = commitHash();

	return packageJson.repository.url + (commit ? 'commit/'+commit : '');
}

module.exports = {
	entry: "./src/js/index.js",
	output: {
		path: path.join(__dirname, "dist"),
		libraryTarget: "var",
		library: "Application",
		filename: "all.js"
	},
	resolve: {
		extensions: ['.js', '.elm'],
		modules: ['node_modules']
	},
	module: {
		noParse: /\.elm$/,
		rules: [ {
			test: /\.css$/,
			use: ['style-loader', 'css-loader']
		}, {
			test: /\.scss$/,
			use: [ 'style-loader', 'css-loader', 'sass-loader' ]
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
		}, {
			test: /\.elm$/,
			exclude: [/elm-stuff/, /node_modules/],
			use: 'elm-webpack-loader'
		}]
	},
	plugins: [
		new UglifyJsPlugin(),
		new webpack.LoaderOptionsPlugin({ options: { postcss: [autoprefixer()] } }),
		new webpack.DefinePlugin({
			BUILD_TIMESTAMP: JSON.stringify(dateFormat(new Date(), 'dd.mm.yyyy HH:MM:ss')),
			PRODUCTION: JSON.stringify(isProd),
			VERSION: JSON.stringify(packageJson.version),
			COMMIT: JSON.stringify(commitHash()),
			LINK_TO_COMMIT: JSON.stringify(linkToCommit())
		})
	],
	performance: { hints: false },
	mode: 'production'
}

if (!isProd) {
	module.exports.devServer = {
		historyApiFallback: true,
		contentBase: './src',
		hot: true
	};
}
