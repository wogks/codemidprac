// ignore_for_file: constant_identifier_names

import 'dart:io';

const ACCESS_TOKEN_KEY = 'accesstoken';
const REFRESH_TOKEN_KEY = 'refreshtoken';
const emulatorIp = '10.0.2.2:3000';
const simulatorIp = '127.0.0.1:3000';
final ip = Platform.isIOS ? simulatorIp : emulatorIp;
