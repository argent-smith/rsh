$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'util'))
require 'rsh'
require 'rshc'
require 'ag_utils'
require 'rspec'
require 'rspec/autorun'
