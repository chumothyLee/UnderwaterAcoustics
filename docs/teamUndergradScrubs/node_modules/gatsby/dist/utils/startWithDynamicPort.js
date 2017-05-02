'use strict';

var _detectPort = require('detect-port');

var _detectPort2 = _interopRequireDefault(_detectPort);

var _chalk = require('chalk');

var _chalk2 = _interopRequireDefault(_chalk);

var _readline = require('readline');

var _readline2 = _interopRequireDefault(_readline);

var _getProcessForPort = require('./getProcessForPort');

var _getProcessForPort2 = _interopRequireDefault(_getProcessForPort);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var rlInterface = _readline2.default.createInterface({
  input: process.stdin,
  output: process.stdout
});

module.exports = function (startServer) {
  return function (program) {
    var port = typeof program.port === 'string' ? parseInt(program.port, 10) : program.port;

    var existingProcess = (0, _getProcessForPort2.default)(port);

    (0, _detectPort2.default)(port, function (err, _port) {
      if (err) {
        console.error(err);
        process.exit();
      }

      if (port !== _port) {
        // eslint-disable-next-line max-len
        var question = _chalk2.default.yellow('Something is already running on port ' + port + '.\n' + (existingProcess ? ' Probably:\n  ' + existingProcess + '\n' : '') + '\nWould you like to run the app at another port instead? [Y/n]');

        return rlInterface.question(question, function (answer) {
          if (answer.length === 0 || answer.match(/^yes|y$/i)) {
            program.port = _port; // eslint-disable-line no-param-reassign
          }

          return startServer(program);
        });
      }

      return startServer(program);
    });
  };
};