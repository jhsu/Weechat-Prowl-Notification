#!/usr/bin/env ruby
# Author: Joseph "jshsu" Hsu <jhsu@josephhsu.com>
# File: prowl_notify.rb
#
# Send notification to Prowl
#
# Requirements:
#   - gem install httparty
#
#   Copyright (C) 2010 Joseph Hsu
# 
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
# 
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
# 
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'httparty'

SCRIPT_NAME = 'prowl_notify'
SCRIPT_AUTHOR = 'Joseph Hsu <jhsu@josephhsu.com.com>'
SCRIPT_DESC = 'Prowl Notifications'
SCRIPT_VERSION = '0.1'
SCRIPT_LICENSE = 'GPL3'

class Prowl
  include HTTParty
  base_uri 'https://prowl.weks.net/publicapi'

  attr_accessor :api_key

  def initialize(api_key)
    @api_key = api_key
  end

  def notify(message)
    if message && !message.empty?
      message = message.gsub(/^\S+\s/, '')
      message = message.gsub(/jshsu:\s+/, '')
      self.class.post('/add', :query => {:apikey => @api_key, :application => "irc", :event => "message", :description => message})
    end
  end
end

def weechat_init
  Weechat.register SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", ""
  Weechat.config_set_plugin("api_key", "") if !Weechat.config_is_set_plugin("api_key")
  Weechat.hook_signal("weechat_highlight", "send_message", "")

  return Weechat::WEECHAT_RC_OK
end

def send_message(data, signal, msg)
  api_key = Weechat.config_get_plugin("api_key")
  if api_key
    @prowl = Prowl.new(api_key)
    @prowl.notify(msg)
  end
  return Weechat::WEECHAT_RC_OK
end
