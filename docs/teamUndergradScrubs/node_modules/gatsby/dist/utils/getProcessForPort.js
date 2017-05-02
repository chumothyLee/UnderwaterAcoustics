'use strict';

var _chalk = require('chalk');

var _chalk2 = _interopRequireDefault(_chalk);

var _child_process = require('child_process');

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var execOptions = {
  encoding: 'utf8',
  stdio: ['pipe', // stdin (default)
  'pipe', // stdout (default)
  'ignore']
};

function isProcessAReactApp(processCommand) {
  return (/^node .*react-scripts\/scripts\/start\.js\s?$/.test(processCommand)
  );
}

function getProcessIdOnPort(port) {
  return (0, _child_process.execSync)('lsof -i:' + port + ' -P -t -sTCP:LISTEN', execOptions).trim();
}

function getPackageNameInDirectory(directory) {
  var packagePath = _path2.default.join(directory.trim(), 'package.json');

  try {
    return require(packagePath).name;
  } catch (e) {
    return null;
  }
}

function getProcessCommand(processId, processDirectory) {
  var command = (0, _child_process.execSync)('ps -o command -p ' + processId + ' | sed -n 2p', execOptions);

  if (isProcessAReactApp(command)) {
    var packageName = getPackageNameInDirectory(processDirectory);
    return packageName ? packageName + '\n' : command;
  } else {
    return command;
  }
}

function getDirectoryOfProcessById(processId) {
  return (0, _child_process.execSync)('lsof -p ' + processId + ' | grep cwd | awk \'{print $9}\'', execOptions).trim();
}

function getProcessForPort(port) {
  try {
    var processId = getProcessIdOnPort(port);
    var directory = getDirectoryOfProcessById(processId);
    var command = getProcessCommand(processId, directory);
    return _chalk2.default.cyan(command) + _chalk2.default.blue('  in ') + _chalk2.default.cyan(directory);
  } catch (e) {
    return null;
  }
}

module.exports = getProcessForPort;